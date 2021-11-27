#!/bin/bash
if [ -n "${CUPS_SERVER}" ] or [ -n "${CUPS_USER}" ]; then
  echo "=> Configuring cups Client"
  mkdir -p  /etc/cups/
  echo  "ServerName ${CUPS_SERVER}" > /etc/cups/client.conf
  echo "User ${CUPS_USER}" >> /etc/cups/client.conf
fi