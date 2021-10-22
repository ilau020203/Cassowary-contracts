// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Cassowary is Context, IERC20, IERC20Metadata,Ownable {
    using SafeMath for uint256;
    
    uint256 constant day = 60;//for test 60 seconds must be 1 days
    uint256 constant countMintDay=600;// count day afer create contract when can mint locked token
    uint256 constant allDays=365*5;// time when continue unlocked token
    //uint256 constant allTokens=10**(9+18);//dont use
    
    mapping(address => uint256) private _fullBalanceInStart;
    mapping(address => uint256) private _lastTimeMint;
    mapping(address => uint256) private _balances;
    
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 _timestampCreated;

    string private _name;
    string private _symbol;
    
    modifier mintTime(){
        require(_timestampCreated+day*countMintDay>=block.timestamp,"mint time was finished");
        _;
    }
     /**
     * @dev Returns the start timestamp today 
     */
    function getDayTimestamp() view public returns(uint256){
        return block.timestamp.sub(block.timestamp.mod(day));
    }
    
    /**
     * @dev Returns the start timestamp day when create contract
     */
    function timestampCreated()public view returns(uint256)
    {
        return _timestampCreated;
    }
    
   
   
    /**
     * @dev unlocketad token uses in _approve, _transfer, _burn
     */
    function _myMint()internal{
        uint256 timestamp=getDayTimestamp();
        if(timestamp<allDays*day+_timestampCreated){
            _mint(msg.sender,_fullBalanceInStart[msg.sender].div(allDays).mul((timestamp.sub(_lastTimeMint[msg.sender])).div(day)));
            _lastTimeMint[msg.sender]=timestamp;
        }else{
            _mint(msg.sender,_fullBalanceInStart[msg.sender].div(allDays).mul(((allDays*day+_timestampCreated).sub(_lastTimeMint[msg.sender])).div(day)));
            _lastTimeMint[msg.sender]=allDays*day+_timestampCreated;
        }
    }
   
    constructor() {
        _name = "Cassowary";
        _symbol = "CSR";
        _timestampCreated=getDayTimestamp();
        transferOwnership(_msgSender());
    }

    /**
     * @dev Creates `amount` locked tokens and assigns them to `account`
     */
    function mint(address account, uint256 amount)public mintTime onlyOwner{
        _fullBalanceInStart[account]=amount;
        _lastTimeMint[account]=_timestampCreated;
    }
    
     /**
     * @dev Creates `amounts[i]`  locked tokens and assigns them to `accounts[i]`
     */
    function mintArray(address[]memory accounts,uint256[] memory amounts) public mintTime onlyOwner{
        require(accounts.length==amounts.length,"bad lenght of array");
        for(uint256 i =0;i<accounts.length;i++){
            _fullBalanceInStart[accounts[i]]=amounts[i];
            _lastTimeMint[accounts[i]]=_timestampCreated;
        }
    }
    /**
     * @dev Returns the name of the token.
     */
    function name() public view  override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view  override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public pure  override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view  override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view  override returns (uint256) {
        if(getDayTimestamp()<(allDays*day+_timestampCreated)){
            return _balances[account]+(_fullBalanceInStart[msg.sender]*((getDayTimestamp()-_lastTimeMint[msg.sender])/day))/allDays;
        }else{
            return _balances[account]+(_fullBalanceInStart[msg.sender]*(((allDays*day+_timestampCreated)-_lastTimeMint[msg.sender])/day))/allDays;
        }
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public  override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    


    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view  override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public  override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public  {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public  {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }
    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public  override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal  {
        
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _myMint();

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal  {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal  {
        require(account != address(0), "ERC20: burn from the zero address");

        _myMint();
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal  {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _myMint();

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

}