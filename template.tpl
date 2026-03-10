___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Type Convertor",
  "description": "Convert value or other variable into the desired type.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "type",
    "displayName": "Type",
    "radioItems": [
      {
        "value": "makeInteger",
        "displayValue": "Integer"
      },
      {
        "value": "makeNumber",
        "displayValue": "Number"
      },
      {
        "value": "makeString",
        "displayValue": "String"
      },
      {
        "value": "hexToDecimal",
        "displayValue": "Hex to Decimal"
      }
    ],
    "simpleValueType": true,
    "help": "Choose the type to which your value/variable will be converted. Hex to Decimal converts a hexadecimal string (e.g. 4DB376A2) to its decimal integer value."
  },
  {
    "type": "TEXT",
    "name": "value",
    "displayName": "Value",
    "simpleValueType": true,
    "help": "Set the value or variable that will be converted to the desired type."
  }
]


___SANDBOXED_JS_FOR_SERVER___

const makeInteger = require('makeInteger');
const makeNumber = require('makeNumber');
const makeString = require('makeString');

if (data.type === 'makeInteger') return makeInteger(data.value);
if (data.type === 'makeNumber') return makeNumber(data.value);
if (data.type === 'hexToDecimal') {
  let hex = makeString(data.value);

  if (hex.length >= 2 && (hex.charAt(0) === '0' && (hex.charAt(1) === 'x' || hex.charAt(1) === 'X'))) {
    hex = hex.substring(2);
  }

  if (hex.length === 0) return undefined;

  hex = hex.toLowerCase();
  let result = 0;

  for (let i = 0; i < hex.length; i++) {
    const c = hex.charAt(i);
    let digit;

    if (c >= '0' && c <= '9') {
      digit = makeInteger(c);
    } else if (c === 'a') {
      digit = 10;
    } else if (c === 'b') {
      digit = 11;
    } else if (c === 'c') {
      digit = 12;
    } else if (c === 'd') {
      digit = 13;
    } else if (c === 'e') {
      digit = 14;
    } else if (c === 'f') {
      digit = 15;
    } else {
      return undefined;
    }

    result = result * 16 + digit;
  }

  return result;
}

return makeString(data.value);


___TESTS___

scenarios:
- name: String
  code: |-
    const mockData = {
      value: 1.1,
      type: 'makeString'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo('1.1');
- name: Number
  code: |-
    const mockData = {
      value: '1.1',
      type: 'makeNumber'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo(1.1);
- name: Integer
  code: |-
    const mockData = {
      value: 1.1,
      type: 'makeInteger'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo(1);
- name: Hex to Decimal
  code: |-
    const mockData = {
      value: '4DB376A2',
      type: 'hexToDecimal'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo(1303606946);
- name: Hex to Decimal lowercase
  code: |-
    const mockData = {
      value: '4db376a2',
      type: 'hexToDecimal'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo(1303606946);
- name: Hex to Decimal with 0x prefix
  code: |-
    const mockData = {
      value: '0x1A',
      type: 'hexToDecimal'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo(26);
- name: Hex to Decimal with invalid input
  code: |-
    const mockData = {
      value: 'ZZZZ',
      type: 'hexToDecimal'
    };

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo(undefined);


___NOTES___

Created on 27/07/2023, 15:21:05


