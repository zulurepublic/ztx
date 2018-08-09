pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";


/**
 * @title AirDropper
 * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
 * @dev Contract for the Zulu token airdrop
 */
contract AirDropper is Ownable {
    using SafeMath for uint256;

    mapping (address => bool) public claimedAirdropTokens;

    uint256 public numOfCitizensWhoReceivedDrops;
    uint256 public dropAmount;
    uint256 public constant AIRDROP_SHARE = 100000000e18; // 100M
    uint256 public tokenAmount = 1000e18;
    uint256 public airdropReceiversLimit;

    ERC20 public zulu;

    event TokenDrop(address indexed receiver, uint256 amount);

    /**
     * @dev Constructor for the airdrop contract
     * @param _airdropReceiversLimit Cap of airdrop receivers
     * @param _zulu ZTX contract address
     */
    constructor(uint256 _airdropReceiversLimit, ERC20 _zulu) public {
        require(_airdropReceiversLimit != 0);

        airdropReceiversLimit = _airdropReceiversLimit;
        zulu = ERC20(_zulu);
    }

    modifier hasBalance() {
        require(zulu != address(0));
        uint256 balance = zulu.balanceOf(this);
        require(balance > 0);
        _;
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
        hasBalance
    {

        dropAmount = dropAmount.add(tokenAmount);
        require(dropAmount <= AIRDROP_SHARE && !claimedAirdropTokens[recipient]);

        numOfCitizensWhoReceivedDrops = numOfCitizensWhoReceivedDrops.add(1);
        claimedAirdropTokens[recipient] = true;
        // eligible citizens for airdrop receive tokenAmount in ZTX
        zulu.transfer(recipient, tokenAmount);
        emit TokenDrop(recipient, tokenAmount);
    }

    /**
     * @dev Emergency to self destruct contract
     */
    function kill() external onlyOwner {
        require(numOfCitizensWhoReceivedDrops >= airdropReceiversLimit);
        zulu.transfer(owner, zulu.balanceOf(this));
        selfdestruct(owner);
    }
}
