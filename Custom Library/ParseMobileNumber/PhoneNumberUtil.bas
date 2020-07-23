B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5
@EndOfDesignText@
#IgnoreWarnings: 9
Private Sub Class_Globals
	Private codes As List
	Private current_iso_code,current_country_code As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
	Dim data As String
	#region data
	data	=	$"[
  {
    "code": "1876",
    "iso": "JM",
    "name": "Jamaica",
    "mask": "ddd dddd"
  },
  {
    "code": "1869",
    "iso": "KN",
    "name": "Saint Kitts & Nevis",
    "mask": "ddd dddd"
  },
  {
    "code": "1868",
    "iso": "TT",
    "name": "Trinidad & Tobago",
    "mask": "ddd dddd"
  },
  {
    "code": "1784",
    "iso": "VC",
    "name": "Saint Vincent & the Grenadines",
    "mask": "ddd dddd"
  },
  {
    "code": "1767",
    "iso": "DM",
    "name": "Dominica",
    "mask": "ddd dddd"
  },
  {
    "code": "1758",
    "iso": "LC",
    "name": "Saint Lucia",
    "mask": "ddd dddd"
  },
  {
    "code": "1721",
    "iso": "Sd",
    "name": "Sint Maarten",
    "mask": "ddd dddd"
  },
  {
    "code": "1684",
    "iso": "AS",
    "name": "American Samoa",
    "mask": "ddd dddd"
  },
  {
    "code": "1671",
    "iso": "GU",
    "name": "Guam",
    "mask": "ddd dddd"
  },
  {
    "code": "1670",
    "iso": "MP",
    "name": "Northern Mariana Islands",
    "mask": "ddd dddd"
  },
  {
    "code": "1664",
    "iso": "MS",
    "name": "Montserrat",
    "mask": "ddd dddd"
  },
  {
    "code": "1649",
    "iso": "TC",
    "name": "Turks & Caicos Islands",
    "mask": "ddd dddd"
  },
  {
    "code": "1473",
    "iso": "GD",
    "name": "Grenada",
    "mask": "ddd dddd"
  },
  {
    "code": "1441",
    "iso": "BM",
    "name": "Bermuda",
    "mask": "ddd dddd"
  },
  {
    "code": "1345",
    "iso": "KY",
    "name": "Cayman Islands",
    "mask": "ddd dddd"
  },
  {
    "code": "1340",
    "iso": "VI",
    "name": "US Virgin Islands",
    "mask": "ddd dddd"
  },
  {
    "code": "1284",
    "iso": "VG",
    "name": "British Virgin Islands",
    "mask": "ddd dddd"
  },
  {
    "code": "1268",
    "iso": "AG",
    "name": "Antigua & Barbuda",
    "mask": "ddd dddd"
  },
  {
    "code": "1264",
    "iso": "AI",
    "name": "Anguilla",
    "mask": "ddd dddd"
  },
  {
    "code": "1246",
    "iso": "BB",
    "name": "Barbados",
    "mask": "ddd dddd"
  },
  {
    "code": "1242",
    "iso": "BS",
    "name": "Bahamas",
    "mask": "ddd dddd"
  },
  {
    "code": "998",
    "iso": "UZ",
    "name": "Uzbekistan",
    "mask": "dd ddddddd"
  },
  {
    "code": "996",
    "iso": "KG",
    "name": "Kyrgyzstan",
    "mask": "ddd dddddd"
  },
  {
    "code": "995",
    "iso": "GE",
    "name": "Georgia",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "994",
    "iso": "AZ",
    "name": "Azerbaijan",
    "mask": "dd ddd dddd"
  },
  {
    "code": "993",
    "iso": "TM",
    "name": "Turkmenistan",
    "mask": "dd dddddd"
  },
  {
    "code": "992",
    "iso": "TJ",
    "name": "Tajikistan",
    "mask": "dd ddd dddd"
  },
  {
    "code": "977",
    "iso": "NP",
    "name": "Nepal",
    "mask": "dd dddd dddd"
  },
  {
    "code": "976",
    "iso": "MN",
    "name": "Mongolia",
    "mask": "dd dd dddd"
  },
  {
    "code": "975",
    "iso": "BT",
    "name": "Bhutan",
    "mask": "dd ddd ddd"
  },
  {
    "code": "974",
    "iso": "QA",
    "name": "Qatar",
    "mask": "dd ddd ddd"
  },
  {
    "code": "973",
    "iso": "BH",
    "name": "Bahrain",
    "mask": "dddd dddd"
  },
  {
    "code": "972",
    "iso": "IL",
    "name": "Israel",
    "mask": "dd ddd dddd"
  },
  {
    "code": "971",
    "iso": "AE",
    "name": "United Arab Emirates",
    "mask": "dd ddd dddd"
  },
  {
    "code": "970",
    "iso": "PS",
    "name": "Palestine",
    "mask": "ddd dd dddd"
  },
  {
    "code": "968",
    "iso": "OM",
    "name": "Oman",
    "mask": "dddd dddd"
  },
  {
    "code": "967",
    "iso": "YE",
    "name": "Yemen",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "966",
    "iso": "SA",
    "name": "Saudi Arabia",
    "mask": "dd ddd dddd"
  },
  {
    "code": "965",
    "iso": "KW",
    "name": "Kuwait",
    "mask": "dddd dddd"
  },
  {
    "code": "964",
    "iso": "IQ",
    "name": "Iraq",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "963",
    "iso": "SY",
    "name": "Syria",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "962",
    "iso": "JO",
    "name": "Jordan",
    "mask": "d dddd dddd"
  },
  {
    "code": "961",
    "iso": "LB",
    "name": "Lebanon",
    "mask": ""
  },
  {
    "code": "960",
    "iso": "MV",
    "name": "Maldives",
    "mask": "ddd dddd"
  },
  {
    "code": "886",
    "iso": "TW",
    "name": "Taiwan",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "880",
    "iso": "BD",
    "name": "Bangladesh",
    "mask": ""
  },
  {
    "code": "856",
    "iso": "LA",
    "name": "Laos",
    "mask": "dd dd ddd ddd"
  },
  {
    "code": "855",
    "iso": "KH",
    "name": "Cambodia",
    "mask": ""
  },
  {
    "code": "853",
    "iso": "MO",
    "name": "Macau",
    "mask": "dddd dddd"
  },
  {
    "code": "852",
    "iso": "HK",
    "name": "Hong Kong",
    "mask": "d ddd dddd"
  },
  {
    "code": "850",
    "iso": "KP",
    "name": "North Korea",
    "mask": ""
  },
  {
    "code": "692",
    "iso": "MH",
    "name": "Marshall Islands",
    "mask": ""
  },
  {
    "code": "691",
    "iso": "FM",
    "name": "Micronesia",
    "mask": ""
  },
  {
    "code": "690",
    "iso": "TK",
    "name": "Tokelau",
    "mask": ""
  },
  {
    "code": "689",
    "iso": "PF",
    "name": "French Polynesia",
    "mask": ""
  },
  {
    "code": "688",
    "iso": "TV",
    "name": "Tuvalu",
    "mask": ""
  },
  {
    "code": "687",
    "iso": "NC",
    "name": "New Caledonia",
    "mask": ""
  },
  {
    "code": "686",
    "iso": "KI",
    "name": "Kiribati",
    "mask": ""
  },
  {
    "code": "685",
    "iso": "WS",
    "name": "Samoa",
    "mask": ""
  },
  {
    "code": "683",
    "iso": "NU",
    "name": "Niue",
    "mask": ""
  },
  {
    "code": "682",
    "iso": "CK",
    "name": "Cook Islands",
    "mask": ""
  },
  {
    "code": "681",
    "iso": "WF",
    "name": "Wallis & Futuna",
    "mask": ""
  },
  {
    "code": "680",
    "iso": "PW",
    "name": "Palau",
    "mask": ""
  },
  {
    "code": "679",
    "iso": "FJ",
    "name": "Fiji",
    "mask": ""
  },
  {
    "code": "678",
    "iso": "VU",
    "name": "Vanuatu",
    "mask": ""
  },
  {
    "code": "677",
    "iso": "SB",
    "name": "Solomon Islands",
    "mask": ""
  },
  {
    "code": "676",
    "iso": "TO",
    "name": "Tonga",
    "mask": ""
  },
  {
    "code": "675",
    "iso": "PG",
    "name": "Papua New Guinea",
    "mask": ""
  },
  {
    "code": "674",
    "iso": "NR",
    "name": "Nauru",
    "mask": ""
  },
  {
    "code": "673",
    "iso": "BN",
    "name": "Brunei Darussalam",
    "mask": "ddd dddd"
  },
  {
    "code": "672",
    "iso": "NF",
    "name": "Norfolk Island",
    "mask": ""
  },
  {
    "code": "670",
    "iso": "TL",
    "name": "Timor-Leste",
    "mask": ""
  },
  {
    "code": "599",
    "iso": "BQ",
    "name": "Bonaire, Sint Eustatius & Saba",
    "mask": ""
  },
  {
    "code": "599",
    "iso": "CW",
    "name": "Curaçao",
    "mask": ""
  },
  {
    "code": "598",
    "iso": "UY",
    "name": "Uruguay",
    "mask": "d ddd dddd"
  },
  {
    "code": "597",
    "iso": "SR",
    "name": "Suriname",
    "mask": "ddd dddd"
  },
  {
    "code": "596",
    "iso": "MQ",
    "name": "Martinique",
    "mask": ""
  },
  {
    "code": "595",
    "iso": "PY",
    "name": "Paraguay",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "594",
    "iso": "GF",
    "name": "French Guiana",
    "mask": ""
  },
  {
    "code": "593",
    "iso": "EC",
    "name": "Ecuador",
    "mask": "dd ddd dddd"
  },
  {
    "code": "592",
    "iso": "GY",
    "name": "Guyana",
    "mask": ""
  },
  {
    "code": "591",
    "iso": "BO",
    "name": "Bolivia",
    "mask": "d ddd dddd"
  },
  {
    "code": "590",
    "iso": "GP",
    "name": "Guadeloupe",
    "mask": "ddd dd dd dd"
  },
  {
    "code": "509",
    "iso": "HT",
    "name": "Haiti",
    "mask": ""
  },
  {
    "code": "508",
    "iso": "PM",
    "name": "Saint Pierre & Miquelon",
    "mask": ""
  },
  {
    "code": "507",
    "iso": "PA",
    "name": "Panama",
    "mask": "dddd dddd"
  },
  {
    "code": "506",
    "iso": "CR",
    "name": "Costa Rica",
    "mask": "dddd dddd"
  },
  {
    "code": "505",
    "iso": "NI",
    "name": "Nicaragua",
    "mask": "dddd dddd"
  },
  {
    "code": "504",
    "iso": "HN",
    "name": "Honduras",
    "mask": "dddd dddd"
  },
  {
    "code": "503",
    "iso": "SV",
    "name": "El Salvador",
    "mask": "dddd dddd"
  },
  {
    "code": "502",
    "iso": "GT",
    "name": "Guatemala",
    "mask": "d ddd dddd"
  },
  {
    "code": "501",
    "iso": "BZ",
    "name": "Belize",
    "mask": ""
  },
  {
    "code": "500",
    "iso": "FK",
    "name": "Falkland Islands",
    "mask": ""
  },
  {
    "code": "423",
    "iso": "LI",
    "name": "Liechtenstein",
    "mask": ""
  },
  {
    "code": "421",
    "iso": "SK",
    "name": "Slovakia",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "420",
    "iso": "CZ",
    "name": "Czech Republic",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "389",
    "iso": "MK",
    "name": "Macedonia",
    "mask": "dd ddd ddd"
  },
  {
    "code": "387",
    "iso": "BA",
    "name": "Bosnia & Herzegovina",
    "mask": "dd ddd ddd"
  },
  {
    "code": "386",
    "iso": "SI",
    "name": "Slovenia",
    "mask": "dd ddd ddd"
  },
  {
    "code": "385",
    "iso": "HR",
    "name": "Croatia",
    "mask": ""
  },
  {
    "code": "382",
    "iso": "ME",
    "name": "Montenegro",
    "mask": ""
  },
  {
    "code": "381",
    "iso": "RS",
    "name": "Serbia",
    "mask": "dd ddd dddd"
  },
  {
    "code": "380",
    "iso": "UA",
    "name": "Ukraine",
    "mask": "dd ddd dd dd"
  },
  {
    "code": "378",
    "iso": "SM",
    "name": "San Marino",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "377",
    "iso": "MC",
    "name": "Monaco",
    "mask": "dddd dddd"
  },
  {
    "code": "376",
    "iso": "AD",
    "name": "Andorra",
    "mask": "dd dd dd"
  },
  {
    "code": "375",
    "iso": "BY",
    "name": "Belarus",
    "mask": "dd ddd dddd"
  },
  {
    "code": "374",
    "iso": "AM",
    "name": "Armenia",
    "mask": "dd ddd ddd"
  },
  {
    "code": "373",
    "iso": "MD",
    "name": "Moldova",
    "mask": "dd ddd ddd"
  },
  {
    "code": "372",
    "iso": "EE",
    "name": "Estonia",
    "mask": ""
  },
  {
    "code": "371",
    "iso": "LV",
    "name": "Latvia",
    "mask": "ddd ddddd"
  },
  {
    "code": "370",
    "iso": "LT",
    "name": "Lithuania",
    "mask": "ddd ddddd"
  },
  {
    "code": "359",
    "iso": "BG",
    "name": "Bulgaria",
    "mask": ""
  },
  {
    "code": "358",
    "iso": "FI",
    "name": "Finland",
    "mask": ""
  },
  {
    "code": "357",
    "iso": "CY",
    "name": "Cyprus",
    "mask": "dddd dddd"
  },
  {
    "code": "356",
    "iso": "MT",
    "name": "Malta",
    "mask": "dd dd dd dd"
  },
  {
    "code": "355",
    "iso": "AL",
    "name": "Albania",
    "mask": "dd ddd dddd"
  },
  {
    "code": "354",
    "iso": "IS",
    "name": "Iceland",
    "mask": "ddd dddd"
  },
  {
    "code": "353",
    "iso": "IE",
    "name": "Ireland",
    "mask": "dd ddd dddd"
  },
  {
    "code": "352",
    "iso": "LU",
    "name": "Ludembourg",
    "mask": ""
  },
  {
    "code": "351",
    "iso": "PT",
    "name": "Portugal",
    "mask": "d dddd dddd"
  },
  {
    "code": "350",
    "iso": "GI",
    "name": "Gibraltar",
    "mask": "dddd dddd"
  },
  {
    "code": "299",
    "iso": "GL",
    "name": "Greenland",
    "mask": "ddd ddd"
  },
  {
    "code": "298",
    "iso": "FO",
    "name": "Faroe Islands",
    "mask": "ddd ddd"
  },
  {
    "code": "297",
    "iso": "AW",
    "name": "Aruba",
    "mask": "ddd dddd"
  },
  {
    "code": "291",
    "iso": "ER",
    "name": "Eritrea",
    "mask": "d ddd ddd"
  },
  {
    "code": "290",
    "iso": "SH",
    "name": "Saint Helena",
    "mask": "dd ddd"
  },
  {
    "code": "269",
    "iso": "KM",
    "name": "Comoros",
    "mask": "ddd dddd"
  },
  {
    "code": "268",
    "iso": "SZ",
    "name": "Swaziland",
    "mask": "dddd dddd"
  },
  {
    "code": "267",
    "iso": "BW",
    "name": "Botswana",
    "mask": "dd ddd ddd"
  },
  {
    "code": "266",
    "iso": "LS",
    "name": "Lesotho",
    "mask": "dd ddd ddd"
  },
  {
    "code": "265",
    "iso": "MW",
    "name": "Malawi",
    "mask": "77 ddd dddd"
  },
  {
    "code": "264",
    "iso": "NA",
    "name": "Namibia",
    "mask": "dd ddd dddd"
  },
  {
    "code": "263",
    "iso": "ZW",
    "name": "Zimbabwe",
    "mask": "dd ddd dddd"
  },
  {
    "code": "262",
    "iso": "RE",
    "name": "Réunion",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "261",
    "iso": "MG",
    "name": "Madagascar",
    "mask": "dd dd ddd dd"
  },
  {
    "code": "260",
    "iso": "ZM",
    "name": "Zambia",
    "mask": "dd ddd dddd"
  },
  {
    "code": "258",
    "iso": "MZ",
    "name": "Mozambique",
    "mask": "dd ddd dddd"
  },
  {
    "code": "257",
    "iso": "BI",
    "name": "Burundi",
    "mask": "dd dd dddd"
  },
  {
    "code": "256",
    "iso": "UG",
    "name": "Uganda",
    "mask": "dd ddd dddd"
  },
  {
    "code": "255",
    "iso": "TZ",
    "name": "Tanzania",
    "mask": "dd ddd dddd"
  },
  {
    "code": "254",
    "iso": "KE",
    "name": "Kenya",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "253",
    "iso": "DJ",
    "name": "Djibouti",
    "mask": "dd dd dd dd"
  },
  {
    "code": "252",
    "iso": "SO",
    "name": "Somalia",
    "mask": "dd ddd ddd"
  },
  {
    "code": "251",
    "iso": "ET",
    "name": "Ethiopia",
    "mask": "dd ddd dddd"
  },
  {
    "code": "250",
    "iso": "RW",
    "name": "Rwanda",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "249",
    "iso": "SD",
    "name": "Sudan",
    "mask": "dd ddd dddd"
  },
  {
    "code": "248",
    "iso": "SC",
    "name": "Seychelles",
    "mask": "d dd dd dd"
  },
  {
    "code": "247",
    "iso": "SH",
    "name": "Saint Helena",
    "mask": "dddd"
  },
  {
    "code": "246",
    "iso": "IO",
    "name": "Diego Garcia",
    "mask": "ddd dddd"
  },
  {
    "code": "245",
    "iso": "GW",
    "name": "Guinea-Bissau",
    "mask": "ddd dddd"
  },
  {
    "code": "244",
    "iso": "AO",
    "name": "Angola",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "243",
    "iso": "CD",
    "name": "Congo (Dem. Rep.)",
    "mask": "dd ddd dddd"
  },
  {
    "code": "242",
    "iso": "CG",
    "name": "Congo (Rep.)",
    "mask": "dd ddd dddd"
  },
  {
    "code": "241",
    "iso": "GA",
    "name": "Gabon",
    "mask": "d dd dd dd"
  },
  {
    "code": "240",
    "iso": "GQ",
    "name": "Equatorial Guinea",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "239",
    "iso": "ST",
    "name": "São Tomé & Príncipe",
    "mask": "dd ddddd"
  },
  {
    "code": "238",
    "iso": "CV",
    "name": "Cape Verde",
    "mask": "ddd dddd"
  },
  {
    "code": "237",
    "iso": "CM",
    "name": "Cameroon",
    "mask": "dddd dddd"
  },
  {
    "code": "236",
    "iso": "CF",
    "name": "Central African Rep.",
    "mask": "dd dd dd dd"
  },
  {
    "code": "235",
    "iso": "TD",
    "name": "Chad",
    "mask": "dd dd dd dd"
  },
  {
    "code": "234",
    "iso": "NG",
    "name": "Nigeria",
    "mask": ""
  },
  {
    "code": "233",
    "iso": "GH",
    "name": "Ghana",
    "mask": ""
  },
  {
    "code": "232",
    "iso": "SL",
    "name": "Sierra Leone",
    "mask": "dd ddd ddd"
  },
  {
    "code": "231",
    "iso": "LR",
    "name": "Liberia",
    "mask": ""
  },
  {
    "code": "230",
    "iso": "MU",
    "name": "Mauritius",
    "mask": ""
  },
  {
    "code": "229",
    "iso": "BJ",
    "name": "Benin",
    "mask": "dd ddd ddd"
  },
  {
    "code": "228",
    "iso": "TG",
    "name": "Togo",
    "mask": "dd ddd ddd"
  },
  {
    "code": "227",
    "iso": "NE",
    "name": "Niger",
    "mask": "dd dd dd dd"
  },
  {
    "code": "226",
    "iso": "BF",
    "name": "Burkina Faso",
    "mask": "dd dd dd dd"
  },
  {
    "code": "225",
    "iso": "CI",
    "name": "Côte d`Ivoire",
    "mask": "dd ddd ddd"
  },
  {
    "code": "224",
    "iso": "GN",
    "name": "Guinea",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "223",
    "iso": "ML",
    "name": "Mali",
    "mask": "dddd dddd"
  },
  {
    "code": "222",
    "iso": "MR",
    "name": "Mauritania",
    "mask": "dddd dddd"
  },
  {
    "code": "221",
    "iso": "SN",
    "name": "Senegal",
    "mask": "dd ddd dddd"
  },
  {
    "code": "220",
    "iso": "GM",
    "name": "Gambia",
    "mask": "ddd dddd"
  },
  {
    "code": "218",
    "iso": "LY",
    "name": "Libya",
    "mask": "dd ddd dddd"
  },
  {
    "code": "216",
    "iso": "TN",
    "name": "Tunisia",
    "mask": "dd ddd ddd"
  },
  {
    "code": "213",
    "iso": "DZ",
    "name": "Algeria",
    "mask": "ddd dd dd dd"
  },
  {
    "code": "212",
    "iso": "MA",
    "name": "Morocco",
    "mask": "dd ddd dddd"
  },
  {
    "code": "211",
    "iso": "SS",
    "name": "South Sudan",
    "mask": "dd ddd dddd"
  },
  {
    "code": "98",
    "iso": "IR",
    "name": "Iran",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "95",
    "iso": "MM",
    "name": "Myanmar",
    "mask": ""
  },
  {
    "code": "94",
    "iso": "LK",
    "name": "Sri Lanka",
    "mask": "dd ddd dddd"
  },
  {
    "code": "93",
    "iso": "AF",
    "name": "Afghanistan",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "92",
    "iso": "PK",
    "name": "Pakistan",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "91",
    "iso": "IN",
    "name": "India",
    "mask": "ddddd ddddd"
  },
  {
    "code": "90",
    "iso": "TR",
    "name": "Turkey",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "86",
    "iso": "CN",
    "name": "China",
    "mask": "ddd dddd dddd"
  },
  {
    "code": "84",
    "iso": "VN",
    "name": "Vietnam",
    "mask": ""
  },
  {
    "code": "82",
    "iso": "KR",
    "name": "South Korea",
    "mask": ""
  },
  {
    "code": "81",
    "iso": "JP",
    "name": "Japan",
    "mask": "dd dddd dddd"
  },
  {
    "code": "66",
    "iso": "TH",
    "name": "Thailand",
    "mask": "d dddd dddd"
  },
  {
    "code": "65",
    "iso": "SG",
    "name": "Singapore",
    "mask": "dddd dddd"
  },
  {
    "code": "64",
    "iso": "NZ",
    "name": "New Zealand",
    "mask": ""
  },
  {
    "code": "63",
    "iso": "PH",
    "name": "Philippines",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "62",
    "iso": "ID",
    "name": "Indonesia",
    "mask": ""
  },
  {
    "code": "61",
    "iso": "AU",
    "name": "Australia",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "60",
    "iso": "MY",
    "name": "Malaysia",
    "mask": ""
  },
  {
    "code": "58",
    "iso": "VE",
    "name": "Venezuela",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "57",
    "iso": "CO",
    "name": "Colombia",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "56",
    "iso": "CL",
    "name": "Chile",
    "mask": "d dddd dddd"
  },
  {
    "code": "55",
    "iso": "BR",
    "name": "Brazil",
    "mask": "dd ddddd dddd"
  },
  {
    "code": "54",
    "iso": "AR",
    "name": "Argentina",
    "mask": ""
  },
  {
    "code": "53",
    "iso": "CU",
    "name": "Cuba",
    "mask": "dddd dddd"
  },
  {
    "code": "52",
    "iso": "Md",
    "name": "Medico",
    "mask": ""
  },
  {
    "code": "51",
    "iso": "PE",
    "name": "Peru",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "49",
    "iso": "DE",
    "name": "Germany",
    "mask": ""
  },
  {
    "code": "48",
    "iso": "PL",
    "name": "Poland",
    "mask": "dd ddd dddd"
  },
  {
    "code": "47",
    "iso": "NO",
    "name": "Norway",
    "mask": "dddd dddd"
  },
  {
    "code": "46",
    "iso": "SE",
    "name": "Sweden",
    "mask": "dd ddd dddd"
  },
  {
    "code": "45",
    "iso": "DK",
    "name": "Denmark",
    "mask": "dddd dddd"
  },
  {
    "code": "44",
    "iso": "GB",
    "name": "United Kingdom",
    "mask": "dddd dddddd"
  },
  {
    "code": "43",
    "iso": "AT",
    "name": "Austria",
    "mask": ""
  },
  {
    "code": "42",
    "iso": "YL",
    "name": "Y-land",
    "mask": ""
  },
  {
    "code": "41",
    "iso": "CH",
    "name": "Switzerland",
    "mask": "dd ddd dddd"
  },
  {
    "code": "40",
    "iso": "RO",
    "name": "Romania",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "39",
    "iso": "IT",
    "name": "Italy",
    "mask": ""
  },
  {
    "code": "36",
    "iso": "HU",
    "name": "Hungary",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "34",
    "iso": "ES",
    "name": "Spain",
    "mask": "ddd ddd ddd"
  },
  {
    "code": "33",
    "iso": "FR",
    "name": "France",
    "mask": "d dd dd dd dd"
  },
  {
    "code": "32",
    "iso": "BE",
    "name": "Belgium",
    "mask": "ddd dd dd dd"
  },
  {
    "code": "31",
    "iso": "NL",
    "name": "Netherlands",
    "mask": "d dd dd dd dd"
  },
  {
    "code": "30",
    "iso": "GR",
    "name": "Greece",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "27",
    "iso": "ZA",
    "name": "South Africa",
    "mask": "dd ddd dddd"
  },
  {
    "code": "20",
    "iso": "EG",
    "name": "Egypt",
    "mask": "dd dddd dddd"
  },
  {
    "code": "7",
    "iso": "KZ",
    "name": "Kazakhstan",
    "mask": "ddd ddd dd dd"
  },
  {
    "code": "7",
    "iso": "RU",
    "name": "Russian Federation",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "1",
    "iso": "PR",
    "name": "Puerto Rico",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "1",
    "iso": "DO",
    "name": "Dominican Rep.",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "1",
    "iso": "CA",
    "name": "Canada",
    "mask": "ddd ddd dddd"
  },
  {
    "code": "1",
    "iso": "US",
    "name": "USA",
    "mask": "ddd ddd dddd"
  }
]"$
#end region

	Dim js As JSONParser
	js.Initialize(data)
	codes	=	js.NextArray
	
	GetIsoInfo(current_iso_code)
	
End Sub

Public Sub GetIsoCountryCode
	
	#if B4i  
	    Dim no As NativeObject
	    no = no.Initialize("CTTelephonyNetworkInfo")
	    no = no.RunMethod("new", Null).RunMethod("subscriberCellularProvider", Null)
	   
	    If no.IsInitialized Then
			no = no.GetField("isoCountryCode")
			If no.IsInitialized = False Then Return
	        current_iso_code        =	no.GetField("isoCountryCode").AsString
	        current_country_code    =	GetIsoInfo(current_iso_code).Get("code")
	    End If
	   
	#else if B4a
	    Private AHL As AHLocale
	    AHL.Initialize
	    current_iso_code = AHL.Country
	    current_country_code = AHL.ISO3Country
	#end if
	
End Sub

Private Sub GetIsoInfo(Iso As String) As Map
	
	For i = 0 To codes.Size - 1
		
		Dim temp As Map
		temp	=	codes.Get(i)
		
		Dim c_iso As String
		c_iso	=	temp.Get("iso")
		c_iso	=	c_iso.ToLowerCase
		
		If c_iso = Iso.ToLowerCase Then
			Return temp
		End If
			
	Next
	
	Return Null
	
End Sub

Public Sub Is_valid(PhoneNumber As String,CountryIso As String) As Boolean
	
	PhoneNumber	=	SanitizePhoneNumber(PhoneNumber)
	
	If CountryIso.Length > 0 Then
		
		Dim iso_info As Map
		iso_info	=	GetIsoInfo(CountryIso)
		
		If iso_info.IsInitialized = False Then
			Return False	
		End If
		
		Dim c_code As String
		c_code	=	iso_info.Get("code")
		c_code	=	c_code.ToLowerCase
		
		If PhoneNumber.StartsWith(c_code) Then
			
			PhoneNumber	=	PhoneNumber.SubString(c_code.Length)

			Dim mask As String
			mask		=	iso_info.Get("mask")
			mask		=	mask.Replace(" ","")

			If mask.Length <> PhoneNumber.Length Then
				Return False
			End If
			
			Return True
		
		Else
			
			Return True
			
		End If
	
	Else
		
		For i = 0 To codes.Size - 1
			
			Dim temp As Map
			temp	=	codes.Get(i)
			
			Dim code As String
			code	=	temp.Get("code")
			code	=	code.ToLowerCase
			
			If PhoneNumber.StartsWith(code) Then
				
				PhoneNumber	=	SanitizePhoneNumber(PhoneNumber.SubString(code.Length))

				Dim mask As String
				mask		=	temp.Get("mask")
				mask		=	mask.Replace(" ","")

				If mask.Length <> PhoneNumber.Length Then
					Return False
				End If
			
				Return True
				
			End If
			
		Next
		
		Return False
		
	End If
	
End Sub

Public Sub Parse2(PhoneNumber As String,CountryIso As String) As String
	
	PhoneNumber	=	SanitizePhoneNumber(PhoneNumber)
	
	If CountryIso.Length > 0 Then
		
		Dim iso_info As Map
		iso_info	=	GetIsoInfo(CountryIso)
		
		If iso_info.IsInitialized = False Then
			Return PhoneNumber
		End If
		
		Dim c_code As String
		c_code	=	iso_info.Get("code")
		c_code	=	c_code.ToLowerCase
		
		If PhoneNumber.StartsWith(c_code) Then
			
			PhoneNumber	=	SanitizePhoneNumber(PhoneNumber.SubString(c_code.Length))
		
			Return "+" & c_code & PhoneNumber
			
		Else
			Return "+" & c_code & PhoneNumber
		End If
	
	Else
		
		For i = 0 To codes.Size - 1
			
			Dim temp As Map
			temp	=	codes.Get(i)
			
			Dim code As String
			code	=	temp.Get("code")
			code	=	code.ToLowerCase
			
			If PhoneNumber.StartsWith(code) Then
				Return "+" & c_code & PhoneNumber.SubString(c_code.Length)
			End If
			
		Next
		
		Return PhoneNumber
		
	End If
	
End Sub

Private Sub SanitizePhoneNumber(PhoneNumber As String) As String
	
	PhoneNumber	=	PhoneNumber.Replace(" ","")
	
	If PhoneNumber.StartsWith("00") Then
		PhoneNumber	=	PhoneNumber.SubString(2)
	End If
	
	If PhoneNumber.StartsWith("0") Then
		PhoneNumber	=	PhoneNumber.SubString(1)
	End If
	
	If PhoneNumber.StartsWith("+") Then
		PhoneNumber	=	PhoneNumber.SubString(1)
	End If
	
	Return PhoneNumber
	
End Sub