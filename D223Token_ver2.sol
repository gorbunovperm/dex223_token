// Токен 2 версии: 0xfc12A27ED2F2faC872E679c15eFd334184D7F4F4

/**
 *Submitted for verification at Etherscan.io on 2024-10-01
*/

/**
 *Submitted for verification at Etherscan.io on 2023-12-01
*/

// SPDX-License-Identifier: GPL-3.0

// Contracts are written by @Dexaran (twitter.com/Dexaran github.com/Dexaran)
// Read more about ERC-223 standard here: dexaran.github.io/erc223

// D223 is a token of Dex223.io exchange.

pragma solidity >=0.8.2;

abstract contract IERC223Recipient {


 struct ERC223TransferInfo
    {
        address token_contract;
        address sender;
        uint256 value;
        bytes   data;
    }
    
    ERC223TransferInfo private tkn;
    
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenReceived(address _from, uint _value, bytes memory _data) public virtual returns (bytes4)
    {
        /**
         * @dev Note that inside of the token transaction handler the actual sender of token transfer is accessible via the tkn.sender variable
         * (analogue of msg.sender for Ether transfers)
         * 
         * tkn.value - is the amount of transferred tokens
         * tkn.data  - is the "metadata" of token transfer
         * tkn.token_contract is most likely equal to msg.sender because the token contract typically invokes this function
        */
        tkn.token_contract = msg.sender;
        tkn.sender         = _from;
        tkn.value          = _value;
        tkn.data           = _data;
        
        // ACTUAL CODE

        return 0x8943ec02;
    }
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

/**
 * @title Reference implementation of the ERC223 standard token.
 */
contract D223Token {

     /**
     * @dev Event that is fired on successful transfer.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event TransferData(bytes);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    string  private _name;
    string  private _symbol;
    uint8   private _decimals;
    uint256 private _totalSupply;
    address public  owner = msg.sender;
    mapping(address account => mapping(address spender => uint256)) private allowances;
    
    mapping(address => uint256) private balances; // List of user balances.

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
     
    constructor()
    {
        _name     = "Dex223 token";
        _symbol   = "D223";
        _decimals = 18;
        balances[msg.sender] = 8000000000 * 1e18;
        emit Transfer(address(0), msg.sender, balances[msg.sender]);
        emit TransferData(hex"000000");
        _totalSupply = balances[msg.sender];
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory)
    {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory)
    {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC223} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC223-balanceOf} and {IERC223-transfer}.
     */
    function decimals() public view returns (uint8)
    {
        return _decimals;
    }

    /**
     * @dev See {IERC223-totalSupply}.
     */
    function totalSupply() public view returns (uint256)
    {
        return _totalSupply;
    }

    /**
     * @dev See {IERC223-standard}.
     */
    function standard() public view returns (uint32)
    {
        return 223;
    }

    
    /**
     * @dev Returns balance of the `_owner`.
     *
     * @param _owner   The address whose balance will be returned.
     * @return balance Balance of the `_owner`.
     */
    function balanceOf(address _owner) public view returns (uint256)
    {
        return balances[_owner];
    }
    
    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      Invokes the `tokenFallback` function if the recipient is a contract.
     *      The token transfer fails if the recipient is a contract
     *      but does not implement the `tokenFallback` function
     *      or the fallback function to receive funds.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     * @param _data  Transaction metadata.
     */
    function transfer(address _to, uint _value, bytes calldata _data) public returns (bool success)
    {
        // Standard function transfer similar to ERC20 transfer with no _data .
        // Added due to backwards compatibility reasons .
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        if(Address.isContract(_to)) {
            IERC223Recipient(_to).tokenReceived(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value);
        emit TransferData(_data);
        return true;
    }
    
    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      This function works the same with the previous one
     *      but doesn't contain `_data` param.
     *      Added due to backwards compatibility reasons.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     */
    function transfer(address _to, uint _value) public returns (bool success)
    {
        bytes memory _empty = hex"00000000";
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        if(Address.isContract(_to)) {
            IERC223Recipient(_to).tokenReceived(msg.sender, _value, _empty);
        }
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // ERC-20 functions for backwards compatibility.

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address _spender, uint _value) public returns (bool) {

        // Safety checks.
        require(_spender != address(0), "ERC-223: Spender error.");

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        
        require(allowances[_from][msg.sender] >= _value, "ERC-223: Insufficient allowance.");
        
        balances[_from] -= _value;
        allowances[_from][msg.sender] -= _value;
        balances[_to] += _value;
        
        emit Transfer(_from, _to, _value);
        
        return true;
    }

    function rescueERC20(address _token, uint256 _value) external
    {
        require(msg.sender == owner);
        (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(0xa9059cbb, msg.sender, _value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }

    function newOwner(address _owner) external
    {
        require(msg.sender == owner);
        owner = _owner;
    }
}