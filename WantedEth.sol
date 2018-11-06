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
        bytes32 indexed queryId,
        uint256 hunterId,
        uint256 monsterId,
        uint hunterValue,
        uint monsterValue,
        uint256 timeStamp
    );
    
    event onResultHunt (
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
        bytes32 _nameByte = stringToBytes32(_name);
        
        privateNetwork.wanted(msg.sender, _nameByte, msg.value);
    }
    
    function hunt(string _target) public payable {
        bytes32 _targetByte = stringToBytes32(_target);
        
        privateNetwork.hunt(msg.sender, _targetByte, msg.value);
        // privateNetwork.hunt.value(200000)(msg.sender, _targetByte, msg.value);
    }
    
    // Callback Functions
    function __callbackCreatePlayer(uint256 _playerId, address _address, bytes32 _nameByte) public {
        emit onCreatePlayer(_playerId, _address, _nameByte, now);
    }
    
    function __callbackWanted(uint256 _monsterId, address _creator, bytes32 _nameByte, uint _balance) public {
        emit onWanted(_monsterId, _creator, _nameByte, _balance, now);
    }
    
    function __callbackHunt(bytes32 _queryId, uint256 _hunterId, uint256 _monsterId, uint _hunterValue, uint _monsterValue) public {
        emit onHunt(_queryId, _hunterId, _monsterId, _hunterValue, _monsterValue, now);
    }
    
    function __callbackResultHunt(uint256 _hunterId, uint256 _monsterId, uint _hunterValue, uint _monsterValue, bool _isSuccess, address _hunter) public {
        if (_isSuccess && _hunterValue + _monsterValue <= address(this).balance) {
            _hunter.transfer(_hunterValue + _monsterValue);
        }
        
        emit onResultHunt(_hunterId, _monsterId, _hunterValue, _monsterValue, _isSuccess, now);
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
        bytes32 _queryId;
        uint256 _hunterId;
        uint256 _monsterId;
        uint _hunterValue;
        uint _monsterValue;
        bool _isSuccess;
        bool _isFinished;
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
    
    // Modifiers
    modifier _isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    // Constructor
    constructor() public {
        owner = msg.sender;
        
        oraclize_setProof(proofType_Ledger);
        
        playerIdCount = 0;
        monsterIdCount = 0;
        huntHistoryIdCount = 0;
    }
    
    // Interfaces
    function setPublicNetwork(address _address) public _isOwner() {
        publicNetwork = WantedEth(_address);
    }
    
    function createPlayer(address _address, bytes32 _nameByte) public {
        playerIdCount++;
        
        playerIdAddressM[_address] = playerIdCount;
        playerIdNameM[_nameByte] = playerIdCount;
        
        playerM[playerIdCount] = Player({_address: _address, _nameByte: _nameByte});
        
        publicNetwork.__callbackCreatePlayer(playerIdCount, _address, _nameByte);
    }
    
    function wanted(address _creator, bytes32 _nameByte, uint _balance) public {
        monsterIdCount++;
        monsterIdNameM[_nameByte] = monsterIdCount;
        
        monsterM[monsterIdCount] = Monster({
            _creator: _creator, 
            _nameByte: _nameByte, 
            _balance: _balance
        });
        
        publicNetwork.__callbackWanted(monsterIdCount, _creator, _nameByte, _balance);
    }
    
    function hunt(address _hunter, bytes32 _monsterNameByte, uint _hunterValue) public payable {
        bytes32 _queryId = 0x0;
        uint256 _hunterId = playerIdAddressM[_hunter];
        uint256 _monsterId = monsterIdNameM[_monsterNameByte];
        uint _monsterValue = monsterM[_monsterId]._balance;
        
        huntHistoryIdCount++;
        
        _queryId = oraclize_newRandomDSQuery(0, 7, 200000);
        
        huntHistoryIdQueryId[_queryId] = huntHistoryIdCount;
        
        huntHistoryM[huntHistoryIdCount] = HuntHistory({
            _queryId: _queryId,
            _hunterId: _hunterId,
            _monsterId: _monsterId,
            _hunterValue: _hunterValue,
            _monsterValue: _monsterValue,
            _isSuccess: false,
            _isFinished: false
        });
        
        monsterM[_monsterId]._balance = 0;
        
        publicNetwork.__callbackHunt(_queryId, _hunterId, _monsterId, _hunterValue, _monsterValue);
    }
    
    // Oraclize Callback
    function __callback(bytes32 _queryId, string _result, bytes _proof) public {
        require(msg.sender == oraclize_cbAddress(), "Require __callback address is Oraclize address");
        
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
            uint256 _huntHistoryId = huntHistoryIdQueryId[_queryId];
            
            uint256 _hunterId = huntHistoryM[_huntHistoryId]._hunterId;
            uint256 _monsterId = huntHistoryM[_huntHistoryId]._monsterId;
            uint _hunterValue = huntHistoryM[_huntHistoryId]._hunterValue;
            uint _monsterValue = huntHistoryM[_huntHistoryId]._monsterValue;
            bool _isSuccess = false;
            bool _isFinished = true;
            
            address _hunter = playerM[_hunterId]._address;
            
            uint _sumValue = _hunterValue + _monsterValue;
            
            uint randomNumber = uint(sha3(_result)) % _sumValue;
            
            _isSuccess = randomNumber <= _hunterValue;
            
            if (!_isSuccess) {
                monsterM[_monsterId]._balance = _sumValue;
            }
            
            huntHistoryM[huntHistoryIdCount]._isSuccess = _isSuccess;
            huntHistoryM[huntHistoryIdCount]._isFinished = _isFinished;
            
            publicNetwork.__callbackResultHunt(_hunterId, _monsterId, _hunterValue, _monsterValue, _isSuccess, _hunter);
        }
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
    
    function getHuntHistory(uint256 _huntHistoryId) public view returns(uint256 _hunterId, uint256 _monsterId, uint _hunterValue, uint _monsterValue, bool _isSuccess, bool _isFinished) {
        return (
            huntHistoryM[_huntHistoryId]._hunterId, 
            huntHistoryM[_huntHistoryId]._monsterId, 
            huntHistoryM[_huntHistoryId]._hunterValue, 
            huntHistoryM[_huntHistoryId]._monsterValue, 
            huntHistoryM[_huntHistoryId]._isSuccess, 
            huntHistoryM[_huntHistoryId]._isFinished
        );
    }
    
}
