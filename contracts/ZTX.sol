pragma solidity 0.4.24;

import "./ZTXInterface.sol";
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";


/**
 * @title ZTX contract - ERC20 token contract.
 * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
 */
contract ZTX is MintableToken, PausableToken {
    string public constant name = "Zulu Republic Token";
    string public constant symbol = "ZTX";
    uint8 public constant decimals = 18;

    constructor() public {
        pause();
    }
}
