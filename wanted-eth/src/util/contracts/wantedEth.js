
const address = '0xfd5ea6608a0f3ef593363a27b421df50066e6659';
const ABI = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_playerId",
				"type": "uint256"
			},
			{
				"name": "_address",
				"type": "address"
			},
			{
				"name": "_nameByte",
				"type": "bytes32"
			}
		],
		"name": "__callbackCreatePlayer",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_monsterId",
				"type": "uint256"
			},
			{
				"name": "_creator",
				"type": "address"
			},
			{
				"name": "_nameByte",
				"type": "bytes32"
			},
			{
				"name": "_balance",
				"type": "uint256"
			}
		],
		"name": "__callbackWanted",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_target",
				"type": "string"
			}
		],
		"name": "hunt",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_address",
				"type": "address"
			}
		],
		"name": "setPrivateNetwork",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_name",
				"type": "string"
			}
		],
		"name": "wanted",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_name",
				"type": "string"
			}
		],
		"name": "createPlayer",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_huntHistoryId",
				"type": "uint256"
			},
			{
				"name": "_hunterId",
				"type": "uint256"
			},
			{
				"name": "_monsterId",
				"type": "uint256"
			},
			{
				"name": "_hunterValue",
				"type": "uint256"
			},
			{
				"name": "_monsterValue",
				"type": "uint256"
			},
			{
				"name": "_isSuccess",
				"type": "bool"
			},
			{
				"name": "_hunter",
				"type": "address"
			}
		],
		"name": "__callbackHunt",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "playerId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"name": "player",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "playerNameByte",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "timeStamp",
				"type": "uint256"
			}
		],
		"name": "onCreatePlayer",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "monsterId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"name": "creator",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "monsterNameByte",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "balance",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "timeStamp",
				"type": "uint256"
			}
		],
		"name": "onWanted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_huntHistoryId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "hunterId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "monsterId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "hunterValue",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "monsterValue",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "isSuccess",
				"type": "bool"
			},
			{
				"indexed": false,
				"name": "timeStamp",
				"type": "uint256"
			}
		],
		"name": "onHunt",
		"type": "event"
	}
];
export {address, ABI};
