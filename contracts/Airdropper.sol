pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./ZTXInterface.sol";


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
