pragma solidity ^0.4.24;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

// ----------------------- Public Network Part -----------------------

contract WantedEth {
    
    // Events
    event onCreatePlayer (
        uint256 indexed playerId,
        address indexed player,
        bytes32 indexed playerNameByte,
        uint256 timeStamp
    );
    
    event onWanted (
        uint256 indexed monsterId,
        address indexed creator,
        bytes32 indexed monsterNameByte,
        uint balance,
        uint256 timeStamp
    );
    
    event onHunt (
        uint256 _huntHistoryId,
        uint256 hunterId,
        uint256 monsterId,
        uint hunterValue,
        uint monsterValue,
        bool isSuccess,
        uint256 timeStamp
    );
    
    // Variables
    address internal owner;
    
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
    
    // Transfer Ownership
    function transferOwnership(address _newOwner) public _isOwner() {
        if (_newOwner != address(0)) {
            owner = _newOwner;
        }
    }
    
    // Public Interfaces
    function setPrivateNetwork(address _address) public _isOwner() {
        privateNetwork = WantedEthCore(_address);
    }
    
    function createPlayer(string _name) public {
        address _address = msg.sender;
        
        bytes32 _nameByte = stringToBytes32(_name);
        
        privateNetwork.createPlayer(_address, _nameByte);
    }
    
    function wanted(string _name) public payable {
        require(msg.value > 0, "Require ether");
        
        bytes32 _nameByte = stringToBytes32(_name);
        
        privateNetwork.wanted(msg.sender, _nameByte, msg.value);
    }
    
    function hunt(string _target) public payable {
        require(msg.value > 0, "Require ether");
        
        bytes32 _targetByte = stringToBytes32(_target);
        
        privateNetwork.hunt(msg.sender, _targetByte, msg.value);
    }
    
    // Callback Functions
    function __callbackCreatePlayer(uint256 _playerId, address _address, bytes32 _nameByte) public {
        emit onCreatePlayer(_playerId, _address, _nameByte, now);
    }
    
    function __callbackWanted(uint256 _monsterId, address _creator, bytes32 _nameByte, uint _balance) public {
        emit onWanted(_monsterId, _creator, _nameByte, _balance, now);
    }
    
    function __callbackHunt(uint256 _huntHistoryId, uint256 _hunterId, uint256 _monsterId, uint _hunterValue, uint _monsterValue, bool _isSuccess, address _hunter) public {
        if (_isSuccess) {
            require(_hunterValue + _monsterValue <= address(this).balance, "Balance Error");
            
            _hunter.transfer(_hunterValue + _monsterValue);
        }
        
        emit onHunt(_huntHistoryId, _hunterId, _monsterId, _hunterValue, _monsterValue, _isSuccess, now);
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

// ----------------------- Private Network Part -----------------------

contract WantedEthCore is usingOraclize {
    
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
        uint256 _hunterId;
        uint256 _monsterId;
        uint _hunterValue;
        uint _monsterValue;
        bool _isSuccess;
    }
    
    // Variables
    uint256 internal playerIdCount;
    mapping (address => uint256) internal playerIdAddressM;
    mapping (bytes32 => uint256) internal playerIdNameM;
    mapping (uint256 => Player) internal playerM;
    
    uint256 internal monsterIdCount;
    mapping (bytes32 => uint256) internal monsterIdNameM;
    mapping (uint256 => Monster) internal monsterM;
    
    uint256 internal huntHistoryIdCount;
    mapping (bytes32 => uint256) public huntHistoryIdQueryId;
    mapping (uint256 => HuntHistory) internal huntHistoryM;
    
    address internal owner;
    
    WantedEth internal publicNetwork;
    
    uint public randomValue;
    
    // Modifiers
    modifier _isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    // Transfer Ownership
    function transferOwnership(address _newOwner) public _isOwner() {
        if (_newOwner != address(0)) {
            owner = _newOwner;
        }
    }
    
    // Constructor
    constructor() public {
        owner = msg.sender;
        
        oraclize_setProof(proofType_Ledger);
        
        randomValue = 0;
        playerIdCount = 0;
        monsterIdCount = 0;
        huntHistoryIdCount = 0;
        
        setRandomValue();
    }
    
    // Interfaces
    function setPublicNetwork(address _address) public _isOwner() {
        publicNetwork = WantedEth(_address);
    }
    
    function createPlayer(address _address, bytes32 _nameByte) public {
        require(playerIdAddressM[_address] == 0, "Require unique address");
        require(playerIdNameM[_nameByte] == 0, "Require unique name");
        
        playerIdCount++;
        
        playerIdAddressM[_address] = playerIdCount;
        playerIdNameM[_nameByte] = playerIdCount;
        
        playerM[playerIdCount] = Player({_address: _address, _nameByte: _nameByte});
        
        publicNetwork.__callbackCreatePlayer(playerIdCount, _address, _nameByte);
    }
    
    function wanted(address _creator, bytes32 _nameByte, uint _balance) public {
        require(monsterIdNameM[_nameByte] == 0, "Require unique name");
        
        monsterIdCount++;
        monsterIdNameM[_nameByte] = monsterIdCount;
        
        monsterM[monsterIdCount] = Monster({
            _creator: _creator, 
            _nameByte: _nameByte, 
            _balance: _balance
        });
        
        publicNetwork.__callbackWanted(monsterIdCount, _creator, _nameByte, _balance);
    }
    
    function hunt(address _hunter, bytes32 _monsterNameByte, uint _hunterValue) public {
        uint256 _hunterId = playerIdAddressM[_hunter];
        uint256 _monsterId = monsterIdNameM[_monsterNameByte];
        uint _monsterValue = monsterM[_monsterId]._balance;
        bool _isSuccess = false;
        
        require(_hunterId > 0 && _monsterId > 0 && _monsterValue > 0 && randomValue > 0, "Preprocessing Error");
        
        uint _sumValue = _hunterValue + _monsterValue;
        
        _isSuccess = (random() % _sumValue) <= _hunterValue;
        
        huntHistoryIdCount++;
        
        huntHistoryM[huntHistoryIdCount] = HuntHistory({
            _hunterId: _hunterId,
            _monsterId: _monsterId,
            _hunterValue: _hunterValue,
            _monsterValue: _monsterValue,
            _isSuccess: _isSuccess
        });
        
        monsterM[_monsterId]._balance = 0;
        
        if (!_isSuccess) {
            monsterM[_monsterId]._balance = _sumValue;
        }
        
        publicNetwork.__callbackHunt(huntHistoryIdCount, _hunterId, _monsterId, _hunterValue, _monsterValue, _isSuccess, _hunter);
    }
    
    // Set Random from Oraclize Function
    function setRandomValue() public payable _isOwner() {
        oraclize_newRandomDSQuery(0, 7, 200000);
    }
    
    // Oraclize Callback Function
    function __callback(bytes32 _queryId, string _result, bytes _proof) public {
        require(msg.sender == oraclize_cbAddress(), "Require __callback address is Oraclize address");
        
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
            randomValue = uint(sha256(_result));
        }
    }
    
    // Random Function
    function random() private view returns (uint) {
        return uint(sha256(block.timestamp, block.difficulty)) * randomValue;
    }
    
    // Getters
    function getPlayer(address _address) public view returns(address __address, bytes32 __nameByte) {
        (, bytes32 _nameByte) = getPlayer(playerIdAddressM[_address]);
        
        return (_address, _nameByte);
    }
    
    function getPlayer(bytes32 _nameByte) public view returns(address __address, bytes32 __nameByte) {
        (address _address, ) = getPlayer(playerIdNameM[_nameByte]);
        
        return (_address, _nameByte);
    }
    
    function getPlayer(uint256 _playerId) public view returns(address _address, bytes32 _nameByte) {
        return (playerM[_playerId]._address, playerM[_playerId]._nameByte);
    }
    
    function getMonster(bytes32 _nameByte) public view returns(address __creator, bytes32 __nameByte, uint __balance) {
        (address _creator, , uint _balance) = getMonster(monsterIdNameM[_nameByte]);
        
        return (_creator, _nameByte, _balance);
    }
    
    function getMonster(uint256 _monsterId) public view returns(address _creator, bytes32 _nameByte, uint _balance) {
        return (
            monsterM[_monsterId]._creator, 
            monsterM[_monsterId]._nameByte, 
            monsterM[_monsterId]._balance
        );
    }
    
    function getHuntHistory(uint256 _huntHistoryId) public view returns(uint256 _hunterId, uint256 _monsterId, uint _hunterValue, uint _monsterValue, bool _isSuccess) {
        return (
            huntHistoryM[_huntHistoryId]._hunterId, 
            huntHistoryM[_huntHistoryId]._monsterId, 
            huntHistoryM[_huntHistoryId]._hunterValue, 
            huntHistoryM[_huntHistoryId]._monsterValue, 
            huntHistoryM[_huntHistoryId]._isSuccess
        );
    }
    
}
