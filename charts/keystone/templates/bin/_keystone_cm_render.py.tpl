#!/usr/bin/env python
import logging
import os
import requests
import sys
import tempfile


try:
    import ConfigParser
    PARSER_OPTS = {}
except ImportError:
    import configparser as ConfigParser
    PARSER_OPTS = {"strict": False}

NAMESPACE = os.environ['KUBERNETES_NAMESPACE']
KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
CONFIG_MAP_NAME = os.environ['CONFIG_MAP_NAME']
DB_USERNAME = os.environ['DB_USERNAME']
DB_PASSWORD = os.environ['DB_PASSWORD']
DB_NAME = os.environ['DB_NAME']
DATABASE_URL = os.environ['DATABASE_URL']
RABBITMQ_URL = os.environ['RABBITMQ_URL']
MEMCACHE_URL = os.environ['MEMCACHE_URL']

LOG_DATEFMT = "%Y-%m-%d %H:%M:%S"
LOG_FORMAT = "%(asctime)s.%(msecs)03d - %(levelname)s - %(message)s"
logging.basicConfig(format=LOG_FORMAT, datefmt=LOG_DATEFMT)
LOG = logging.getLogger(__name__)
LOG.setLevel(logging.INFO)


def read_kube_config():
    global KUBE_HOST, KUBE_TOKEN
    KUBE_HOST = "https://%s:%s" % ('kubernetes.default',
                                    os.environ['KUBERNETES_SERVICE_PORT'])
    with open('/var/run/secrets/kubernetes.io/serviceaccount/token', 'r') as f:
        KUBE_TOKEN = f.read()


def get_configmap_definition(name):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST, NAMESPACE, name)
    LOG.info('Request kubernetes configmaps url %s.', url)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    return resp.json()


def update_configmap(name, configmap):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST, NAMESPACE, name)
    resp = requests.put(url,
                        json=configmap,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot update configmap %s.', name)
        LOG.error(resp.text)
        return False
    return True


def update_connection_fields(content):
    tmp = tempfile.NamedTemporaryFile(prefix='tmp', suffix='.ini', dir='/tmp')
    with open(tmp.name, 'w') as f:
        f.write(content)
    config = ConfigParser.RawConfigParser(**PARSER_OPTS)
    config.read(tmp.name)
    conn_info = "mysql+pymysql://" + DB_USERNAME + ":" + DB_PASSWORD + "@" + DATABASE_URL + "/" + DB_NAME
    config.set("database", "connection", conn_info)
    config.set("DEFAULT", "transport_url", RABBITMQ_URL)
    config.set("oslo_messaging_notifications", "transport_url", RABBITMQ_URL)
    config.set("cache", "memcache_servers", MEMCACHE_URL)
    config.write(open(tmp.name, "w"))
    with open(tmp.name, 'r') as f:
        info = f.read()
    return info


def main():
    read_kube_config()
    updated_keys = ""
    configmap = get_configmap_definition(CONFIG_MAP_NAME)
    conf = configmap['data']['keystone.conf']
    updated_keys = update_connection_fields(conf)

    configmap['data']['keystone.conf'] = updated_keys
    if not update_configmap(CONFIG_MAP_NAME, configmap):
        sys.exit(1)

if __name__ == "__main__":
    main()
