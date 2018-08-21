pragma solidity 0.4.24;

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: contracts/ZTXInterface.sol

contract ZTXInterface {
    function transferOwnership(address _newOwner) public;
    function mint(address _to, uint256 amount) public returns (bool);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function unpause() public;
}

// File: contracts/Airdropper.sol

/**
 * @title AirDropper
 * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
 * @dev Contract for the ZTX airdrop
 */
contract AirDropper is Ownable {
    using SafeMath for uint256;

    mapping (address => bool) public claimedAirdropTokens;

    uint256 public numOfCitizensWhoReceivedDrops;
    uint256 public dropAmount;
    uint256 public constant AIRDROP_SHARE = 100000000e18; // 100M
    uint256 public tokenAmount = 1000e18;
    uint256 public airdropReceiversLimit;

    ZTXInterface public ztx;

    event TokenDrop(address indexed receiver, uint256 amount);

    /**
     * @dev Constructor for the airdrop contract
     * @param _airdropReceiversLimit Cap of airdrop receivers
     * @param _ztx ZTX contract address
     */
    constructor(uint256 _airdropReceiversLimit, ZTXInterface _ztx) public {
        require(_airdropReceiversLimit != 0);

        airdropReceiversLimit = _airdropReceiversLimit;
        ztx = ZTXInterface(_ztx);
    }

    /**
     * @dev Distributes tokens to recipient addresses
     * @param recipient address to receive airdropped token
     */
    function triggerAirDrop
        (
            address recipient
        )
        external
        onlyOwner
    {
        // NOTE: airdrop must be the token owner in order to mint ZTX tokens
        dropAmount = dropAmount.add(tokenAmount);
        require(dropAmount <= AIRDROP_SHARE && !claimedAirdropTokens[recipient]);

        numOfCitizensWhoReceivedDrops = numOfCitizensWhoReceivedDrops.add(1);
        claimedAirdropTokens[recipient] = true;
        // eligible citizens for airdrop receive tokenAmount in ZTX
        ztx.mint(recipient, tokenAmount);
        emit TokenDrop(recipient, tokenAmount);
    }

    /**
     * @dev Emergency to self destruct contract
     */
    function kill(address newZuluOwner) external onlyOwner {
        require(numOfCitizensWhoReceivedDrops >= airdropReceiversLimit);

        ztx.unpause();
        ztx.transferOwnership(newZuluOwner);
        selfdestruct(owner);
    }
}
