#!/usr/bin/env python3
import logging
import requests
import os
import sys


KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
NAMESPACE = os.environ['KUBERNETES_NAMESPACE']
ROOK_NAMESPACE = os.getenv('ROOK_NAMESPACE', None)
ROOK_CM_NAME = os.getenv('ROOK_CM_NAME', None)
ROOK_SECRETS = os.getenv('ROOK_SECRETS', None)
CM_NAME = os.getenv('CM_NAME', None)
SECRET_NAME = os.getenv('SECRET_NAME', None)

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


def get_rook_configmap(name):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST,
                                                     ROOK_NAMESPACE,
                                                     name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request rook namespaces configmaps url %s.', url)
    return resp.json()


def get_rook_secrets(name):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  ROOK_NAMESPACE,
                                                  name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request rook namespace secrets url %s.', url)
    return resp.json()


def get_self_configmap(name):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST,
                                                     NAMESPACE,
                                                     name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request configmaps url %s.', url)
    return resp.json()


def get_self_secret(name):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request secrets url %s.', url)
    return resp.json()


def update_configmap(configmap):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST,
                                                     NAMESPACE,
                                                     CM_NAME)
    resp = requests.put(url,
                        json=configmap,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error(resp.text)
        LOG.error("Update configmap failed!")
        return False
    LOG.info("Update configmap success!")
    return True


def update_secret(secret):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  SECRET_NAME)
    resp = requests.put(url,
                        json=secret,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error(resp.text)
        LOG.error("Update Secrets failed!")
        return False

    LOG.info("Update Secrets success!")
    return True


def main():
    read_kube_config()
    rook_cm = get_rook_configmap(ROOK_CM_NAME)
    rook_secret = get_rook_secrets(ROOK_SECRETS)

    self_cm = get_self_configmap(CM_NAME)
    self_secret = get_self_secret(SECRET_NAME)
    self_cm['data'] = rook_cm['data']
    self_secret['data'] = rook_secret['data']

    if not (update_configmap(self_cm) and update_secret(self_secret)):
        sys.exit(1)


if __name__ == "__main__":
    main()
