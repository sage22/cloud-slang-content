#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.cloud.stackato.applications

imports:
  apps: io.cloudslang.cloud.stackato.applications
  lists: io.cloudslang.base.lists

flow:
  name: test_get_application_details
  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
    - application_name
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

  workflow:
    - get_application_details:
        do:
          apps.get_application_details:
            - host
            - username
            - password
            - application_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_APPLICATIONS_FAILURE: GET_APPLICATIONS_FAILURE
          - GET_APPLICATIONS_LIST_FAILURE: GET_APPLICATIONS_LIST_FAILURE
          - GET_APPLICATION_DETAILS_FAILURE: GET_APPLICATION_DETAILS_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESPONSES_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_APPLICATIONS_FAILURE
    - GET_APPLICATIONS_LIST_FAILURE
    - GET_APPLICATION_DETAILS_FAILURE
    - CHECK_RESPONSES_FAILURE
