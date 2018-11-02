pragma solidity ^0.4.24;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract WantedEth {
    
    // Variables
    
    address public owner;
    
    WantedEthCore internal privateNetwork;
    
    // Contructor
    
    constructor() public {
        owner = msg.sender;
    }
    
    // Modifiers
    
    modifier _isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier _isHuman() {
        require(tx.origin == msg.sender, "Human only");
        _;
    }
    
    modifier _valueLimit(uint256 _value) {
        require(_value >= 1000000000, "Require more than 1 Gwei");
        require(_value <= 100000000000000000000000, "Require less than 100000 ether");
        _;
    }
    
    // Public Functions
    
    function setPrivateNetwork(address _address) public _isOwner() {
        
        privateNetwork = WantedEthCore(_address);
        
    }
    
    function createPlayer(string _name) public _isHuman() {
        
        address _address = msg.sender;
        
        bytes32 _nameByte = stringToBytes32(_name);
        
        privateNetwork.createPlayer(_address, _nameByte);
        
    }
    
    function wanted(string _name) public payable _isHuman() {
        
        bytes32 _nameByte = stringToBytes32(_name);
        
        privateNetwork.wanted(msg.sender, _nameByte, msg.value);
        
    }
    
    function hunt(string _target) public payable _isHuman() {
        
        bytes32 _monsterNameByte = stringToBytes32(_target);
        
        privateNetwork.hunt(msg.sender, _monsterNameByte, msg.value);
        
    }
    
    function __callbackHunting(address _address, uint _value) public {
        
        require(_value > 0 && _value <= address(this).balance, "Balance error");
        
        _address.transfer(_value);
        
    }
    
    // Library
    
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
    
        assembly {
            result := mload(add(source, 32))
        }
        
    }
    
}

contract WantedEthCore is usingOraclize {
    
    // Events
    
    event onCreatePlayer (
        
        uint256 indexed playerId,
        address indexed player,
        bytes32 indexed playerName,
        uint256 timeStamp
        
    );
    
    event onWanted (
        
        uint256 indexed monsterId,
        address indexed creator,
        bytes32 indexed monsterName,
        uint balance,
        uint256 timeStamp
        
    );
    
    event onHunt (
      
        bytes32 queryId,
        address hunterAddress,
        bytes32 monsterNameByte,
        uint hunterValue,
        uint monsterValue,
        uint256 timeStamp
        
    );
    
    event onResultHunt (
      
        bytes32 queryId,
        uint256 hunterId,
        uint256 monsterId,
        uint hunterValue,
        uint monsterValue,
        bool isSuccess,
        uint receivedBounty,
        uint256 timeStamp
        
    );
    
    event onOralizeError (
        
        string error,
        uint256 timeStamp
        
    );
    
    // Structures
    
    struct Player {
        address _address;
        bytes32 _nameByte;
    }
    
    struct Monster {
        address _creator;
        bytes32 _nameByte;
        uint _balance;
    }
    
    struct HuntHistory {
        bytes32 _queryId;
        uint256 _hunterId;
        uint256 _monsterId;
        uint _hunterValue;
        uint _monsterValue;
        bool _isSuccess;
        uint _receivedBounty;
        bool _finished;
    }
    
    // Variables
    
    uint256 public playerIdCount;
    mapping (address => uint256) public playerIdAddressM;
    mapping (bytes32 => uint256) public playerIdNameM;
    mapping (uint256 => Player) public playerM;
    
    uint256 public monsterIdCount;
    mapping (bytes32 => uint256) public monsterIdNameM;
    mapping (uint256 => Monster) public monsterM;
    
    uint256 public huntHistoryIdCount;
    mapping (bytes32 => uint256) public huntHistoryIdQueryId;
    mapping (uint256 => HuntHistory) public huntHistoryM;
    
    address public owner;
    
    WantedEth internal publicNetwork;
    
    // Modifiers
    
    modifier _isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    // Constructor
    
    constructor() public {
        owner = msg.sender;
        oraclize_setProof(proofType_Ledger);
    }
    
    // Interface
    
    function setPublicNetwork(address _address) public _isOwner() {
        
        publicNetwork = WantedEth(_address);
        
    }
    
    function createPlayer(address _address, bytes32 _nameByte) public {
        
        playerIdCount++;
        playerIdAddressM[_address] = playerIdCount;
        playerM[playerIdCount]._address = _address;
        
        playerM[playerIdCount]._nameByte = _nameByte;
        playerIdNameM[_nameByte] = playerIdCount;
        
        emit onCreatePlayer(playerIdCount, _address, _nameByte, now);
        
    }
    
    function wanted(address _creator, bytes32 _nameByte, uint _balance) public {
        
        monsterIdCount++;
        monsterIdNameM[_nameByte] = monsterIdCount;
        monsterM[monsterIdCount]._creator = _creator;
        monsterM[monsterIdCount]._nameByte = _nameByte;
        monsterM[monsterIdCount]._balance = _balance;
        
        emit onWanted(monsterIdCount, _creator, _nameByte, _balance, now);
        
    }
    
    function hunt(address _hunter, bytes32 _monsterNameByte, uint _value) public {
        
        uint256 _hunterId = playerIdAddressM[_hunter];
        
        uint256 _monsterId = monsterIdNameM[_monsterNameByte];
        
        huntHistoryIdCount++;
        
        bytes32 _queryId = oraclize_newRandomDSQuery(0, 7, 200000);
        
        huntHistoryIdQueryId[_queryId] = huntHistoryIdCount;
        huntHistoryM[huntHistoryIdCount]._queryId = _queryId;
        huntHistoryM[huntHistoryIdCount]._hunterId = _hunterId;
        huntHistoryM[huntHistoryIdCount]._monsterId = _monsterId;
        huntHistoryM[huntHistoryIdCount]._hunterValue = _value;
        huntHistoryM[huntHistoryIdCount]._monsterValue = monsterM[_monsterId]._balance;
        huntHistoryM[huntHistoryIdCount]._isSuccess = false;
        huntHistoryM[huntHistoryIdCount]._receivedBounty = 0;
        huntHistoryM[huntHistoryIdCount]._finished = false;
        
        monsterM[_monsterId]._balance = 0;
        
        emit onHunt(_queryId, _hunter, _monsterNameByte, _value, huntHistoryM[huntHistoryIdCount]._monsterValue, now);
        
    }
    
    // Oraclize Callback
    
    function __callback(bytes32 _queryId, string _result, bytes _proof) public {
        
        require(msg.sender == oraclize_cbAddress(), "Require __callback address is Oraclize address");
        
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
            
            uint256 _huntHistoryId = huntHistoryIdQueryId[_queryId];
            
            require(!huntHistoryM[_huntHistoryId]._finished, "Finished hunting process error");
            
            uint256 _hunterId = huntHistoryM[_huntHistoryId]._hunterId;
            uint _hunterValue = huntHistoryM[_huntHistoryId]._hunterValue;
            
            uint256 _monsterId = huntHistoryM[_huntHistoryId]._monsterId;
            uint _monsterValue = huntHistoryM[_huntHistoryId]._monsterValue;
            
            uint _sumValue = _hunterValue + _monsterValue;
            
            uint randomNumber = uint(sha3(_result)) % _sumValue;
            
            bool _isSuccess = randomNumber <= _hunterValue;
            
            huntHistoryM[_huntHistoryId]._isSuccess = _isSuccess;
                
            if (_isSuccess) {
                huntHistoryM[_huntHistoryId]._receivedBounty = _sumValue;
            } else {
                monsterM[_monsterId]._balance = _sumValue;
            }
            
            huntHistoryM[_huntHistoryId]._finished = true;
            
            emit onResultHunt(_queryId, _hunterId, _monsterId, _hunterValue, _monsterValue, _isSuccess, _isSuccess ? _sumValue : 0, now);
            
            publicNetwork.__callbackHunting(playerM[_hunterId]._address, _isSuccess ? _sumValue : 0);
            
        }
        
    }
    
}

