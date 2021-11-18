// Sources flattened with hardhat v2.6.8 https://hardhat.org

// File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}


// File @openzeppelin/contracts/utils/Address.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2 <0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts/utils/Context.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/AccessControl.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;



/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}


// File contracts/fei-protocol/external/SafeMathCopy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMathCopy { // To avoid namespace collision between openzeppelin safemath and uniswap safemath
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


// File contracts/fei-protocol/external/Decimal.sol

/*
    Copyright 2019 dYdX Trading Inc.
    Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/**
 * @title Decimal
 * @author dYdX
 *
 * Library that defines a fixed-point number with 18 decimal places.
 */
library Decimal {
    using SafeMathCopy for uint256;

    // ============ Constants ============

    uint256 private constant BASE = 10**18;

    // ============ Structs ============


    struct D256 {
        uint256 value;
    }

    // ============ Static Functions ============

    function zero()
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: 0 });
    }

    function one()
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: BASE });
    }

    function from(
        uint256 a
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: a.mul(BASE) });
    }

    function ratio(
        uint256 a,
        uint256 b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: getPartial(a, BASE, b) });
    }

    // ============ Self Functions ============

    function add(
        D256 memory self,
        uint256 b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.add(b.mul(BASE)) });
    }

    function sub(
        D256 memory self,
        uint256 b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.sub(b.mul(BASE)) });
    }

    function sub(
        D256 memory self,
        uint256 b,
        string memory reason
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.sub(b.mul(BASE), reason) });
    }

    function mul(
        D256 memory self,
        uint256 b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.mul(b) });
    }

    function div(
        D256 memory self,
        uint256 b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.div(b) });
    }

    function pow(
        D256 memory self,
        uint256 b
    )
    internal
    pure
    returns (D256 memory)
    {
        if (b == 0) {
            return from(1);
        }

        D256 memory temp = D256({ value: self.value });
        for (uint256 i = 1; i < b; i++) {
            temp = mul(temp, self);
        }

        return temp;
    }

    function add(
        D256 memory self,
        D256 memory b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.add(b.value) });
    }

    function sub(
        D256 memory self,
        D256 memory b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.sub(b.value) });
    }

    function sub(
        D256 memory self,
        D256 memory b,
        string memory reason
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: self.value.sub(b.value, reason) });
    }

    function mul(
        D256 memory self,
        D256 memory b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: getPartial(self.value, b.value, BASE) });
    }

    function div(
        D256 memory self,
        D256 memory b
    )
    internal
    pure
    returns (D256 memory)
    {
        return D256({ value: getPartial(self.value, BASE, b.value) });
    }

    function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
        return self.value == b.value;
    }

    function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
        return compareTo(self, b) == 2;
    }

    function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
        return compareTo(self, b) == 0;
    }

    function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
        return compareTo(self, b) > 0;
    }

    function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
        return compareTo(self, b) < 2;
    }

    function isZero(D256 memory self) internal pure returns (bool) {
        return self.value == 0;
    }

    function asUint256(D256 memory self) internal pure returns (uint256) {
        return self.value.div(BASE);
    }

    // ============ Core Methods ============

    function getPartial(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
    private
    pure
    returns (uint256)
    {
        return target.mul(numerator).div(denominator);
    }

    function compareTo(
        D256 memory a,
        D256 memory b
    )
    private
    pure
    returns (uint256)
    {
        if (a.value == b.value) {
            return 1;
        }
        return a.value > b.value ? 2 : 0;
    }
}


// File contracts/fei-protocol/bondingcurve/IBondingCurve.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface IBondingCurve {

	// ----------- Events -----------

    event ScaleUpdate(uint _scale);

    event BufferUpdate(uint _buffer);

    event Purchase(address indexed _to, uint _amountIn, uint _amountOut);

	event Allocate(address indexed _caller, uint _amount);

	// ----------- State changing Api -----------

	/// @notice purchase FEI for underlying tokens
	/// @param to address to receive FEI
	/// @param amountIn amount of underlying tokens input
	/// @return amountOut amount of FEI received
	function purchase(address to, uint amountIn) external payable returns (uint amountOut);
	
	/// @notice batch allocate held PCV
	function allocate() external;

	// ----------- Governor only state changing api -----------

	/// @notice sets the bonding curve price buffer
	function setBuffer(uint _buffer) external;

	/// @notice sets the bonding curve Scale target
	function setScale(uint _scale) external;

	/// @notice sets the allocation of incoming PCV
	function setAllocation(address[] calldata pcvDeposits, uint[] calldata ratios) external;

	// ----------- Getters -----------

	/// @notice return current instantaneous bonding curve price 
	/// @return price reported as FEI per X with X being the underlying asset
	function getCurrentPrice() external view returns(Decimal.D256 memory);

	/// @notice return the average price of a transaction along bonding curve
	/// @param amountIn the amount of underlying used to purchase
	/// @return price reported as FEI per X with X being the underlying asset
	function getAveragePrice(uint amountIn) external view returns (Decimal.D256 memory);

	/// @notice return amount of FEI received after a bonding curve purchase
	/// @param amountIn the amount of underlying used to purchase
	/// @return amountOut the amount of FEI received
	function getAmountOut(uint amountIn) external view returns (uint amountOut); 

	/// @notice the Scale target at which bonding curve price fixes
	function scale() external view returns (uint);

	/// @notice a boolean signalling whether Scale has been reached
	function atScale() external view returns (bool);

	/// @notice the buffer applied on top of the peg purchase price once at Scale
	function buffer() external view returns(uint);

	/// @notice the total amount of FEI purchased on bonding curve. FEI_b from the whitepaper
	function totalPurchased() external view returns(uint);

	/// @notice the amount of PCV held in contract and ready to be allocated
	function getTotalPCVHeld() external view returns(uint);

	/// @notice amount of FEI paid for allocation when incentivized
	function incentiveAmount() external view returns(uint);
}


// File @uniswap/lib/contracts/libraries/Babylonian.sol@v4.0.1-alpha

// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.4.0;

// computes square roots using the babylonian method
// https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
library Babylonian {
    // credit for this implementation goes to
    // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
        // however that code costs significantly more gas
        uint256 xx = x;
        uint256 r = 1;
        if (xx >= 0x100000000000000000000000000000000) {
            xx >>= 128;
            r <<= 64;
        }
        if (xx >= 0x10000000000000000) {
            xx >>= 64;
            r <<= 32;
        }
        if (xx >= 0x100000000) {
            xx >>= 32;
            r <<= 16;
        }
        if (xx >= 0x10000) {
            xx >>= 16;
            r <<= 8;
        }
        if (xx >= 0x100) {
            xx >>= 8;
            r <<= 4;
        }
        if (xx >= 0x10) {
            xx >>= 4;
            r <<= 2;
        }
        if (xx >= 0x8) {
            r <<= 1;
        }
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1; // Seven iterations should be enough
        uint256 r1 = x / r;
        return (r < r1 ? r : r1);
    }
}


// File contracts/fei-protocol/utils/Roots.sol

pragma solidity ^0.6.0;

library Roots {
    // Newton's method https://en.wikipedia.org/wiki/Cube_root#Numerical_methods
    function cubeRoot(uint y) internal pure returns (uint z) {
        if (y > 7) {
            z = y;
            uint x = y / 3 + 1;
            while (x < z) {
                z = x;
                x = (y / (x * x) + (2 * x)) / 3;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    // x^(3/2);
    function threeHalfsRoot(uint x) internal pure returns (uint) {
        return sqrt(x) ** 3;
    }

    // x^(2/3);
    function twoThirdsRoot(uint x) internal pure returns (uint) {
        return cubeRoot(x) ** 2;
    }

    function sqrt(uint y) internal pure returns (uint) {
        return Babylonian.sqrt(y);
    }
}


// File contracts/fei-protocol/oracle/IOracle.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/// @title generic oracle interface for Fei Protocol
/// @author Fei Protocol
interface IOracle {
	
    // ----------- Events -----------

	event KillSwitchUpdate(bool _killSwitch);

	event Update(uint _peg);

    // ----------- State changing API -----------

    /// @notice updates the oracle price
    /// @return true if oracle is updated and false if unchanged
    function update() external returns (bool);

    // ----------- Governor only state changing API -----------

    /// @notice sets the kill switch on the oracle feed
    /// @param _killSwitch the new value for the kill switch
    function setKillSwitch(bool _killSwitch) external;

    // ----------- Getters -----------

    /// @notice read the oracle price
    /// @return oracle price
    /// @return true if price is valid
    /// @dev price is to be denominated in USD per X where X can be ETH, etc.
    function read() external view returns (Decimal.D256 memory, bool);

    /// @notice the kill switch for the oracle feed
    /// @return true if kill switch engaged
    /// @dev if kill switch is true, read will return invalid
    function killSwitch() external view returns (bool);
}


// File contracts/fei-protocol/refs/IOracleRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title A oracle Reference contract
/// @author Fei Protocol
/// @notice defines some utilities around interacting with the referenced oracle
interface IOracleRef {

	// ----------- Events -----------

	event OracleUpdate(address indexed _oracle);

	// ----------- State changing API -----------

	/// @notice updates the referenced oracle
	/// @return true if the update is effective
	function updateOracle() external returns(bool);

	// ----------- Governor only state changing API -----------

	/// @notice sets the referenced oracle
	/// @param _oracle the new oracle to reference
	function setOracle(address _oracle) external;

	// ----------- Getters -----------

	/// @notice the oracle reference by the contract
	/// @return the IOracle implementation address
	function oracle() external view returns(IOracle);

	/// @notice the peg price of the referenced oracle
	/// @return the peg as a Decimal
	/// @dev the peg is defined as FEI per X with X being ETH, dollars, etc
	function peg() external view returns(Decimal.D256 memory);

	/// @notice invert a peg price
	/// @param price the peg price to invert
	/// @return the inverted peg as a Decimal
	/// @dev the inverted peg would be X per FEI
	function invert(Decimal.D256 calldata price) external pure returns(Decimal.D256 memory);
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File contracts/fei-protocol/token/IFei.sol

pragma solidity ^0.6.2;

/// @title FEI stablecoin interface
/// @author Fei Protocol
interface IFei is IERC20 {

	// ----------- Events -----------

    event Minting(address indexed _to, address indexed _minter, uint _amount);

    event Burning(address indexed _to, address indexed _burner, uint _amount);

    event IncentiveContractUpdate(address indexed _incentivized, address indexed _incentiveContract);

    // ----------- State changing api -----------

    /// @notice burn FEI tokens from caller
    /// @param amount the amount to burn
    function burn(uint amount) external;

    // ----------- Burner only state changing api -----------

    /// @notice burn FEI tokens from specified account
    /// @param account the account to burn from
    /// @param amount the amount to burn
    function burnFrom(address account, uint amount) external;

    // ----------- Minter only state changing api -----------

    /// @notice mint FEI tokens
    /// @param account the account to mint to
    /// @param amount the amount to mint
    function mint(address account, uint amount) external;

    // ----------- Governor only state changing api -----------

    /// @param account the account to incentivize
    /// @param incentive the associated incentive contract
    function setIncentiveContract(address account, address incentive) external;

    // ----------- Getters -----------

    /// @notice get associated incentive contract
    /// @param account the address to check
    /// @return the associated incentive contract, 0 address if N/A
    function incentiveContract(address account) external view returns(address);
}


// File contracts/fei-protocol/core/IPermissions.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title Access control module for Core
/// @author Fei Protocol
interface IPermissions {
    // Governor only state changing api

    /// @notice creates a new role to be maintained
    /// @param role the new role id
    /// @param adminRole the admin role id for `role`
    /// @dev can also be used to update admin of existing role
	function createRole(bytes32 role, bytes32 adminRole) external;

    /// @notice grants minter role to address
    /// @param minter new minter
	function grantMinter(address minter) external;

    /// @notice grants burner role to address
    /// @param burner new burner
	function grantBurner(address burner) external;

    /// @notice grants controller role to address
    /// @param pcvController new controller
	function grantPCVController(address pcvController) external;

    /// @notice grants governor role to address
    /// @param governor new governor
	function grantGovernor(address governor) external;

    /// @notice grants revoker role to address
    /// @param revoker new revoker
	function grantRevoker(address revoker) external;

    /// @notice revokes minter role from address
    /// @param minter ex minter
    function revokeMinter(address minter) external;

    /// @notice revokes burner role from address
    /// @param burner ex burner
    function revokeBurner(address burner) external;

    /// @notice revokes pcvController role from address
    /// @param pcvController ex pcvController
    function revokePCVController(address pcvController) external;

    /// @notice revokes governor role from address
    /// @param governor ex governor
    function revokeGovernor(address governor) external;

    /// @notice revokes revoker role from address
    /// @param revoker ex revoker
    function revokeRevoker(address revoker) external;

    // Revoker only state changing api

    /// @notice revokes a role from address
    /// @param role the role to revoke
    /// @param account the address to revoke the role from
    function revokeOverride(bytes32 role, address account) external;

    // Getters

    /// @notice checks if address is a burner
    /// @param _address address to check
    /// @return true _address is a burner
	function isBurner(address _address) external view returns (bool);

    /// @notice checks if address is a minter
    /// @param _address address to check
    /// @return true _address is a minter
	function isMinter(address _address) external view returns (bool);

    /// @notice checks if address is a governor
    /// @param _address address to check
    /// @return true _address is a governor
	function isGovernor(address _address) external view returns (bool);

    /// @notice checks if address is a revoker
    /// @param _address address to check
    /// @return true _address is a revoker
    function isRevoker(address _address) external view returns (bool);

    /// @notice checks if address is a controller
    /// @param _address address to check
    /// @return true _address is a controller
	function isPCVController(address _address) external view returns (bool);
}


// File contracts/fei-protocol/core/ICore.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;



/// @title Source of truth for Fei Protocol
/// @author Fei Protocol
/// @notice maintains roles, access control, fei, tribe, genesisGroup, and the TRIBE treasury
interface ICore is IPermissions {

	// ----------- Events -----------

    event FeiUpdate(address indexed _fei);
    event TribeAllocation(address indexed _to, uint _amount);
    event GenesisPeriodComplete(uint _timestamp);

    // ----------- Governor only state changing api -----------

    /// @notice sets Fei address to a new address
    /// @param token new fei address
    function setFei(address token) external;

    /// @notice sets Genesis Group address
    /// @param _genesisGroup new genesis group address
    function setGenesisGroup(address _genesisGroup) external;

    /// @notice sends TRIBE tokens from treasury to an address
    /// @param to the address to send TRIBE to
    /// @param amount the amount of TRIBE to send
    function allocateTribe(address to, uint amount) external;

    // ----------- Genesis Group only state changing api -----------

    /// @notice marks the end of the genesis period
    /// @dev can only be called once
	function completeGenesisGroup() external;

    // ----------- Getters -----------

    /// @notice the address of the FEI contract
    /// @return fei contract
	function fei() external view returns (IFei);

    /// @notice the address of the TRIBE contract
    /// @return tribe contract
	function tribe() external view returns (IERC20);

    /// @notice the address of the GenesisGroup contract
    /// @return genesis group contract
    function genesisGroup() external view returns(address);

    /// @notice determines whether in genesis period or not
    /// @return true if in genesis period
	function hasGenesisGroupCompleted() external view returns(bool);
}


// File contracts/fei-protocol/refs/ICoreRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;



/// @title A Core Reference contract
/// @author Fei Protocol
/// @notice defines some modifiers and utilities around interacting with Core
interface ICoreRef {

	// ----------- Events -----------

    event CoreUpdate(address indexed _core);

    // ----------- Governor only state changing api -----------

    /// @notice set new Core reference address
    /// @param core the new core address
    function setCore(address core) external;

    // ----------- Getters -----------

    /// @notice address of the Core contract referenced
    /// @return ICore implementation address
	function core() external view returns (ICore);

    /// @notice address of the Fei contract referenced by Core
    /// @return IFei implementation address
    function fei() external view returns (IFei);

    /// @notice address of the Tribe contract referenced by Core
    /// @return IERC20 implementation address
    function tribe() external view returns (IERC20);

    /// @notice fei balance of contract
    /// @return fei amount held
	function feiBalance() external view returns(uint);

    /// @notice tribe balance of contract
    /// @return tribe amount held
    function tribeBalance() external view returns(uint);
}


// File contracts/fei-protocol/refs/CoreRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/// @title Abstract implementation of ICoreRef
/// @author Fei Protocol
abstract contract CoreRef is ICoreRef {
	ICore private _core;

	/// @notice CoreRef constructor
	/// @param core Fei Core to reference
	constructor(address core) public {
		_core = ICore(core);
	}

	modifier ifMinterSelf() {
		if (_core.isMinter(address(this))) {
			_;
		}
	}

	modifier ifBurnerSelf() {
		if (_core.isBurner(address(this))) {
			_;
		}
	}

	modifier onlyMinter() {
		require(_core.isMinter(msg.sender), "CoreRef: Caller is not a minter");
		_;
	}

	modifier onlyBurner() {
		require(_core.isBurner(msg.sender), "CoreRef: Caller is not a burner");
		_;
	}

	modifier onlyPCVController() {
		require(_core.isPCVController(msg.sender), "CoreRef: Caller is not a PCV controller");
		_;
	}

	modifier onlyGovernor() {
		require(_core.isGovernor(msg.sender), "CoreRef: Caller is not a governor");
		_;
	}

	modifier onlyFei() {
		require(msg.sender == address(fei()), "CoreRef: Caller is not FEI");
		_;
	}

	modifier onlyGenesisGroup() {
		require(msg.sender == _core.genesisGroup(), "CoreRef: Caller is not GenesisGroup");
		_;
	}

	modifier postGenesis() {
		require(_core.hasGenesisGroupCompleted(), "CoreRef: Still in Genesis Period");
		_;
	}

	function setCore(address core) external override onlyGovernor {
		_core = ICore(core);
		emit CoreUpdate(core);
	}
 
	function core() public view override returns(ICore) {
		return _core;
	}

	function fei() public view override returns(IFei) {
		return _core.fei();
	}

	function tribe() public view override returns(IERC20) {
		return _core.tribe();
	}

	function feiBalance() public view override returns (uint) {
		return fei().balanceOf(address(this));
	}

	function tribeBalance() public view override returns (uint) {
		return tribe().balanceOf(address(this));
	}

    function _burnFeiHeld() internal {
    	fei().burn(feiBalance());
    }

    function _mintFei(uint amount) internal {
		fei().mint(address(this), amount);
	}
}


// File contracts/fei-protocol/refs/OracleRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title Abstract implementation of IOracleRef
/// @author Fei Protocol
abstract contract OracleRef is IOracleRef, CoreRef {
	using Decimal for Decimal.D256;

	IOracle public override oracle;

	/// @notice OracleRef constructor
	/// @param _core Fei Core to reference
	/// @param _oracle oracle to reference
	constructor(address _core, address _oracle) public CoreRef(_core) {
        _setOracle(_oracle);
    }

	function setOracle(address _oracle) external override onlyGovernor {
		_setOracle(_oracle);
        emit OracleUpdate(_oracle);
	}

    function invert(Decimal.D256 memory price) public override pure returns(Decimal.D256 memory) {
    	return Decimal.one().div(price);
    }

    function updateOracle() public override returns(bool) {
    	return oracle.update();
    }

    function peg() public override view returns(Decimal.D256 memory) {
    	(Decimal.D256 memory _peg, bool valid) = oracle.read();
    	require(valid, "OracleRef: oracle invalid");
    	return _peg;
    }

    function _setOracle(address _oracle) internal {
    	oracle = IOracle(_oracle);
    }
}


// File contracts/fei-protocol/pcv/PCVSplitter.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/// @title abstract contract for splitting PCV into different deposits
/// @author Fei Protocol
abstract contract PCVSplitter {

	/// @notice total allocation allowed representing 100%
	uint public constant ALLOCATION_GRANULARITY = 10_000; 

	uint[] private ratios;
	address[] private pcvDeposits;

	event AllocationUpdate(address[] _pcvDeposits, uint[] _ratios);

	/// @notice PCVSplitter constructor
	/// @param _pcvDeposits list of PCV Deposits to split to
	/// @param _ratios ratios for splitting PCV Deposit allocations
	constructor(address[] memory _pcvDeposits, uint[] memory _ratios) public {
		_setAllocation(_pcvDeposits, _ratios);
	}

	/// @notice make sure an allocation has matching lengths and totals the ALLOCATION_GRANULARITY
	/// @param _pcvDeposits new list of pcv deposits to send to
	/// @param _ratios new ratios corresponding to the PCV deposits
	/// @return true if it is a valid allocation
	function checkAllocation(address[] memory _pcvDeposits, uint[] memory _ratios) public pure returns (bool) {
		require(_pcvDeposits.length == _ratios.length, "PCVSplitter: PCV Deposits and ratios are different lengths");

		uint total;
		for (uint i; i < _ratios.length; i++) {
			total += _ratios[i];
		}

		require(total == ALLOCATION_GRANULARITY, "PCVSplitter: ratios do not total 100%");
		
		return true;
	}
	
	/// @notice gets the pcvDeposits and ratios of the splitter
	function getAllocation() public view returns (address[] memory, uint[] memory) {
		return (pcvDeposits, ratios);
	}

	/// @notice distribute funds to single PCV deposit
	/// @param amount amount of funds to send
	/// @param pcvDeposit the pcv deposit to send funds
	function _allocateSingle(uint amount, address pcvDeposit) internal virtual ;

	/// @notice sets a new allocation for the splitter
	/// @param _pcvDeposits new list of pcv deposits to send to
	/// @param _ratios new ratios corresponding to the PCV deposits. Must total ALLOCATION_GRANULARITY
	function _setAllocation(address[] memory _pcvDeposits, uint[] memory _ratios) internal {
		checkAllocation(_pcvDeposits, _ratios);

		pcvDeposits = _pcvDeposits;
		ratios = _ratios;

		emit AllocationUpdate(_pcvDeposits, _ratios);
	}

	/// @notice distribute funds to all pcv deposits at specified allocation ratios
	/// @param total amount of funds to send
	function _allocate(uint total) internal {
		uint granularity = ALLOCATION_GRANULARITY;
		for (uint i; i < ratios.length; i++) {
			uint amount = total * ratios[i] / granularity;
			_allocateSingle(amount, pcvDeposits[i]);
		}
	}
}


// File contracts/fei-protocol/utils/SafeMath32.sol

// SPDX-License-Identifier: MIT

// SafeMath for 32 bit integers inspired by OpenZeppelin SafeMath
pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath32 { 
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint32 a, uint32 b) internal pure returns (uint32) {
        uint32 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint32 a, uint32 b) internal pure returns (uint32) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint32 a, uint32 b, string memory errorMessage) internal pure returns (uint32) {
        require(b <= a, errorMessage);
        uint32 c = a - b;

        return c;
    }
}


// File @openzeppelin/contracts/utils/SafeCast.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;


/**
 * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 *
 * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
 * all math on `uint256` and `int256` and then downcasting.
 */
library SafeCast {

    /**
     * @dev Returns the downcasted uint128 from uint256, reverting on
     * overflow (when the input is greater than largest uint128).
     *
     * Counterpart to Solidity's `uint128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
        return uint128(value);
    }

    /**
     * @dev Returns the downcasted uint64 from uint256, reverting on
     * overflow (when the input is greater than largest uint64).
     *
     * Counterpart to Solidity's `uint64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toUint64(uint256 value) internal pure returns (uint64) {
        require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
        return uint64(value);
    }

    /**
     * @dev Returns the downcasted uint32 from uint256, reverting on
     * overflow (when the input is greater than largest uint32).
     *
     * Counterpart to Solidity's `uint32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toUint32(uint256 value) internal pure returns (uint32) {
        require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
        return uint32(value);
    }

    /**
     * @dev Returns the downcasted uint16 from uint256, reverting on
     * overflow (when the input is greater than largest uint16).
     *
     * Counterpart to Solidity's `uint16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toUint16(uint256 value) internal pure returns (uint16) {
        require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
        return uint16(value);
    }

    /**
     * @dev Returns the downcasted uint8 from uint256, reverting on
     * overflow (when the input is greater than largest uint8).
     *
     * Counterpart to Solidity's `uint8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits.
     */
    function toUint8(uint256 value) internal pure returns (uint8) {
        require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
        return uint8(value);
    }

    /**
     * @dev Converts a signed int256 into an unsigned uint256.
     *
     * Requirements:
     *
     * - input must be greater than or equal to 0.
     */
    function toUint256(int256 value) internal pure returns (uint256) {
        require(value >= 0, "SafeCast: value must be positive");
        return uint256(value);
    }

    /**
     * @dev Returns the downcasted int128 from int256, reverting on
     * overflow (when the input is less than smallest int128 or
     * greater than largest int128).
     *
     * Counterpart to Solidity's `int128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     *
     * _Available since v3.1._
     */
    function toInt128(int256 value) internal pure returns (int128) {
        require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
        return int128(value);
    }

    /**
     * @dev Returns the downcasted int64 from int256, reverting on
     * overflow (when the input is less than smallest int64 or
     * greater than largest int64).
     *
     * Counterpart to Solidity's `int64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     *
     * _Available since v3.1._
     */
    function toInt64(int256 value) internal pure returns (int64) {
        require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
        return int64(value);
    }

    /**
     * @dev Returns the downcasted int32 from int256, reverting on
     * overflow (when the input is less than smallest int32 or
     * greater than largest int32).
     *
     * Counterpart to Solidity's `int32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     *
     * _Available since v3.1._
     */
    function toInt32(int256 value) internal pure returns (int32) {
        require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
        return int32(value);
    }

    /**
     * @dev Returns the downcasted int16 from int256, reverting on
     * overflow (when the input is less than smallest int16 or
     * greater than largest int16).
     *
     * Counterpart to Solidity's `int16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     *
     * _Available since v3.1._
     */
    function toInt16(int256 value) internal pure returns (int16) {
        require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
        return int16(value);
    }

    /**
     * @dev Returns the downcasted int8 from int256, reverting on
     * overflow (when the input is less than smallest int8 or
     * greater than largest int8).
     *
     * Counterpart to Solidity's `int8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits.
     *
     * _Available since v3.1._
     */
    function toInt8(int256 value) internal pure returns (int8) {
        require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
        return int8(value);
    }

    /**
     * @dev Converts an unsigned uint256 into a signed int256.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxInt256.
     */
    function toInt256(uint256 value) internal pure returns (int256) {
        require(value < 2**255, "SafeCast: value doesn't fit in an int256");
        return int256(value);
    }
}


// File contracts/fei-protocol/utils/Timed.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title an abstract contract for timed events
/// @author Fei Protocol
abstract contract Timed {
    using SafeCast for uint;
	using SafeMath32 for uint32;

    /// @notice the start timestamp of the timed period
    uint32 public startTime;

    /// @notice the duration of the timed period
	uint32 public duration;

    constructor(uint32 _duration) public {
        duration = _duration;
    }

    /// @notice return true if time period has ended
    function isTimeEnded() public view returns (bool) {
        return remainingTime() == 0;
    }

    /// @notice number of seconds remaining until time is up
    /// @return remaining
    function remainingTime() public view returns (uint32) {
        return duration.sub(timestamp());
    }

    /// @notice number of seconds since contract was initialized
    /// @return timestamp
    /// @dev will be less than or equal to duration
    function timestamp() public view returns (uint32) {
		uint32 d = duration;
		// solhint-disable-next-line not-rely-on-time
		uint32 t = now.toUint32().sub(startTime);
		return t > d ? d : t;
    }

    function _initTimed() internal {
        // solhint-disable-next-line not-rely-on-time
        startTime = now.toUint32();
    }
}


// File contracts/fei-protocol/bondingcurve/BondingCurve.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;






/// @title an abstract bonding curve for purchasing FEI
/// @author Fei Protocol
abstract contract BondingCurve is IBondingCurve, OracleRef, PCVSplitter, Timed {
    using Decimal for Decimal.D256;
    using Roots for uint;

	uint public override scale;
	uint public override totalPurchased; // FEI_b for this curve

	uint public override buffer = 100;
	uint public constant BUFFER_GRANULARITY = 10_000;

	uint public override incentiveAmount;

	/// @notice constructor
	/// @param _scale the Scale target where peg fixes
	/// @param _core Fei Core to reference
	/// @param _pcvDeposits the PCV Deposits for the PCVSplitter
	/// @param _ratios the ratios for the PCVSplitter
	/// @param _oracle the UniswapOracle to reference
	/// @param _duration the duration between incentivizing allocations
	/// @param _incentive the amount rewarded to the caller of an allocation
	constructor(
		uint _scale, 
		address _core, 
		address[] memory _pcvDeposits, 
		uint[] memory _ratios, 
		address _oracle,
		uint32 _duration,
		uint _incentive
	) public
		OracleRef(_core, _oracle)
		PCVSplitter(_pcvDeposits, _ratios)
		Timed(_duration)
	{
		_setScale(_scale);
		incentiveAmount = _incentive;
	}

	function setScale(uint _scale) external override onlyGovernor {
		_setScale(_scale);
		emit ScaleUpdate(_scale);
	}

	function setBuffer(uint _buffer) external override onlyGovernor {
		require(_buffer < BUFFER_GRANULARITY, "BondingCurve: Buffer exceeds or matches granularity");
		buffer = _buffer;
		emit BufferUpdate(_buffer);
	}

	function setAllocation(address[] calldata allocations, uint[] calldata ratios) external override onlyGovernor {
		_setAllocation(allocations, ratios);
	}

	function allocate() external override {
		uint amount = getTotalPCVHeld();
		require(amount != 0, "BondingCurve: No PCV held");

		_allocate(amount);
		_incentivize();
		
		emit Allocate(msg.sender, amount);
	}

	function atScale() public override view returns (bool) {
		return totalPurchased >= scale;
	}

	function getCurrentPrice() public view override returns(Decimal.D256 memory) {
		if (atScale()) {
			return peg().mul(_getBuffer());
		}
		return peg().div(_getBondingCurvePriceMultiplier());
	}

	function getAmountOut(uint amountIn) public view override returns (uint amountOut) {
		uint adjustedAmount = getAdjustedAmount(amountIn);
		if (atScale()) {
			return _getBufferAdjustedAmount(adjustedAmount);
		}
		return _getBondingCurveAmountOut(adjustedAmount);
	}

	function getAveragePrice(uint amountIn) public view override returns (Decimal.D256 memory) {
		uint adjustedAmount = getAdjustedAmount(amountIn);
		uint amountOut = getAmountOut(amountIn);
		return Decimal.ratio(adjustedAmount, amountOut);
	}

	function getAdjustedAmount(uint amountIn) internal view returns (uint) {
		return peg().mul(amountIn).asUint256();
	}

	function getTotalPCVHeld() public view override virtual returns(uint);

	function _purchase(uint amountIn, address to) internal returns (uint amountOut) {
	 	updateOracle();
		
	 	amountOut = getAmountOut(amountIn);
	 	incrementTotalPurchased(amountOut);
		fei().mint(to, amountOut);

		emit Purchase(to, amountIn, amountOut);

		return amountOut;
	}

	function incrementTotalPurchased(uint amount) internal {
		totalPurchased += amount;
	}

	function _setScale(uint _scale) internal {
		scale = _scale;
	}

	function _incentivize() internal virtual {
		if (isTimeEnded()) {
			_initTimed();
			fei().mint(msg.sender, incentiveAmount);
		}
	}

	function _getBondingCurvePriceMultiplier() internal view virtual returns(Decimal.D256 memory);

	function _getBondingCurveAmountOut(uint adjustedAmountIn) internal view virtual returns(uint);

	function _getBuffer() internal view returns(Decimal.D256 memory) {
		uint granularity = BUFFER_GRANULARITY;
		return Decimal.ratio(granularity - buffer, granularity);
	} 

	function _getBufferAdjustedAmount(uint amountIn) internal view returns(uint) {
		return _getBuffer().mul(amountIn).asUint256();
	}
}


// File contracts/fei-protocol/pcv/IPCVDeposit.sol

pragma solidity ^0.6.2;

/// @title a PCV Deposit interface
/// @author Fei Protocol
interface IPCVDeposit {

	// ----------- Events -----------
    event Deposit(address indexed _from, uint _amount);

    event Withdrawal(address indexed _caller, address indexed _to, uint _amount);

    // ----------- State changing api -----------

    /// @notice deposit tokens into the PCV allocation
    /// @param amount of tokens deposited
    function deposit(uint amount) external payable;

    // ----------- PCV Controller only state changing api -----------

    /// @notice withdraw tokens from the PCV allocation
    /// @param amount of tokens withdrawn
    /// @param to the address to send PCV to
    function withdraw(address to, uint amount) external;

    // ----------- Getters -----------
    
    /// @notice returns total value of PCV in the Deposit
    function totalValue() external view returns(uint);
}


// File contracts/fei-protocol/bondingcurve/EthBondingCurve.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title a square root growth bonding curve for purchasing FEI with ETH
/// @author Fei Protocol
contract EthBondingCurve is BondingCurve {

	uint internal immutable SHIFT; // k shift

	constructor(
		uint scale, 
		address core, 
		address[] memory pcvDeposits, 
		uint[] memory ratios, 
		address oracle,
		uint32 duration,
		uint incentive
	) public BondingCurve(
			scale, 
			core, 
			pcvDeposits, 
			ratios, 
			oracle, 
			duration,
			incentive
	) {
		SHIFT = scale / 3; // Enforces a .50c starting price per bonding curve formula
	}

	function purchase(address to, uint amountIn) external override payable postGenesis returns (uint amountOut) {
		require(msg.value == amountIn, "Bonding Curve: Sent value does not equal input");
		return _purchase(amountIn, to);
	}

	function getTotalPCVHeld() public view override returns(uint) {
		return address(this).balance;
	}

	// Represents the integral solved for upper bound of P(x) = ((k+X)/(k+S))^1/2 * O. Subtracting starting point C
	function _getBondingCurveAmountOut(uint adjustedAmountIn) internal view override returns (uint amountOut) {
		uint shiftTotal = _shift(totalPurchased); // k + C
		uint radicand = (3 * adjustedAmountIn * _shift(scale).sqrt() / 2) + shiftTotal.threeHalfsRoot();
		return radicand.twoThirdsRoot() - shiftTotal; // result - (k + C)
	}

	function _getBondingCurvePriceMultiplier() internal view override returns(Decimal.D256 memory) {
		return Decimal.ratio(_shift(totalPurchased).sqrt(), _shift(scale).sqrt());
	}

	function _allocateSingle(uint amount, address pcvDeposit) internal override {
		IPCVDeposit(pcvDeposit).deposit{value : amount}(amount);
	}

	function _shift(uint x) internal view returns(uint) {
		return SHIFT + x;
	}
}


// File contracts/fei-protocol/core/Permissions.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title IPermissions implementation
/// @author Fei Protocol
contract Permissions is IPermissions, AccessControl {
	bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
	bytes32 public constant PCV_CONTROLLER_ROLE = keccak256("PCV_CONTROLLER_ROLE");
	bytes32 public constant GOVERN_ROLE = keccak256("GOVERN_ROLE");
	bytes32 public constant REVOKE_ROLE = keccak256("REVOKE_ROLE");

	constructor() public {
		_setupGovernor(address(this));
		_setRoleAdmin(MINTER_ROLE, GOVERN_ROLE);
		_setRoleAdmin(BURNER_ROLE, GOVERN_ROLE);
		_setRoleAdmin(PCV_CONTROLLER_ROLE, GOVERN_ROLE);
		_setRoleAdmin(GOVERN_ROLE, GOVERN_ROLE);
		_setRoleAdmin(REVOKE_ROLE, GOVERN_ROLE);
	}

	modifier onlyGovernor() {
		require(isGovernor(msg.sender), "Permissions: Caller is not a governor");
		_;
	}

	modifier onlyRevoker() {
		require(isRevoker(msg.sender), "Permissions: Caller is not a revoker");
		_;
	}

	function createRole(bytes32 role, bytes32 adminRole) external override onlyGovernor {
		_setRoleAdmin(role, adminRole);
	}

	function grantMinter(address minter) external override onlyGovernor {
		grantRole(MINTER_ROLE, minter);
	} 

	function grantBurner(address burner) external override onlyGovernor {
		grantRole(BURNER_ROLE, burner);
	} 

	function grantPCVController(address pcvController) external override onlyGovernor {
		grantRole(PCV_CONTROLLER_ROLE, pcvController);
	}

	function grantGovernor(address governor) external override onlyGovernor {
		grantRole(GOVERN_ROLE, governor);
	}

	function grantRevoker(address revoker) external override onlyGovernor {
		grantRole(REVOKE_ROLE, revoker);
	}

	function revokeMinter(address minter) external override onlyGovernor {
		revokeRole(MINTER_ROLE, minter);
	} 

	function revokeBurner(address burner) external override onlyGovernor {
		revokeRole(BURNER_ROLE, burner);
	} 

	function revokePCVController(address pcvController) external override onlyGovernor {
		revokeRole(PCV_CONTROLLER_ROLE, pcvController);
	}

	function revokeGovernor(address governor) external override onlyGovernor {
		revokeRole(GOVERN_ROLE, governor);
	}

	function revokeRevoker(address revoker) external override onlyGovernor {
		revokeRole(REVOKE_ROLE, revoker);
	}

	function revokeOverride(bytes32 role, address account) external override onlyRevoker {
		this.revokeRole(role, account);
	}

	function isMinter(address _address) external override view returns (bool) {
		return hasRole(MINTER_ROLE, _address);
	}

	function isBurner(address _address) external override view returns (bool) {
		return hasRole(BURNER_ROLE, _address);
	}

	function isPCVController(address _address) external override view returns (bool) {
		return hasRole(PCV_CONTROLLER_ROLE, _address);
	}

	// only virtual for testing mock override
	function isGovernor(address _address) public override view virtual returns (bool) {
		return hasRole(GOVERN_ROLE, _address);
	}

	function isRevoker(address _address) public override view returns (bool) {
		return hasRole(REVOKE_ROLE, _address);
	}

	function _setupGovernor(address governor) internal {
		_setupRole(GOVERN_ROLE, governor);
	}
}


// File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
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
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
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
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
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
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
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
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}


// File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;


/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract ERC20Burnable is Context, ERC20 {
    using SafeMath for uint256;

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
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
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
}


// File contracts/fei-protocol/token/IIncentive.sol

pragma solidity ^0.6.2;

/// @title incentive contract interface
/// @author Fei Protocol
/// @notice Called by FEI token contract when transferring with an incentivized address
/// @dev should be appointed as a Minter or Burner as needed
interface IIncentive {

	// ----------- Fei only state changing api -----------

	/// @notice apply incentives on transfer
	/// @param sender the sender address of the FEI
	/// @param receiver the receiver address of the FEI
	/// @param operator the operator (msg.sender) of the transfer
	/// @param amount the amount of FEI transferred
    function incentivize(
    	address sender, 
    	address receiver, 
    	address operator, 
    	uint amount
    ) external;
}


// File contracts/fei-protocol/token/Fei.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;





/// @title IFei implementation
/// @author Fei Protocol
contract Fei is IFei, ERC20, ERC20Burnable, CoreRef {

    mapping (address => address) public override incentiveContract;

    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

    /// @notice Fei token constructor
    /// @param core Fei Core address to reference
	constructor(address core) public ERC20("Fei USD", "FEI") CoreRef(core) {
        uint chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name())),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function setIncentiveContract(address account, address incentive) external override onlyGovernor {
        incentiveContract[account] = incentive;
        emit IncentiveContractUpdate(account, incentive);
    }

    function mint(address account, uint amount) external override onlyMinter {
        _mint(account, amount);
        emit Minting(account, msg.sender, amount);
    }

    function burn(uint amount) public override(IFei, ERC20Burnable) {
        super.burn(amount);
        emit Burning(msg.sender, msg.sender, amount);
    }

    function burnFrom(address account, uint amount) public override(IFei, ERC20Burnable) onlyBurner {
        _burn(account, amount);
        emit Burning(account, msg.sender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal override {
        // If not minting or burning
        if (from != address(0) && to != address(0)) {
            _checkAndApplyIncentives(from, to, amount);      
        }
    }

    function _checkAndApplyIncentives(address sender, address recipient, uint amount) internal {
        // incentive on sender
        address senderIncentive = incentiveContract[sender];
        if (senderIncentive != address(0)) {
            IIncentive(senderIncentive).incentivize(sender, recipient, msg.sender, amount);
        }

        // incentive on recipient
        address recipientIncentive = incentiveContract[recipient];
        if (recipientIncentive != address(0)) {
            IIncentive(recipientIncentive).incentivize(sender, recipient, msg.sender, amount);
        }

        // incentive on operator
        address operatorIncentive = incentiveContract[msg.sender];
        if (msg.sender != sender && msg.sender != recipient && operatorIncentive != address(0)) {
            IIncentive(operatorIncentive).incentivize(sender, recipient, msg.sender, amount);
        }

        // all incentive
        address allIncentive = incentiveContract[address(0)];
        if (allIncentive != address(0)) {
            IIncentive(allIncentive).incentivize(sender, recipient, msg.sender, amount);
        }
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, 'Fei: EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'Fei: INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
}


// File contracts/fei-protocol/dao/Tribe.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

// Forked from Tribeswap's UNI
// Reference: https://etherscan.io/address/0x1f9840a85d5af5bf1d1762f925bdaddc4201f984#code

contract Tribe {
    /// @notice EIP-20 token name for this token
    // solhint-disable-next-line const-name-snakecase
    string public constant name = "Tribe";

    /// @notice EIP-20 token symbol for this token
    // solhint-disable-next-line const-name-snakecase
    string public constant symbol = "TRIBE";

    /// @notice EIP-20 token decimals for this token
    // solhint-disable-next-line const-name-snakecase
    uint8 public constant decimals = 18;

    /// @notice Total number of tokens in circulation
    // solhint-disable-next-line const-name-snakecase
    uint public totalSupply = 1_000_000_000e18; // 1 billion Tribe

    /// @notice Address which may mint new tokens
    address public minter;

    /// @notice Allowance amounts on behalf of others
    mapping (address => mapping (address => uint96)) internal allowances;

    /// @notice Official record of token balances for each account
    mapping (address => uint96) internal balances;

    /// @notice A record of each accounts delegate
    mapping (address => address) public delegates;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint96 votes;
    }

    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice The EIP-712 typehash for the permit struct used by the contract
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

    /// @notice An event thats emitted when the minter address is changed
    event MinterChanged(address minter, address newMinter);

    /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

    /// @notice The standard EIP-20 transfer event
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// @notice The standard EIP-20 approval event
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /**
     * @notice Construct a new Tribe token
     * @param account The initial account to grant all the tokens
     * @param minter_ The account with minting ability
     */
    constructor(address account, address minter_) public {
        balances[account] = uint96(totalSupply);
        emit Transfer(address(0), account, totalSupply);
        minter = minter_;
        emit MinterChanged(address(0), minter);
    }

    /**
     * @notice Change the minter address
     * @param minter_ The address of the new minter
     */
    function setMinter(address minter_) external {
        require(msg.sender == minter, "Tribe::setMinter: only the minter can change the minter address");
        emit MinterChanged(minter, minter_);
        minter = minter_;
    }

    /**
     * @notice Mint new tokens
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to be minted
     */
    function mint(address dst, uint rawAmount) external {
        require(msg.sender == minter, "Tribe::mint: only the minter can mint");
        require(dst != address(0), "Tribe::mint: cannot transfer to the zero address");

        // mint the amount
        uint96 amount = safe96(rawAmount, "Tribe::mint: amount exceeds 96 bits");
        uint96 safeSupply = safe96(totalSupply, "Tribe::mint: totalSupply exceeds 96 bits");
        totalSupply = add96(safeSupply, amount, "Tribe::mint: totalSupply exceeds 96 bits");

        // transfer the amount to the recipient
        balances[dst] = add96(balances[dst], amount, "Tribe::mint: transfer amount overflows");
        emit Transfer(address(0), dst, amount);

        // move delegates
        _moveDelegates(address(0), delegates[dst], amount);
    }

    /**
     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
     * @param account The address of the account holding the funds
     * @param spender The address of the account spending the funds
     * @return The number of tokens approved
     */
    function allowance(address account, address spender) external view returns (uint) {
        return allowances[account][spender];
    }

    /**
     * @notice Approve `spender` to transfer up to `amount` from `src`
     * @dev This will overwrite the approval amount for `spender`
     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
     * @param spender The address of the account which may transfer tokens
     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
     * @return Whether or not the approval succeeded
     */
    function approve(address spender, uint rawAmount) external returns (bool) {
        uint96 amount;
        if (rawAmount == uint(-1)) {
            amount = uint96(-1);
        } else {
            amount = safe96(rawAmount, "Tribe::approve: amount exceeds 96 bits");
        }

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Triggers an approval from owner to spends
     * @param owner The address to approve from
     * @param spender The address to be approved
     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
     * @param deadline The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        uint96 amount;
        if (rawAmount == uint(-1)) {
            amount = uint96(-1);
        } else {
            amount = safe96(rawAmount, "Tribe::permit: amount exceeds 96 bits");
        }

        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "Tribe::permit: invalid signature");
        require(signatory == owner, "Tribe::permit: unauthorized");
        require(now <= deadline, "Tribe::permit: signature expired");

        allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    /**
     * @notice Get the number of tokens held by the `account`
     * @param account The address of the account to get the balance of
     * @return The number of tokens held
     */
    function balanceOf(address account) external view returns (uint) {
        return balances[account];
    }

    /**
     * @notice Transfer `amount` tokens from `msg.sender` to `dst`
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transfer(address dst, uint rawAmount) external returns (bool) {
        uint96 amount = safe96(rawAmount, "Tribe::transfer: amount exceeds 96 bits");
        _transferTokens(msg.sender, dst, amount);
        return true;
    }

    /**
     * @notice Transfer `amount` tokens from `src` to `dst`
     * @param src The address of the source account
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
        address spender = msg.sender;
        uint96 spenderAllowance = allowances[src][spender];
        uint96 amount = safe96(rawAmount, "Tribe::approve: amount exceeds 96 bits");

        if (spender != src && spenderAllowance != uint96(-1)) {
            uint96 newAllowance = sub96(spenderAllowance, amount, "Tribe::transferFrom: transfer amount exceeds spender allowance");
            allowances[src][spender] = newAllowance;

            emit Approval(src, spender, newAllowance);
        }

        _transferTokens(src, dst, amount);
        return true;
    }

    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegatee The address to delegate votes to
     */
    function delegate(address delegatee) public {
        return _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "Tribe::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "Tribe::delegateBySig: invalid nonce");
        // solhint-disable-next-line not-rely-on-time
        require(now <= expiry, "Tribe::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }

    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account) external view returns (uint96) {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
        require(blockNumber < block.number, "Tribe::getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _delegate(address delegator, address delegatee) internal {
        address currentDelegate = delegates[delegator];
        uint96 delegatorBalance = balances[delegator];
        delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _transferTokens(address src, address dst, uint96 amount) internal {
        require(src != address(0), "Tribe::_transferTokens: cannot transfer from the zero address");
        require(dst != address(0), "Tribe::_transferTokens: cannot transfer to the zero address");

        balances[src] = sub96(balances[src], amount, "Tribe::_transferTokens: transfer amount exceeds balance");
        balances[dst] = add96(balances[dst], amount, "Tribe::_transferTokens: transfer amount overflows");
        emit Transfer(src, dst, amount);

        _moveDelegates(delegates[src], delegates[dst], amount);
    }

    function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint96 srcRepNew = sub96(srcRepOld, amount, "Tribe::_moveVotes: vote amount underflows");
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint96 dstRepNew = add96(dstRepOld, amount, "Tribe::_moveVotes: vote amount overflows");
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
      uint32 blockNumber = safe32(block.number, "Tribe::_writeCheckpoint: block number exceeds 32 bits");

      if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
          checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
      } else {
          checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
          numCheckpoints[delegatee] = nCheckpoints + 1;
      }

      emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }

    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
        require(n < 2**96, errorMessage);
        return uint96(n);
    }

    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
        uint96 c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function getChainId() internal pure returns (uint) {
        uint256 chainId;
        // solhint-disable-next-line no-inline-assembly
        assembly { chainId := chainid() }
        return chainId;
    }
}


// File contracts/fei-protocol/core/Core.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;






/// @title ICore implementation
/// @author Fei Protocol
contract Core is ICore, Permissions {

	IFei public override fei;
	IERC20 public override tribe;

	address public override genesisGroup;
	bool public override hasGenesisGroupCompleted;

	constructor() public {
		_setupGovernor(msg.sender);
		Fei _fei = new Fei(address(this));
		fei = IFei(address(_fei));

		Tribe _tribe = new Tribe(address(this), msg.sender);
		tribe = IERC20(address(_tribe));
	}

	function setFei(address token) external override onlyGovernor {
		fei = IFei(token);
		emit FeiUpdate(token);
	}

	function setGenesisGroup(address _genesisGroup) external override onlyGovernor {
		genesisGroup = _genesisGroup;
	}

	function allocateTribe(address to, uint amount) external override onlyGovernor {
		IERC20 _tribe = tribe;
		require(_tribe.balanceOf(address(this)) > amount, "Core: Not enough Tribe");

		_tribe.transfer(to, amount);

		emit TribeAllocation(to, amount);
	}

	function completeGenesisGroup() external override {
		require(!hasGenesisGroupCompleted, "Core: Genesis Group already complete");
		require(msg.sender == genesisGroup, "Core: Caller is not Genesis Group");

		hasGenesisGroupCompleted = true;

		// solhint-disable-next-line not-rely-on-time
		emit GenesisPeriodComplete(now);
	}
}


// File contracts/fei-protocol/dao/ITimelockedDelegator.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


interface ITribe is IERC20 {
	function delegate(address delegatee) external;
}

/// @title a timelock for TRIBE allowing for sub-delegation
/// @author Fei Protocol
/// @notice allows the timelocked TRIBE to be delegated by the beneficiary while locked
interface ITimelockedDelegator {

	// ----------- Events -----------

    event Delegate(address indexed _delegatee, uint _amount);

    event Undelegate(address indexed _delegatee, uint _amount);

    // ----------- Beneficiary only state changing api -----------

	/// @notice delegate locked TRIBE to a delegatee
	/// @param delegatee the target address to delegate to
	/// @param amount the amount of TRIBE to delegate. Will increment existing delegated TRIBE
    function delegate(address delegatee, uint amount) external;

	/// @notice return delegated TRIBE to the timelock
	/// @param delegatee the target address to undelegate from
	/// @return the amount of TRIBE returned
    function undelegate(address delegatee) external returns(uint);

    // ----------- Getters -----------

	/// @notice associated delegate proxy contract for a delegatee
	/// @param delegatee The delegatee
	/// @return the corresponding delegate proxy contract
    function delegateContract(address delegatee) external view returns(address);

	/// @notice associated delegated amount for a delegatee
	/// @param delegatee The delegatee
	/// @return uint amount of TRIBE delegated
    /// @dev Using as source of truth to prevent accounting errors by transferring to Delegate contracts
    function delegateAmount(address delegatee) external view returns(uint);

	/// @notice the total delegated amount of TRIBE
    function totalDelegated() external view returns(uint);

	/// @notice the TRIBE token contract
    function tribe() external view returns(ITribe);

}


// File contracts/fei-protocol/dao/Timelock.sol

pragma solidity ^0.6.0;

// Forked from Compound
// See https://github.com/compound-finance/compound-protocol/blob/master/contracts/Timelock.sol
contract Timelock {
    using SafeMath for uint;

    event NewAdmin(address indexed newAdmin);
    event NewPendingAdmin(address indexed newPendingAdmin);
    event NewDelay(uint indexed newDelay);
    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);

    uint public constant GRACE_PERIOD = 14 days;
    uint public constant MINIMUM_DELAY = 1 hours;
    uint public constant MAXIMUM_DELAY = 30 days;

    address public admin;
    address public pendingAdmin;
    uint public delay;

    mapping (bytes32 => bool) public queuedTransactions;


    constructor(address admin_, uint delay_) public {
        require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");
        require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");

        admin = admin_;
        delay = delay_;
    }

    receive() external payable { }

    function setDelay(uint delay_) public {
        require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
        require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");
        require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");
        delay = delay_;

        emit NewDelay(delay);
    }

    function acceptAdmin() public {
        require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");
        admin = msg.sender;
        pendingAdmin = address(0);

        emit NewAdmin(admin);
    }

    function setPendingAdmin(address pendingAdmin_) public {
        require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");
        pendingAdmin = pendingAdmin_;

        emit NewPendingAdmin(pendingAdmin);
    }

    function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {
        require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");
        require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");

        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        queuedTransactions[txHash] = true;

        emit QueueTransaction(txHash, target, value, signature, data, eta);
        return txHash;
    }

    function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {
        require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");

        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        queuedTransactions[txHash] = false;

        emit CancelTransaction(txHash, target, value, signature, data, eta);
    }

    function executeTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {
        require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");

        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
        require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
        require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");

        queuedTransactions[txHash] = false;

        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returnData) = target.call{value: value}(callData); //solhint-disable avoid-call-value
        require(success, "Timelock::executeTransaction: Transaction execution reverted.");

        emit ExecuteTransaction(txHash, target, value, signature, data, eta);

        return returnData;
    }

    function getBlockTimestamp() internal view returns (uint) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// File contracts/fei-protocol/utils/LinearTokenTimelock.sol

pragma solidity ^0.6.0;

// Inspired by OpenZeppelin TokenTimelock contract
// Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/TokenTimelock.sol


contract LinearTokenTimelock is Timed {

    // ERC20 basic token contract being held
    IERC20 public lockedToken;

    // beneficiary of tokens after they are released
    address public beneficiary;

    address public pendingBeneficiary;

    uint public initialBalance;

    uint internal lastBalance;

    event Release(address indexed _beneficiary, uint _amount);
    event BeneficiaryUpdate(address indexed _beneficiary);
    event PendingBeneficiaryUpdate(address indexed _pendingBeneficiary);

    constructor (address _beneficiary, uint32 _duration) public Timed(_duration) {
        require(_duration != 0, "LinearTokenTimelock: duration is 0");
        beneficiary = _beneficiary;
        _initTimed();
    }

    // Prevents incoming LP tokens from messing up calculations
    modifier balanceCheck() {
        if (totalToken() > lastBalance) {
            uint delta = totalToken() - lastBalance;
            initialBalance += delta;
        }
        _;
        lastBalance = totalToken();
    }

    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "LinearTokenTimelock: Caller is not a beneficiary");
        _;
    }

    function release() external onlyBeneficiary balanceCheck {
        uint amount = availableForRelease();
        require(amount != 0, "LinearTokenTimelock: no tokens to release");

        lockedToken.transfer(beneficiary, amount);
        emit Release(beneficiary, amount);
    }

    function totalToken() public view virtual returns(uint) {
        return lockedToken.balanceOf(address(this));
    }

    function alreadyReleasedAmount() public view returns(uint) {
        return initialBalance - totalToken();
    }

    function availableForRelease() public view returns(uint) {
        uint elapsed = timestamp();
        uint _duration = duration;

        uint totalAvailable = initialBalance * elapsed / _duration;
        uint netAvailable = totalAvailable - alreadyReleasedAmount();
        return netAvailable;
    }

    function setPendingBeneficiary(address _pendingBeneficiary) public onlyBeneficiary {
        pendingBeneficiary = _pendingBeneficiary;
        emit PendingBeneficiaryUpdate(_pendingBeneficiary);
    }

    function acceptBeneficiary() public virtual {
        _setBeneficiary(msg.sender);
    }

    function _setBeneficiary(address newBeneficiary) internal {
        require(newBeneficiary == pendingBeneficiary, "LinearTokenTimelock: Caller is not pending beneficiary");
        beneficiary = newBeneficiary;
        emit BeneficiaryUpdate(newBeneficiary);
        pendingBeneficiary = address(0);
    }

    function setLockedToken(address tokenAddress) internal {
        lockedToken = IERC20(tokenAddress);
    }
}


// File contracts/fei-protocol/dao/TimelockedDelegator.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;



/// @title a proxy delegate contract for TRIBE
/// @author Fei Protocol
contract Delegatee is Ownable {

	ITribe public tribe;

	/// @notice Delegatee constructor
	/// @param _delegatee the address to delegate TRIBE to
	/// @param _tribe the TRIBE token address
	constructor(address _delegatee, address _tribe) public {
		tribe = ITribe(_tribe);
		tribe.delegate(_delegatee);
	}

	/// @notice send TRIBE back to timelock and selfdestruct
	function withdraw() public onlyOwner {
		ITribe _tribe = tribe;
		uint balance = _tribe.balanceOf(address(this));
		_tribe.transfer(owner(), balance);
		selfdestruct(payable(owner()));
	}
}

/// @title ITimelockedDelegator implementation
/// @author Fei Protocol
contract TimelockedDelegator is ITimelockedDelegator, LinearTokenTimelock {

    mapping (address => address) public override delegateContract;

    mapping (address => uint) public override delegateAmount;

    ITribe public override tribe;

    uint public override totalDelegated;

	/// @notice Delegatee constructor
	/// @param _tribe the TRIBE token address
	/// @param _beneficiary default delegate, admin, and timelock beneficiary
	/// @param _duration duration of the token timelock window
	constructor(address _tribe, address _beneficiary, uint32 _duration) public
		LinearTokenTimelock(_beneficiary, _duration)
	{
		tribe = ITribe(_tribe);
		tribe.delegate(_beneficiary);
		setLockedToken(_tribe);
	}

	function delegate(address delegatee, uint amount) public override onlyBeneficiary {
		require(amount <= tribeBalance(), "TimelockedDelegator: Not enough Tribe");

		if (delegateContract[delegatee] != address(0)) {
			amount += undelegate(delegatee);
		}
		ITribe _tribe = tribe;
		address _delegateContract = address(new Delegatee(delegatee, address(_tribe)));
		delegateContract[delegatee] = _delegateContract;

		delegateAmount[delegatee] = amount;
		totalDelegated += amount;

		_tribe.transfer(_delegateContract, amount);

		emit Delegate(delegatee, amount);
	}

	function undelegate(address delegatee) public override onlyBeneficiary returns(uint) {
		address _delegateContract = delegateContract[delegatee];
		require(_delegateContract != address(0), "TimelockedDelegator: Delegate contract nonexistent");

		Delegatee(_delegateContract).withdraw();

		uint amount = delegateAmount[delegatee];
		totalDelegated -= amount;

		delegateContract[delegatee] = address(0);
		delegateAmount[delegatee] = 0;

		emit Undelegate(delegatee, amount);

		return amount;
	}

	/// @notice calculate total TRIBE held plus delegated
	/// @dev used by LinearTokenTimelock to determine the released amount
	function totalToken() public view override returns(uint256) {
        return tribeBalance() + totalDelegated;
    }

	/// @notice accept beneficiary role over timelocked TRIBE. Delegates all held (non-subdelegated) tribe to beneficiary
	function acceptBeneficiary() public override {
        _setBeneficiary(msg.sender);
        tribe.delegate(msg.sender);
    }

    function tribeBalance() internal view returns (uint256) {
    	return tribe.balanceOf(address(this));
    }
}


// File contracts/fei-protocol/genesis/IGenesisGroup.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title Equal access to the first bonding curve transaction
/// @author Fei Protocol
interface IGenesisGroup {
	// ----------- Events -----------

	event Purchase(address indexed _to, uint _value);

	event Redeem(address indexed _to, uint _amountIn, uint _amountFei, uint _amountTribe);

    event Commit(address indexed _from, address indexed _to, uint _amount);

	event Launch(uint _timestamp);

    // ----------- State changing API -----------

    /// @notice allows for entry into the Genesis Group via ETH. Only callable during Genesis Period.
    /// @param to address to send FGEN Genesis tokens to
    /// @param value amount of ETH to deposit
    function purchase(address to, uint value) external payable;

    /// @notice redeem FGEN genesis tokens for FEI and TRIBE. Only callable post launch
    /// @param to address to send redeemed FEI and TRIBE to.
    function redeem(address to) external;

    /// @notice commit Genesis FEI to purchase TRIBE in DEX offering
    /// @param from address to source FGEN Genesis shares from
    /// @param to address to earn TRIBE and redeem post launch
    /// @param amount of FGEN Genesis shares to commit
    function commit(address from, address to, uint amount) external;

    /// @notice launch Fei Protocol. Callable once Genesis Period has ended or the max price has been reached
    function launch() external;


    // ----------- Getters -----------

    /// @notice calculate amount of FEI and TRIBE received if the Genesis Group ended now.
    /// @param amountIn amount of FGEN held or equivalently amount of ETH purchasing with
    /// @param inclusive if true, assumes the `amountIn` is part of the existing FGEN supply. Set to false to simulate a new purchase.
    /// @return feiAmount the amount of FEI received by the user
    /// @return tribeAmount the amount of TRIBE received by the user
    function getAmountOut(uint amountIn, bool inclusive) external view returns (uint feiAmount, uint tribeAmount);

    /// @notice check whether GenesisGroup has reached max FEI price. Sufficient condition for launch
    function isAtMaxPrice() external view returns(bool);
}


// File contracts/fei-protocol/genesis/IDOInterface.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/// @title an initial DeFi offering for the TRIBE token
/// @author Fei Protocol
interface IDOInterface {

	// ----------- Events -----------

	event Deploy(uint _amountFei, uint _amountTribe);

	// ----------- Genesis Group only state changing API -----------

    /// @notice deploys all held TRIBE on Uniswap at the given ratio
    /// @param feiRatio the exchange rate for FEI/TRIBE
    /// @dev the contract will mint any FEI necessary to do the listing. Assumes no existing LP
	function deploy(Decimal.D256 calldata feiRatio) external;

	/// @notice swaps Genesis Group FEI on Uniswap For TRIBE
	/// @param amountFei the amount of FEI to swap
	/// @return uint amount of TRIBE sent to Genesis Group
	function swapFei(uint amountFei) external returns(uint);
}


// File contracts/fei-protocol/pool/IPool.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/// @title A fluid pool for earning a reward token with staked tokens
/// @author Fei Protocol
interface IPool {

	// ----------- Events -----------

    event Claim(address indexed _from, address indexed _to, uint _amountReward);

    event Deposit(address indexed _from, address indexed _to, uint _amountStaked);

    event Withdraw(address indexed _from, address indexed _to, uint _amountStaked, uint _amountReward);

    // ----------- State changing API -----------

    /// @notice collect redeemable rewards without unstaking
    /// @param from the account to claim for
    /// @param to the account to send rewards to
    /// @return the amount of reward claimed
    /// @dev redeeming on behalf of another account requires ERC-20 approval of the pool tokens
    function claim(address from, address to) external returns(uint);
    
    /// @notice deposit staked tokens
    /// @param to the account to deposit to
    /// @param amount the amount of staked to deposit
    /// @dev requires ERC-20 approval of stakedToken for the Pool contract
    function deposit(address to, uint amount) external;

    /// @notice claim all rewards and withdraw stakedToken
    /// @param to the account to send withdrawn tokens to
    /// @return amountStaked the amount of stakedToken withdrawn
    /// @return amountReward the amount of rewardToken received
    function withdraw(address to) external returns(uint amountStaked, uint amountReward);
    
    /// @notice initializes the pool start time. Only callable once
    function init() external;

    // ----------- Getters -----------

    /// @notice the ERC20 reward token
    /// @return the IERC20 implementation address
    function rewardToken() external view returns(IERC20);

    /// @notice the total amount of rewards distributed by the contract over entire period
    /// @return the total, including currently held and previously claimed rewards
    function totalReward() external view returns (uint);
    
    /// @notice the amount of rewards currently redeemable by an account
    /// @param account the potentially redeeming account
    /// @return amountReward the amount of reward tokens
    /// @return amountPool the amount of redeemable pool tokens
    function redeemableReward(address account) external view returns(uint amountReward, uint amountPool);
 
    /// @notice the total amount of rewards owned by contract and unlocked for release
    /// @return the total
    function releasedReward() external view returns (uint);
    
    /// @notice the total amount of rewards owned by contract and locked
    /// @return the total
    function unreleasedReward() external view returns (uint);

    /// @notice the total balance of rewards owned by contract, locked or unlocked
    /// @return the total
    function rewardBalance() external view returns (uint);

    /// @notice the total amount of rewards previously claimed
    /// @return the total
    function claimedRewards() external view returns(uint128);

    /// @notice the ERC20 staked token
    /// @return the IERC20 implementation address
    function stakedToken() external view returns(IERC20);

    /// @notice the total amount of staked tokens in the contract
    /// @return the total
    function totalStaked() external view returns(uint128);

    /// @notice the staked balance of a given account
    /// @param account the user account
    /// @return the total staked
    function stakedBalance(address account) external view returns(uint);    
}


// File contracts/fei-protocol/oracle/IBondingCurveOracle.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title bonding curve oracle interface for Fei Protocol
/// @author Fei Protocol
/// @notice peg is to be the current bonding curve price if pre-Scale
interface IBondingCurveOracle is IOracle {
    // ----------- Genesis Group only state changing API -----------

    /// @notice initializes the oracle with an initial peg price
    /// @param initialPeg a peg denominated in Dollars per X
    /// @dev divides the initial peg by the uniswap oracle price to get initialPrice. And kicks off thawing period
    function init(Decimal.D256 calldata initialPeg) external;

    // ----------- Getters -----------

    /// @notice the referenced uniswap oracle price
    function uniswapOracle() external returns(IOracle);

    /// @notice the referenced bonding curve
    function bondingCurve() external returns(IBondingCurve);
}


// File contracts/fei-protocol/genesis/GenesisGroup.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;









/// @title IGenesisGroup implementation
/// @author Fei Protocol
contract GenesisGroup is IGenesisGroup, CoreRef, ERC20, ERC20Burnable, Timed {
	using Decimal for Decimal.D256;

	IBondingCurve private bondingcurve;

	IBondingCurveOracle private bondingCurveOracle;

	IPool private pool;

	IDOInterface private ido;
	uint private exchangeRateDiscount;

	mapping(address => uint) public committedFGEN;
	uint public totalCommittedFGEN;

	uint public totalCommittedTribe;

	/// @notice a cap on the genesis group purchase price
	Decimal.D256 public maxGenesisPrice;

	/// @notice GenesisGroup constructor
	/// @param _core Fei Core address to reference
	/// @param _bondingcurve Bonding curve address for purchase
	/// @param _ido IDO contract to deploy
	/// @param _oracle Bonding curve oracle
	/// @param _pool Staking Pool
	/// @param _duration duration of the Genesis Period
	/// @param _maxPriceBPs max price of FEI allowed in Genesis Group in dollar terms
	/// @param _exchangeRateDiscount a divisor on the FEI/TRIBE ratio at Genesis to deploy to the IDO
	constructor(
		address _core, 
		address _bondingcurve,
		address _ido,
		address _oracle,
		address _pool,
		uint32 _duration,
		uint _maxPriceBPs,
		uint _exchangeRateDiscount
	) public
		CoreRef(_core)
		ERC20("Fei Genesis Group", "FGEN")
		Timed(_duration)
	{
		bondingcurve = IBondingCurve(_bondingcurve);

		exchangeRateDiscount = _exchangeRateDiscount;
		ido = IDOInterface(_ido);
		fei().approve(_ido, uint(-1));

		pool = IPool(_pool);
		bondingCurveOracle = IBondingCurveOracle(_oracle);

		_initTimed();

		maxGenesisPrice = Decimal.ratio(_maxPriceBPs, 10000);
	}

	modifier onlyGenesisPeriod() {
		require(!isTimeEnded(), "GenesisGroup: Not in Genesis Period");
		_;
	}

	function purchase(address to, uint value) external override payable onlyGenesisPeriod {
		require(msg.value == value, "GenesisGroup: value mismatch");
		require(value != 0, "GenesisGroup: no value sent");

		_mint(to, value);

		emit Purchase(to, value);
	}

	function commit(address from, address to, uint amount) external override onlyGenesisPeriod {
		burnFrom(from, amount);

		committedFGEN[to] = amount;
		totalCommittedFGEN += amount;

		emit Commit(from, to, amount);
	}

	function redeem(address to) external override {
		(uint feiAmount, uint genesisTribe, uint idoTribe) = getAmountsToRedeem(to); 

		uint tribeAmount = genesisTribe + idoTribe;

		require(tribeAmount != 0, "GenesisGroup: No redeemable TRIBE");

		uint amountIn = balanceOf(to);
		burnFrom(to, amountIn);

		uint committed = committedFGEN[to];
		committedFGEN[to] = 0;
		totalCommittedFGEN -= committed;

		totalCommittedTribe -= idoTribe;


		if (feiAmount != 0) {
			fei().transfer(to, feiAmount);
		}
		
		tribe().transfer(to, tribeAmount);

		emit Redeem(to, amountIn, feiAmount, tribeAmount);
	}

	function getAmountsToRedeem(address to) public view postGenesis returns (uint feiAmount, uint genesisTribe, uint idoTribe) {
		
		uint userFGEN = balanceOf(to);
		uint userCommittedFGEN = committedFGEN[to];

		uint circulatingFGEN = totalSupply();
		uint totalFGEN = circulatingFGEN + totalCommittedFGEN;

		// subtract purchased TRIBE amount
		uint totalGenesisTribe = tribeBalance() - totalCommittedTribe;

		if (circulatingFGEN != 0) {
			feiAmount = feiBalance() * userFGEN / circulatingFGEN;
		}

		if (totalFGEN != 0) {
			genesisTribe = totalGenesisTribe * (userFGEN + userCommittedFGEN) / totalFGEN;
		}

		if (totalCommittedFGEN != 0) {
			idoTribe = totalCommittedTribe * userCommittedFGEN / totalCommittedFGEN;
		}

		return (feiAmount, genesisTribe, idoTribe);
	}

	function launch() external override {
		require(isTimeEnded() || isAtMaxPrice(), "GenesisGroup: Still in Genesis Period");

		core().completeGenesisGroup();

		address genesisGroup = address(this);
		uint balance = genesisGroup.balance;

		bondingCurveOracle.init(bondingcurve.getAveragePrice(balance));

		bondingcurve.purchase{value: balance}(genesisGroup, balance);
		bondingcurve.allocate();

		pool.init();

		ido.deploy(_feiTribeExchangeRate());

		uint amountFei = feiBalance() * totalCommittedFGEN / (totalSupply() + totalCommittedFGEN);
		if (amountFei != 0) {
			totalCommittedTribe = ido.swapFei(amountFei);
		}

		// solhint-disable-next-line not-rely-on-time
		emit Launch(now);
	}

	// Add a backdoor out of Genesis in case of brick
	function emergencyExit(address from, address to) external {
		require(now > (startTime + duration + 3 days), "GenesisGroup: Not in exit window");

		uint amountFGEN = balanceOf(from);
		uint total = amountFGEN + committedFGEN[from];

		require(total != 0, "GenesisGroup: No FGEN or committed balance");
		require(address(this).balance >= total, "GenesisGroup: Not enough ETH to redeem");
		require(msg.sender == from || allowance(from, msg.sender) >= total, "GenesisGroup: Not approved for emergency withdrawal");

		burnFrom(from, amountFGEN);
		committedFGEN[from] = 0;

		payable(to).transfer(total);
	}

	function getAmountOut(
		uint amountIn, 
		bool inclusive
	) public view override returns (uint feiAmount, uint tribeAmount) {
		uint totalIn = totalSupply();
		if (!inclusive) {
			totalIn += amountIn;
		}
		require(amountIn <= totalIn, "GenesisGroup: Not enough supply");

		uint totalFei = bondingcurve.getAmountOut(totalIn);
		uint totalTribe = tribeBalance();

		return (totalFei * amountIn / totalIn, totalTribe * amountIn / totalIn);
	}

	function isAtMaxPrice() public view override returns(bool) {
		uint balance = address(this).balance;
		require(balance != 0, "GenesisGroup: No balance");

		return bondingcurve.getAveragePrice(balance).greaterThanOrEqualTo(maxGenesisPrice);
	}

	function burnFrom(address account, uint amount) public override {
		// Sender doesn't need approval
		if (msg.sender == account) {
			increaseAllowance(account, amount);
		}
		super.burnFrom(account, amount);
	}

	function _feiTribeExchangeRate() public view returns (Decimal.D256 memory) {
		return Decimal.ratio(feiBalance(), tribeBalance()).div(exchangeRateDiscount);
	}
}


// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


// File @uniswap/v2-periphery/contracts/libraries/SafeMath.sol@v1.1.0-beta.0

pragma solidity =0.6.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}


// File @uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol@v1.1.0-beta.0

pragma solidity >=0.5.0;

library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0

pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


// File contracts/fei-protocol/refs/IUniRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;




/// @title A Uniswap Reference contract
/// @author Fei Protocol
/// @notice defines some modifiers and utilities around interacting with Uniswap
/// @dev the uniswap pair should be FEI and another asset
interface IUniRef {

	// ----------- Events -----------

    event PairUpdate(address indexed _pair);

    // ----------- Governor only state changing api -----------

    /// @notice set the new pair contract
    /// @param _pair the new pair
    /// @dev also approves the router for the new pair token and underlying token
    function setPair(address _pair) external;

    // ----------- Getters -----------

    /// @notice the Uniswap router contract
    /// @return the IUniswapV2Router02 router implementation address
    function router() external view returns(IUniswapV2Router02);

    /// @notice the referenced Uniswap pair contract
    /// @return the IUniswapV2Pair router implementation address
    function pair() external view returns(IUniswapV2Pair);

    /// @notice the address of the non-fei underlying token
    /// @return the token address
    function token() external view returns(address);

    /// @notice pair reserves with fei listed first
    /// @dev uses the max of pair fei balance and fei reserves. Mitigates attack vectors which manipulate the pair balance
    function getReserves() external view returns (uint feiReserves, uint tokenReserves);

    /// @notice amount of pair liquidity owned by this contract
    /// @return amount of LP tokens
	function liquidityOwned() external view returns (uint);
}


// File contracts/fei-protocol/refs/UniRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;



/// @title UniRef abstract implementation contract
/// @author Fei Protocol
abstract contract UniRef is IUniRef, OracleRef {
	using Decimal for Decimal.D256;
	using Babylonian for uint;

	IUniswapV2Router02 public override router;
	IUniswapV2Pair public override pair;

	/// @notice UniRef constructor
	/// @param _core Fei Core to reference
    /// @param _pair Uniswap pair to reference
    /// @param _router Uniswap Router to reference
    /// @param _oracle oracle to reference
	constructor(address _core, address _pair, address _router, address _oracle) 
        public OracleRef(_core, _oracle) 
    {
        setupPair(_pair);

        router = IUniswapV2Router02(_router);

        approveToken(address(fei()));
        approveToken(token());
        approveToken(_pair);
    }

	function setPair(address _pair) external override onlyGovernor {
		setupPair(_pair);

        approveToken(token());
        approveToken(_pair);
	}

	function token() public override view returns (address) {
		address token0 = pair.token0();
		if (address(fei()) == token0) {
			return pair.token1();
		}
		return token0;
	}

	function getReserves() public override view returns (uint feiReserves, uint tokenReserves) {
        address token0 = pair.token0();
        (uint reserve0, uint reserve1,) = pair.getReserves();
        (feiReserves, tokenReserves) = address(fei()) == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        
        uint feiBalance = fei().balanceOf(address(pair));
        if(feiBalance > feiReserves) {
            feiReserves = feiBalance;
        }
        return (feiReserves, tokenReserves);
	}

	function liquidityOwned() public override view returns (uint) {
		return pair.balanceOf(address(this));
	}

    /// @notice ratio of all pair liquidity owned by this contract
	function ratioOwned() internal view returns (Decimal.D256 memory) {	
    	uint balance = liquidityOwned();
    	uint total = pair.totalSupply();
    	return Decimal.ratio(balance, total);
    }

    /// @notice returns true if price is below the peg
    /// @dev counterintuitively checks if peg < price because price is reported as FEI per X
    function isBelowPeg(Decimal.D256 memory peg) internal view returns (bool) {
        (Decimal.D256 memory price,,) = getUniswapPrice();
        return peg.lessThan(price);
    }

    /// @notice approves a token for the router
    function approveToken(address _token) internal {
    	IERC20(_token).approve(address(router), uint(-1));
    }

    function setupPair(address _pair) internal {
    	pair = IUniswapV2Pair(_pair);
        emit PairUpdate(_pair);
    }

    function isPair(address account) internal view returns(bool) {
        return address(pair) == account;
    }

    /// @notice utility for calculating absolute distance from peg based on reserves
    /// @param reserveTarget pair reserves of the asset desired to trade with
    /// @param reserveOther pair reserves of the non-traded asset
    /// @param peg the target peg reported as Target per Other 
    function getAmountToPeg(
        uint reserveTarget, 
        uint reserveOther, 
        Decimal.D256 memory peg
    ) internal pure returns (uint) {
        uint radicand = peg.mul(reserveTarget).mul(reserveOther).asUint256();
        uint root = radicand.sqrt();
        if (root > reserveTarget) {
            return root - reserveTarget;
        }
        return reserveTarget - root;
    }

    /// @notice calculate amount of Fei needed to trade back to the peg
    function getAmountToPegFei() internal view returns (uint) {
        (uint feiReserves, uint tokenReserves) = getReserves();
        return getAmountToPeg(feiReserves, tokenReserves, peg());
    }

    /// @notice calculate amount of the not Fei token needed to trade back to the peg
    function getAmountToPegOther() internal view returns (uint) {
        (uint feiReserves, uint tokenReserves) = getReserves();
        return getAmountToPeg(tokenReserves, feiReserves, invert(peg()));
    }

    /// @notice get uniswap price and reserves
    /// @return price reported as Fei per X
    /// @return reserveFei fei reserves
    /// @return reserveOther non-fei reserves
    function getUniswapPrice() internal view returns(
        Decimal.D256 memory, 
        uint reserveFei, 
        uint reserveOther
    ) {
        (reserveFei, reserveOther) = getReserves();
        return (Decimal.ratio(reserveFei, reserveOther), reserveFei, reserveOther);
    }

    /// @notice get final uniswap price after hypothetical FEI trade
    /// @param amountFei a signed integer representing FEI trade. Positive=sell, negative=buy
    /// @param reserveFei fei reserves
    /// @param reserveOther non-fei reserves
    function getFinalPrice(
    	int256 amountFei, 
    	uint reserveFei, 
    	uint reserveOther
    ) internal pure returns (Decimal.D256 memory) {
    	uint k = reserveFei * reserveOther;
    	uint adjustedReserveFei = uint(int256(reserveFei) + amountFei);
    	uint adjustedReserveOther = k / adjustedReserveFei;
    	return Decimal.ratio(adjustedReserveFei, adjustedReserveOther); // alt: adjustedReserveFei^2 / k
    }

    /// @notice return the percent distance from peg before and after a hypothetical trade
    /// @param amountIn a signed amount of FEI to be traded. Positive=sell, negative=buy 
    /// @return initialDeviation the percent distance from peg before trade
    /// @return finalDeviation the percent distance from peg after hypothetical trade
    /// @dev deviations will return Decimal.zero() if above peg
    function getPriceDeviations(int256 amountIn) internal view returns (
        Decimal.D256 memory initialDeviation, 
        Decimal.D256 memory finalDeviation
    ) {
        (Decimal.D256 memory price, uint reserveFei, uint reserveOther) = getUniswapPrice();
        initialDeviation = calculateDeviation(price, peg());

        Decimal.D256 memory finalPrice = getFinalPrice(amountIn, reserveFei, reserveOther);
        finalDeviation = calculateDeviation(finalPrice, peg());
        
        return (initialDeviation, finalDeviation);
    }

    /// @notice return current percent distance from peg
    /// @dev will return Decimal.zero() if above peg
    function getDistanceToPeg() internal view returns(Decimal.D256 memory distance) {
        (Decimal.D256 memory price, , ) = getUniswapPrice();
        return calculateDeviation(price, peg()); 
    }

    /// @notice get deviation from peg as a percent given price
    /// @dev will return Decimal.zero() if above peg
    function calculateDeviation(
        Decimal.D256 memory price, 
        Decimal.D256 memory peg
    ) internal pure returns (Decimal.D256 memory) {
        // If price <= peg, then FEI is more expensive and above peg
        // In this case we can just return zero for deviation
        if (price.lessThanOrEqualTo(peg)) {
            return Decimal.zero();
        }
        Decimal.D256 memory delta = price.sub(peg, "UniRef: price exceeds peg"); // Should never error
        return delta.div(peg);
    }
}


// File contracts/fei-protocol/genesis/IDO.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;




/// @title IDOInterface implementation
/// @author Fei Protocol
contract IDO is IDOInterface, UniRef, LinearTokenTimelock {

	/// @notice IDO constructor
	/// @param _core Fei Core address to reference
	/// @param _beneficiary the beneficiary to vest LP shares
	/// @param _duration the duration of LP share vesting
	/// @param _pair the Uniswap pair contract of the IDO
	/// @param _router the Uniswap router contract
	constructor(
		address _core, 
		address _beneficiary, 
		uint32 _duration, 
		address _pair, 
		address _router
	) public
		UniRef(_core, _pair, _router, address(0)) // no oracle needed
		LinearTokenTimelock(_beneficiary, _duration)
	{
		setLockedToken(_pair);
	}

	function deploy(Decimal.D256 calldata feiRatio) external override onlyGenesisGroup {
		uint tribeAmount = tribeBalance();

		uint feiAmount = feiRatio.mul(tribeAmount).asUint256();
		_mintFei(feiAmount);

		router.addLiquidity(
	        address(tribe()),
	        address(fei()),
	        tribeAmount,
	        feiAmount,
	        tribeAmount,
	        feiAmount,
	        address(this),
	        uint(-1)
	    );

	    emit Deploy(feiAmount, tribeAmount);
	} 

	function swapFei(uint amountFei) external override onlyGenesisGroup returns(uint) {

		(uint feiReserves, uint tribeReserves) = getReserves();

		uint amountOut = UniswapV2Library.getAmountOut(amountFei, feiReserves, tribeReserves);

		fei().transferFrom(msg.sender, address(pair), amountFei);

		(uint amount0Out, uint amount1Out) = pair.token0() == address(fei()) ? (uint(0), amountOut) : (amountOut, uint(0));
		pair.swap(amount0Out, amount1Out, msg.sender, new bytes(0));

		return amountOut;
	}
}


// File contracts/fei-protocol/mock/IMockUniswapV2PairLiquidity.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


interface IMockUniswapV2PairLiquidity is IUniswapV2Pair {
	function burnEth(address to, Decimal.D256 calldata ratio) external returns(uint256 amountEth, uint256 amount1);
	function mintAmount(address to, uint256 _liquidity) external payable; 
	function setReserves(uint112 newReserve0, uint112 newReserve1) external;
}


// File contracts/fei-protocol/mock/MockBondingCurve.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract MockBondingCurve {

	bool public atScale;
	bool public allocated;
	Decimal.D256 public getCurrentPrice;

	constructor(bool _atScale, uint256 price) public {
		setScale(_atScale);
		setCurrentPrice(price);
	}

	function setScale(bool _atScale) public {
		atScale = _atScale;
	}

	function setCurrentPrice(uint256 price) public {
		getCurrentPrice = Decimal.ratio(price, 100);
	}

	function allocate() public payable {
		allocated = true;
	}

	function purchase(address to, uint amount) public payable returns (uint256 amountOut) {
		return 1;
	}

	function getAmountOut(uint amount) public view returns(uint) {
		return 10 * amount;
	}

	function getAveragePrice(uint256 amountIn) public view returns (Decimal.D256 memory) {
		return getCurrentPrice;
	}
}


// File contracts/fei-protocol/mock/MockCoreRef.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract MockCoreRef is CoreRef {
	constructor(address core) 
		CoreRef(core)
	public {}

	function testMinter() public view onlyMinter {}

	function testBurner() public view onlyBurner {}

	function testPCVController() public view onlyPCVController {}

	function testGovernor() public view onlyGovernor {}

	function testPostGenesis() public view postGenesis {}
}


// File contracts/fei-protocol/mock/MockERC20.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract MockERC20 is ERC20, ERC20Burnable {
    constructor()
        ERC20("MockToken", "MCT")
    public {}

    function mint(address account, uint256 amount) public returns (bool) {
        _mint(account, amount);
        return true;
    }
}


// File contracts/fei-protocol/mock/MockEthPCVDeposit.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract MockEthPCVDeposit is IPCVDeposit {

	address payable beneficiary;
    uint256 total = 0;

	constructor(address payable _beneficiary) public {
		beneficiary = _beneficiary;
	}

    function deposit(uint256 amount) external override payable {
    	require(amount == msg.value, "MockEthPCVDeposit: Sent value does not equal input");
    	beneficiary.transfer(amount);
        total += amount;
    }

    function withdraw(address to, uint256 amount) external override {
        require(address(this).balance >= amount, "MockEthPCVDeposit: Not enough value held");
        total -= amount;
        payable(to).transfer(amount);
    }

    function totalValue() external view override returns(uint256) {
    	return total;
    }

}


// File contracts/fei-protocol/mock/MockEthUniswapPCVDeposit.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract MockEthUniswapPCVDeposit is MockEthPCVDeposit {

    address public pair;

	constructor(address _pair) 
        MockEthPCVDeposit(payable(this))
    public {
        pair = _pair;
    }

    fallback() external payable {

    }
}


// File contracts/fei-protocol/mock/MockIDO.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract MockIDO {

	Decimal.D256 public ratio = Decimal.zero();
	IERC20 public tribe;
	uint multiplier;


	constructor(address _tribe, uint _multiplier) public {
		tribe = IERC20(_tribe);
		multiplier = _multiplier;
	}

	function deploy(Decimal.D256 memory feiRatio) public {
		ratio = feiRatio;
	}

	function swapFei(uint amount) public returns (uint amountOut) {
		amountOut = amount * multiplier;

		tribe.transfer(msg.sender, amountOut);
		
		return amountOut;
	}
}


// File contracts/fei-protocol/mock/MockIncentive.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract MockIncentive is IIncentive, CoreRef {

	constructor(address core) 
		CoreRef(core)
	public {}

    uint256 constant private INCENTIVE = 100;

    function incentivize(
    	address sender, 
    	address receiver, 
    	address spender, 
    	uint256 amountIn
    ) public override {
        fei().mint(sender, INCENTIVE);
    }
}


// File contracts/fei-protocol/mock/MockOracle.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract MockOracle is IOracle {
    using Decimal for Decimal.D256;

    // fixed exchange ratio
    uint256 _usdPerEth;
	bool public override killSwitch;
    bool public updated;
    bool public valid = true;

    constructor(uint256 usdPerEth) public {
        _usdPerEth = usdPerEth;
    }

    function update() public override returns (bool) {
        updated = true;
        return true;
    }

    function read() public view override returns (Decimal.D256 memory, bool) {
        Decimal.D256 memory price = Decimal.from(_usdPerEth); 
        return (price, valid);
    }

    function setValid(bool isValid) public {
        valid = isValid;
    }

    function setExchangeRate(uint256 usdPerEth) public {
        _usdPerEth = usdPerEth;
    }

	function setKillSwitch(bool _killSwitch) public override {
		killSwitch = _killSwitch;
	}
}


// File contracts/fei-protocol/mock/MockOrchestrator.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract MockBCO {
	Decimal.D256 public initPrice;

	function init(Decimal.D256 memory price) public {
		initPrice = price;
	}
}

contract MockPool {
	function init() public {}
}

contract MockOrchestrator {
	address public bondingCurveOracle;
	address public pool;

	constructor() public {
		bondingCurveOracle = address(new MockBCO());

		pool = address(new MockPool());
	}

    function launchGovernance() external {}
}


// File contracts/fei-protocol/mock/MockRouter.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;




contract MockRouter {
    using SafeMath for uint256;
    using Decimal for Decimal.D256;

    IMockUniswapV2PairLiquidity private PAIR;
    address public WETH;

    constructor(address pair) public {
        PAIR = IMockUniswapV2PairLiquidity(pair);
    }

    uint256 private totalLiquidity;
    uint256 private constant LIQUIDITY_INCREMENT = 10000;

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity) {
        address pair = address(PAIR);
        amountToken = amountTokenDesired;
        amountETH = msg.value;
        liquidity = LIQUIDITY_INCREMENT;
        (uint112 reserves0, uint112 reserves1, ) = PAIR.getReserves();
        IERC20(token).transferFrom(to, pair, amountToken);
        PAIR.mintAmount{value: amountETH}(to, LIQUIDITY_INCREMENT);
        totalLiquidity += LIQUIDITY_INCREMENT;
        uint112 newReserve0 = uint112(reserves0) + uint112(amountETH);
        uint112 newReserve1 = uint112(reserves1) + uint112(amountToken);
        PAIR.setReserves(newReserve0, newReserve1);
    }

    function addLiquidity(
        address token0,
        address token1,
        uint amountToken0Desired,
        uint amountToken1Desired,
        uint amountToken0Min,
        uint amountToken1Min,
        address to,
        uint deadline
    ) external returns (uint amountToken0, uint amountToken1, uint liquidity) {
        address pair = address(PAIR);

        liquidity = LIQUIDITY_INCREMENT;

        IERC20(token0).transferFrom(to, pair, amountToken0Desired);
        IERC20(token1).transferFrom(to, pair, amountToken1Desired);

        PAIR.mintAmount(to, LIQUIDITY_INCREMENT);
    }

    function setWETH(address weth) public {
        WETH = weth;
    }

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH) {

        Decimal.D256 memory percentWithdrawal = Decimal.ratio(liquidity, totalLiquidity);
        Decimal.D256 memory ratio = ratioOwned(to);
        (amountETH, amountToken) = PAIR.burnEth(to, ratio.mul(percentWithdrawal));

        (uint112 reserves0, uint112 reserves1, ) = PAIR.getReserves();
        uint112 newReserve0 = uint112(reserves0) - uint112(amountETH);
        uint112 newReserve1 = uint112(reserves1) - uint112(amountToken);

        PAIR.setReserves(newReserve0, newReserve1);
        transferLiquidity(liquidity);
    }

    function transferLiquidity(uint liquidity) internal {
        PAIR.transferFrom(msg.sender, address(PAIR), liquidity); // send liquidity to pair

    }

    function ratioOwned(address to) public view returns (Decimal.D256 memory) {   
        uint256 balance = PAIR.balanceOf(to);
        uint256 total = PAIR.totalSupply();
        return Decimal.ratio(balance, total);
    }
}


// File contracts/fei-protocol/mock/MockSettableCore.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract MockSettableCore is Core {

	// anyone can set any role
	function isGovernor(address _address) public view override returns (bool) {
		return true;
	}
}


// File contracts/fei-protocol/mock/MockTribe.sol

pragma solidity ^0.6.0;

contract MockTribe is MockERC20 {
    function delegate(address account) external {}
}


// File contracts/fei-protocol/mock/MockUniswapIncentive.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract MockUniswapIncentive is MockIncentive {

	constructor(address core) 
		MockIncentive(core)
	public {}

    bool isParity = false;
    bool isExempt = false;

    function isIncentiveParity() external view returns (bool) {
        return isParity;
    }

    function setIncentiveParity(bool _isParity) public {
        isParity = _isParity;
    }

    function isExemptAddress(address account) public returns (bool) {
        return isExempt;
    }

    function setExempt(bool exempt) public {
        isExempt = exempt;
    }

    function updateOracle() external returns(bool) {
        return true;
    }

    function setExemptAddress(address account, bool isExempt) external {}

    function getBuyIncentive(uint amount) external returns(uint,        
        uint32 weight,
        Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation
    ) {
        return (amount * 10 / 100, weight, initialDeviation, finalDeviation);
    }

    function getSellPenalty(uint amount) external returns(uint,    
        Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation) 
    {
        return (amount * 10 / 100, initialDeviation, finalDeviation);
    }
}


// File @uniswap/lib/contracts/libraries/FullMath.sol@v4.0.1-alpha

// SPDX-License-Identifier: CC-BY-4.0
pragma solidity >=0.4.0;

// taken from https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
// license is CC-BY-4.0
library FullMath {
    function fullMul(uint256 x, uint256 y) internal pure returns (uint256 l, uint256 h) {
        uint256 mm = mulmod(x, y, uint256(-1));
        l = x * y;
        h = mm - l;
        if (mm < l) h -= 1;
    }

    function fullDiv(
        uint256 l,
        uint256 h,
        uint256 d
    ) private pure returns (uint256) {
        uint256 pow2 = d & -d;
        d /= pow2;
        l /= pow2;
        l += h * ((-pow2) / pow2 + 1);
        uint256 r = 1;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        r *= 2 - d * r;
        return l * r;
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 d
    ) internal pure returns (uint256) {
        (uint256 l, uint256 h) = fullMul(x, y);

        uint256 mm = mulmod(x, y, d);
        if (mm > l) h -= 1;
        l -= mm;

        if (h == 0) return l / d;

        require(h < d, 'FullMath: FULLDIV_OVERFLOW');
        return fullDiv(l, h, d);
    }
}


// File @uniswap/lib/contracts/libraries/BitMath.sol@v4.0.1-alpha

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.5.0;

library BitMath {
    // returns the 0 indexed position of the most significant bit of the input x
    // s.t. x >= 2**msb and x < 2**(msb+1)
    function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
        require(x > 0, 'BitMath::mostSignificantBit: zero');

        if (x >= 0x100000000000000000000000000000000) {
            x >>= 128;
            r += 128;
        }
        if (x >= 0x10000000000000000) {
            x >>= 64;
            r += 64;
        }
        if (x >= 0x100000000) {
            x >>= 32;
            r += 32;
        }
        if (x >= 0x10000) {
            x >>= 16;
            r += 16;
        }
        if (x >= 0x100) {
            x >>= 8;
            r += 8;
        }
        if (x >= 0x10) {
            x >>= 4;
            r += 4;
        }
        if (x >= 0x4) {
            x >>= 2;
            r += 2;
        }
        if (x >= 0x2) r += 1;
    }

    // returns the 0 indexed position of the least significant bit of the input x
    // s.t. (x & 2**lsb) != 0 and (x & (2**(lsb) - 1)) == 0)
    // i.e. the bit at the index is set and the mask of all lower bits is 0
    function leastSignificantBit(uint256 x) internal pure returns (uint8 r) {
        require(x > 0, 'BitMath::leastSignificantBit: zero');

        r = 255;
        if (x & uint128(-1) > 0) {
            r -= 128;
        } else {
            x >>= 128;
        }
        if (x & uint64(-1) > 0) {
            r -= 64;
        } else {
            x >>= 64;
        }
        if (x & uint32(-1) > 0) {
            r -= 32;
        } else {
            x >>= 32;
        }
        if (x & uint16(-1) > 0) {
            r -= 16;
        } else {
            x >>= 16;
        }
        if (x & uint8(-1) > 0) {
            r -= 8;
        } else {
            x >>= 8;
        }
        if (x & 0xf > 0) {
            r -= 4;
        } else {
            x >>= 4;
        }
        if (x & 0x3 > 0) {
            r -= 2;
        } else {
            x >>= 2;
        }
        if (x & 0x1 > 0) r -= 1;
    }
}


// File @uniswap/lib/contracts/libraries/FixedPoint.sol@v4.0.1-alpha

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.0;



// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
library FixedPoint {
    // range: [0, 2**112 - 1]
    // resolution: 1 / 2**112
    struct uq112x112 {
        uint224 _x;
    }

    // range: [0, 2**144 - 1]
    // resolution: 1 / 2**112
    struct uq144x112 {
        uint256 _x;
    }

    uint8 public constant RESOLUTION = 112;
    uint256 public constant Q112 = 0x10000000000000000000000000000; // 2**112
    uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000; // 2**224
    uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)

    // encode a uint112 as a UQ112x112
    function encode(uint112 x) internal pure returns (uq112x112 memory) {
        return uq112x112(uint224(x) << RESOLUTION);
    }

    // encodes a uint144 as a UQ144x112
    function encode144(uint144 x) internal pure returns (uq144x112 memory) {
        return uq144x112(uint256(x) << RESOLUTION);
    }

    // decode a UQ112x112 into a uint112 by truncating after the radix point
    function decode(uq112x112 memory self) internal pure returns (uint112) {
        return uint112(self._x >> RESOLUTION);
    }

    // decode a UQ144x112 into a uint144 by truncating after the radix point
    function decode144(uq144x112 memory self) internal pure returns (uint144) {
        return uint144(self._x >> RESOLUTION);
    }

    // multiply a UQ112x112 by a uint, returning a UQ144x112
    // reverts on overflow
    function mul(uq112x112 memory self, uint256 y) internal pure returns (uq144x112 memory) {
        uint256 z = 0;
        require(y == 0 || (z = self._x * y) / y == self._x, 'FixedPoint::mul: overflow');
        return uq144x112(z);
    }

    // multiply a UQ112x112 by an int and decode, returning an int
    // reverts on overflow
    function muli(uq112x112 memory self, int256 y) internal pure returns (int256) {
        uint256 z = FullMath.mulDiv(self._x, uint256(y < 0 ? -y : y), Q112);
        require(z < 2**255, 'FixedPoint::muli: overflow');
        return y < 0 ? -int256(z) : int256(z);
    }

    // multiply a UQ112x112 by a UQ112x112, returning a UQ112x112
    // lossy
    function muluq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
        if (self._x == 0 || other._x == 0) {
            return uq112x112(0);
        }
        uint112 upper_self = uint112(self._x >> RESOLUTION); // * 2^0
        uint112 lower_self = uint112(self._x & LOWER_MASK); // * 2^-112
        uint112 upper_other = uint112(other._x >> RESOLUTION); // * 2^0
        uint112 lower_other = uint112(other._x & LOWER_MASK); // * 2^-112

        // partial products
        uint224 upper = uint224(upper_self) * upper_other; // * 2^0
        uint224 lower = uint224(lower_self) * lower_other; // * 2^-224
        uint224 uppers_lowero = uint224(upper_self) * lower_other; // * 2^-112
        uint224 uppero_lowers = uint224(upper_other) * lower_self; // * 2^-112

        // so the bit shift does not overflow
        require(upper <= uint112(-1), 'FixedPoint::muluq: upper overflow');

        // this cannot exceed 256 bits, all values are 224 bits
        uint256 sum = uint256(upper << RESOLUTION) + uppers_lowero + uppero_lowers + (lower >> RESOLUTION);

        // so the cast does not overflow
        require(sum <= uint224(-1), 'FixedPoint::muluq: sum overflow');

        return uq112x112(uint224(sum));
    }

    // divide a UQ112x112 by a UQ112x112, returning a UQ112x112
    function divuq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
        require(other._x > 0, 'FixedPoint::divuq: division by zero');
        if (self._x == other._x) {
            return uq112x112(uint224(Q112));
        }
        if (self._x <= uint144(-1)) {
            uint256 value = (uint256(self._x) << RESOLUTION) / other._x;
            require(value <= uint224(-1), 'FixedPoint::divuq: overflow');
            return uq112x112(uint224(value));
        }

        uint256 result = FullMath.mulDiv(Q112, self._x, other._x);
        require(result <= uint224(-1), 'FixedPoint::divuq: overflow');
        return uq112x112(uint224(result));
    }

    // returns a UQ112x112 which represents the ratio of the numerator to the denominator
    // can be lossy
    function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
        require(denominator > 0, 'FixedPoint::fraction: division by zero');
        if (numerator == 0) return FixedPoint.uq112x112(0);

        if (numerator <= uint144(-1)) {
            uint256 result = (numerator << RESOLUTION) / denominator;
            require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
            return uq112x112(uint224(result));
        } else {
            uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
            require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
            return uq112x112(uint224(result));
        }
    }

    // take the reciprocal of a UQ112x112
    // reverts on overflow
    // lossy
    function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
        require(self._x != 0, 'FixedPoint::reciprocal: reciprocal of zero');
        require(self._x != 1, 'FixedPoint::reciprocal: overflow');
        return uq112x112(uint224(Q224 / self._x));
    }

    // square root of a UQ112x112
    // lossy between 0/1 and 40 bits
    function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
        if (self._x <= uint144(-1)) {
            return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
        }

        uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
        safeShiftBits -= safeShiftBits % 2;
        return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
    }
}


// File contracts/fei-protocol/mock/MockUniswapV2PairLiquidity.sol

/*
    Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;





contract MockUniswapV2PairLiquidity is IUniswapV2Pair {
    using SafeMath for uint256;
    using Decimal for Decimal.D256;

    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    uint256 private liquidity;
    address public override token0;
    address public override token1;

    constructor(address _token0, address _token1) public {
        token0 = _token0;
        token1 = _token1;
    } 

    function getReserves() external view override returns (uint112, uint112, uint32) {
        return (reserve0, reserve1, 0);
    }

    function mint(address to) public override returns (uint) {
        _mint(to, liquidity);
        return liquidity;
    }

    function mintAmount(address to, uint256 _liquidity) public payable {
        _mint(to, _liquidity);
    }

    function set(uint112 newReserve0, uint112 newReserve1, uint256 newLiquidity) external payable {
        reserve0 = newReserve0;
        reserve1 = newReserve1;
        liquidity = newLiquidity;
        mint(msg.sender);
    }

    function setReserves(uint112 newReserve0, uint112 newReserve1) external {
        reserve0 = newReserve0;
        reserve1 = newReserve1;
    }

    function faucet(address account, uint256 amount) external returns (bool) {
        _mint(account, amount);
        return true;
    }

    function burnEth(address to, Decimal.D256 memory ratio) public returns(uint256 amountEth, uint256 amount1) {
        uint256 balanceEth = address(this).balance;
        amountEth = ratio.mul(balanceEth).asUint256();
        payable(to).transfer(amountEth);

        uint256 balance1 = reserve1;
        amount1 = ratio.mul(balance1).asUint256();
        IERC20(token1).transfer(to, amount1);
    }

    function withdrawFei(address to, uint256 amount) public {
        IERC20(token1).transfer(to, amount);
    }

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external override { 
        // No - op;
    }


    /**
     * Should not use
     */

    function name() external pure override returns (string memory) { return "Uniswap V2"; }
    function symbol() external pure override returns (string memory) { return "UNI-V2"; }
    function decimals() external pure override returns (uint8) { return 18; }

    function DOMAIN_SEPARATOR() external view override returns (bytes32) { revert("Should not use"); }
    function PERMIT_TYPEHASH() external pure override returns (bytes32) { revert("Should not use"); }
    function nonces(address owner) external view override returns (uint) { revert("Should not use"); }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override { revert("Should not use"); }

    function MINIMUM_LIQUIDITY() external pure override returns (uint) { revert("Should not use"); }
    function factory() external view override returns (address) { revert("Should not use"); }
    function price0CumulativeLast() external view override returns (uint) { revert("Should not use"); }
    function price1CumulativeLast() external view override returns (uint) { revert("Should not use"); }
    function kLast() external view override returns (uint) { revert("Should not use"); }

    function skim(address to) external override { revert("Should not use"); }
    function sync() external override { revert("Should not use"); }
    function burn(address to) external override returns (uint amount0, uint amount1) { revert("Should not use"); }

    function initialize(address, address) external override { revert("Should not use"); }

    // @openzeppelin/contracts/token/ERC20/ERC20.sol

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
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
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}


// File contracts/fei-protocol/mock/MockUniswapV2PairTrade.sol

pragma solidity ^0.6.0;

contract MockUniswapV2PairTrade {

    uint public price0CumulativeLast;
    uint public price1CumulativeLast;

    uint112 public reserve0;
    uint112 public reserve1;
    uint32 public blockTimestampLast;

    constructor(
        uint _price0CumulativeLast, 
        uint _price1CumulativeLast, 
        uint32 _blockTimestampLast,
        uint112 r0,
        uint112 r1
    ) public {
        set(_price0CumulativeLast, _price1CumulativeLast, _blockTimestampLast);
        setReserves(r0, r1);
    }

    function getReserves() public view returns(uint112, uint112, uint32) {
        return (reserve0, reserve1, blockTimestampLast);
    }

    function simulateTrade(uint112 newReserve0, uint112 newReserve1, uint32 blockTimestamp) external {
        uint32 timeElapsed = blockTimestamp - blockTimestampLast;
        if (timeElapsed > 0 && reserve0 != 0 && reserve1 != 0) {
            price0CumulativeLast += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
            price1CumulativeLast += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
        }
        reserve0 = newReserve0;
        reserve1 = newReserve1;
        blockTimestampLast = blockTimestamp;
    }

    function set(uint _price0CumulativeLast, uint _price1CumulativeLast, uint32 _blockTimestampLast) public {
        price0CumulativeLast = _price0CumulativeLast;
        price1CumulativeLast = _price1CumulativeLast;
        blockTimestampLast = _blockTimestampLast;
    }

    function setReserves(uint112 r0, uint112 r1) public {
        reserve0 = r0;
        reserve1 = r1;
    }
}


// File contracts/fei-protocol/mock/MockWeth.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract MockWeth is MockERC20 {
    constructor() public {}

    function deposit() external payable {
    	mint(msg.sender, msg.value);
    }

    function withdraw(uint amount) external payable {
    	_burn(msg.sender, amount);
    	_msgSender().transfer(amount);
    }
}


// File contracts/fei-protocol/mock/RootsWrapper.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract RootsWrapper {
    using Roots for uint;

    function cubeRoot(uint x) public pure returns (uint) {
        return x.cubeRoot();
    }

    function twoThirdsRoot(uint x) public pure returns (uint) {
        return x.twoThirdsRoot();
    }

    function sqrt(uint x) public pure returns (uint) {
        return x.sqrt();
    }
}


// File contracts/fei-protocol/oracle/BondingCurveOracle.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;



/// @title IBondingCurveOracle implementation contract
/// @author Fei Protocol
/// @notice includes "thawing" on the initial purchase price at genesis. Time weights price from initial to true peg over a window.
contract BondingCurveOracle is IBondingCurveOracle, CoreRef, Timed {
	using Decimal for Decimal.D256;

	IOracle public override uniswapOracle;
	IBondingCurve public override bondingCurve;

	bool public override killSwitch = true;

	/// @notice the price in dollars at initialization
	/// @dev this price will "thaw" to the peg price over `duration` window
	Decimal.D256 public initialPrice;

	event KillSwitchUpdate(bool _killSwitch);

	/// @notice BondingCurveOracle constructor
	/// @param _core Fei Core to reference
	/// @param _oracle Uniswap Oracle to report from
	/// @param _bondingCurve Bonding curve to report from
	/// @param _duration price thawing duration
	constructor(
		address _core, 
		address _oracle, 
		address _bondingCurve, 
		uint32 _duration
	) public CoreRef(_core) Timed(_duration) {
		uniswapOracle = IOracle(_oracle);
		bondingCurve = IBondingCurve(_bondingCurve);
	}

	function update() external override returns (bool) {
		return uniswapOracle.update();
	}

    function read() external view override returns (Decimal.D256 memory, bool) {
    	if (killSwitch) {
    		return (Decimal.zero(), false);
    	}
    	(Decimal.D256 memory peg, bool valid) = getOracleValue();
    	return (thaw(peg), valid);
    }

	function setKillSwitch(bool _killSwitch) external override onlyGovernor {
		killSwitch = _killSwitch;
		emit KillSwitchUpdate(_killSwitch);
	}

	function init(Decimal.D256 memory _initialPrice) public override onlyGenesisGroup {
    	killSwitch = false;

    	initialPrice = _initialPrice;

		_initTimed();
    }

    function thaw(Decimal.D256 memory peg) internal view returns (Decimal.D256 memory) {
    	if (isTimeEnded()) {
    		return peg;
    	}
		uint t = uint(timestamp());
		uint remaining = uint(remainingTime());
		uint d = uint(duration);

    	(Decimal.D256 memory uniswapPeg,) = uniswapOracle.read();
    	Decimal.D256 memory price = uniswapPeg.div(peg);

    	Decimal.D256 memory weightedPrice = initialPrice.mul(remaining).add(price.mul(t)).div(d);
    	return uniswapPeg.div(weightedPrice);
    }

    function getOracleValue() internal view returns(Decimal.D256 memory, bool) {
    	if (bondingCurve.atScale()) {
    		return uniswapOracle.read();
    	}
    	return (bondingCurve.getCurrentPrice(), true);
    }
}


// File contracts/fei-protocol/oracle/IUniswapOracle.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title Uniswap oracle interface for Fei Protocol
/// @author Fei Protocol
/// @notice maintains the TWAP of a uniswap pair contract over a specified duration
interface IUniswapOracle is IOracle {

	// ----------- Events -----------
    event DurationUpdate(uint32 _duration);

    // ----------- Governor only state changing API -----------

    /// @notice set a new duration for the TWAP window
    function setDuration(uint32 _duration) external;

    // ----------- Getters -----------

    /// @notice the previous timestamp of the oracle snapshot
    function priorTimestamp() external returns(uint32);

    /// @notice the previous cumulative price of the oracle snapshot
    function priorCumulative() external returns(uint);

    /// @notice the window over which the initial price will "thaw" to the true peg price
    function duration() external returns(uint32);

    /// @notice the referenced uniswap pair contract
    function pair() external returns(IUniswapV2Pair);
}


// File @uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol@v1.1.0-beta.0

pragma solidity >=0.5.0;


// library with helper methods for oracles that are concerned with computing average prices
library UniswapV2OracleLibrary {
    using FixedPoint for *;

    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
    function currentBlockTimestamp() internal view returns (uint32) {
        return uint32(block.timestamp % 2 ** 32);
    }

    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
    function currentCumulativePrices(
        address pair
    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
        blockTimestamp = currentBlockTimestamp();
        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();

        // if time has elapsed since the last update on the pair, mock the accumulated price values
        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
        if (blockTimestampLast != blockTimestamp) {
            // subtraction overflow is desired
            uint32 timeElapsed = blockTimestamp - blockTimestampLast;
            // addition overflow is desired
            // counterfactual
            price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
            // counterfactual
            price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
        }
    }
}


// File contracts/fei-protocol/oracle/UniswapOracle.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

// Referencing Uniswap Example Simple Oracle
// https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleOracleSimple.sol



/// @title IUniswapOracle implementation contract
/// @author Fei Protocol
contract UniswapOracle is IUniswapOracle, CoreRef {
	using Decimal for Decimal.D256;

	IUniswapV2Pair public override pair;
	bool private isPrice0;

	uint public override priorCumulative; 
	uint32 public override priorTimestamp;

	Decimal.D256 private twap = Decimal.zero();
	uint32 public override duration;

	bool public override killSwitch;

	/// @notice UniswapOracle constructor
	/// @param _core Fei Core for reference
	/// @param _pair Uniswap Pair to provide TWAP
	/// @param _duration TWAP duration
	/// @param _isPrice0 flag for using token0 or token1 for cumulative on Uniswap
	constructor(
		address _core, 
		address _pair, 
		uint32 _duration,
		bool _isPrice0
	) public CoreRef(_core) {
		pair = IUniswapV2Pair(_pair);
		// Relative to USD per ETH price
		isPrice0 = _isPrice0;

		duration = _duration;

		_init();
	}

	function update() external override returns (bool) {
		(uint price0Cumulative, uint price1Cumulative, uint32 currentTimestamp) =
            UniswapV2OracleLibrary.currentCumulativePrices(address(pair));

		uint32 deltaTimestamp = currentTimestamp - priorTimestamp;
		if(currentTimestamp <= priorTimestamp || deltaTimestamp < duration) {
			return false;
		}

		uint currentCumulative = _getCumulative(price0Cumulative, price1Cumulative);
		uint deltaCumulative = (currentCumulative - priorCumulative) / 1e12;

		Decimal.D256 memory _twap = Decimal.ratio(2**112, deltaCumulative / deltaTimestamp);
		twap = _twap;

		priorTimestamp = currentTimestamp;
		priorCumulative = currentCumulative;

		emit Update(_twap.asUint256());

		return true;
	}

    function read() external view override returns (Decimal.D256 memory, bool) {
    	bool valid = !(killSwitch || twap.isZero());
    	return (twap, valid);
    }
 
	function setKillSwitch(bool _killSwitch) external override onlyGovernor {
		killSwitch = _killSwitch;
		emit KillSwitchUpdate(_killSwitch);
	}

	function setDuration(uint32 _duration) external override onlyGovernor {
		duration = _duration;
		emit DurationUpdate(_duration);
	}

	function _init() internal {
        uint price0Cumulative = pair.price0CumulativeLast();
        uint price1Cumulative = pair.price1CumulativeLast();

        (,, uint32 currentTimestamp) = pair.getReserves();

        priorTimestamp = currentTimestamp;
		priorCumulative = _getCumulative(price0Cumulative, price1Cumulative);
	}

    function _getCumulative(uint price0Cumulative, uint price1Cumulative) internal view returns (uint) {
		return isPrice0 ? price0Cumulative : price1Cumulative;
	}
}


// File contracts/fei-protocol/orchestration/BondingCurveOrchestrator.sol

pragma solidity ^0.6.0;



contract BondingCurveOrchestrator is Ownable {

	function init(
		address core, 
		address uniswapOracle, 
		address ethUniswapPCVDeposit, 
		uint scale,
		uint32 thawingDuration,
		uint32 bondingCurveIncentiveDuration,
		uint bondingCurveIncentiveAmount
	) public onlyOwner returns(
		address ethBondingCurve,
		address bondingCurveOracle
	) {
		uint[] memory ratios = new uint[](1);
		ratios[0] = 10000;
		address[] memory allocations = new address[](1);
		allocations[0] = address(ethUniswapPCVDeposit);
		ethBondingCurve = address(new EthBondingCurve(
			scale, 
			core, 
			allocations, 
			ratios, 
			uniswapOracle, 
			bondingCurveIncentiveDuration, 
			bondingCurveIncentiveAmount
		));
		bondingCurveOracle = address(new BondingCurveOracle(
			core, 
			uniswapOracle, 
			ethBondingCurve, 
			thawingDuration
		));
		return (
			ethBondingCurve,
			bondingCurveOracle
		);
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File @uniswap/v2-periphery/contracts/interfaces/IWETH.sol@v1.1.0-beta.0

pragma solidity >=0.5.0;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}


// File @openzeppelin/contracts/math/Math.sol@v3.4.2

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}


// File contracts/fei-protocol/token/IUniswapIncentive.sol

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


/// @title Uniswap trading incentive contract
/// @author Fei Protocol
/// @dev incentives are only appplied if the contract is appointed as a Minter or Burner, otherwise skipped
interface IUniswapIncentive is IIncentive {

	// ----------- Events -----------

    event TimeWeightUpdate(uint _weight, bool _active);

    event GrowthRateUpdate(uint _growthRate);

    event ExemptAddressUpdate(address indexed _account, bool _isExempt);

    event SellAllowedAddressUpdate(address indexed _account, bool _isSellAllowed);

	// ----------- Governor only state changing api -----------

	/// @notice set an address to be exempted from Uniswap trading incentives
	/// @param account the address to update
	/// @param isExempt a flag for whether to exempt or unexempt
 	function setExemptAddress(address account, bool isExempt) external;

	/// @notice set an address to be able to send tokens to Uniswap
	/// @param account the address to update
	/// @param isAllowed a flag for whether the account is allowed to sell or not
	function setSellAllowlisted(address account, bool isAllowed) external;

	/// @notice set the time weight growth function
	function setTimeWeightGrowth(uint32 growthRate) external;

	/// @notice sets all of the time weight parameters
	// @param blockNo the stored last block number of the time weight
	/// @param weight the stored last time weight
	/// @param growth the growth rate of the time weight per block
	/// @param active a flag signifying whether the time weight is currently growing or not
	function setTimeWeight(uint32 weight, uint32 growth, bool active) external;

	// ----------- Getters -----------

	/// @notice return true if burn incentive equals mint
	function isIncentiveParity() external view returns (bool);

	/// @notice returns true if account is marked as exempt
	function isExemptAddress(address account) external view returns (bool);

	/// @notice return true if the account is approved to sell to the Uniswap pool
	function isSellAllowlisted(address account) external view returns (bool);

	/// @notice the granularity of the time weight and growth rate
	// solhint-disable-next-line func-name-mixedcase
	function TIME_WEIGHT_GRANULARITY() external view returns(uint32);

	/// @notice the growth rate of the time weight per block
	function getGrowthRate() external view returns (uint32);

	/// @notice the time weight of the current block
	/// @dev factors in the stored block number and growth rate if active
	function getTimeWeight() external view returns (uint32);

	/// @notice returns true if time weight is active and growing at the growth rate
	function isTimeWeightActive() external view returns (bool);

	/// @notice get the incentive amount of a buy transfer
	/// @param amount the FEI size of the transfer
	/// @return incentive the FEI size of the mint incentive
	/// @return weight the time weight of thhe incentive
	/// @return initialDeviation the Decimal deviation from peg before a transfer
	/// @return finalDeviation the Decimal deviation from peg after a transfer
	/// @dev calculated based on a hypothetical buy, applies to any ERC20 FEI transfer from the pool
	function getBuyIncentive(uint amount) external view returns(
        uint incentive, 
        uint32 weight,
        Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation
    );

	/// @notice get the burn amount of a sell transfer
	/// @param amount the FEI size of the transfer
	/// @return penalty the FEI size of the burn incentive
	/// @return initialDeviation the Decimal deviation from peg before a transfer
	/// @return finalDeviation the Decimal deviation from peg after a transfer
	/// @dev calculated based on a hypothetical sell, applies to any ERC20 FEI transfer to the pool
	function getSellPenalty(uint amount) external view returns(
        uint penalty, 
        Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation
    );
}


// File contracts/fei-protocol/pcv/IUniswapPCVController.sol

pragma solidity ^0.6.2;


/// @title a Uniswap PCV Controller interface
/// @author Fei Protocol
interface IUniswapPCVController {
    
    // ----------- Events -----------

    event Reweight(address indexed _caller);

	event PCVDepositUpdate(address indexed _pcvDeposit);

	event ReweightIncentiveUpdate(uint _amount);

	event ReweightMinDistanceUpdate(uint _basisPoints);

    // ----------- State changing API -----------

    /// @notice reweights the linked PCV Deposit to the peg price. Needs to be reweight eligible
	function reweight() external;

    // ----------- Governor only state changing API -----------

    /// @notice reweights regardless of eligibility
    function forceReweight() external;

    /// @notice sets the target PCV Deposit address
	function setPCVDeposit(address _pcvDeposit) external;

    /// @notice sets the reweight incentive amount
	function setReweightIncentive(uint amount) external;

    /// @notice sets the reweight min distance in basis points
	function setReweightMinDistance(uint basisPoints) external;

    // ----------- Getters -----------

    /// @notice returns the linked pcv deposit contract
	function pcvDeposit() external returns(IPCVDeposit);

    /// @notice returns the linked Uniswap incentive contract
    function incentiveContract() external returns(IUniswapIncentive);

    /// @notice gets the FEI reward incentive for reweighting
    function reweightIncentiveAmount() external returns(uint);

    /// @notice signal whether the reweight is available. Must have incentive parity and minimum distance from peg
	function reweightEligible() external view returns(bool);
}


// File contracts/fei-protocol/pcv/EthUniswapPCVController.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;







/// @title a IUniswapPCVController implementation for ETH
/// @author Fei Protocol
contract EthUniswapPCVController is IUniswapPCVController, UniRef {
	using Decimal for Decimal.D256;

	IPCVDeposit public override pcvDeposit;
	IUniswapIncentive public override incentiveContract;

	uint public override reweightIncentiveAmount;
	Decimal.D256 public minDistanceForReweight;

	/// @notice EthUniswapPCVController constructor
	/// @param _core Fei Core for reference
	/// @param _pcvDeposit PCV Deposit to reweight
	/// @param _oracle oracle for reference
	/// @param _incentiveContract incentive contract for reference
	/// @param _incentiveAmount amount of FEI for triggering a reweight
	/// @param _minDistanceForReweightBPs minimum distance from peg to reweight in basis points
	/// @param _pair Uniswap pair contract to reweight
	/// @param _router Uniswap Router
	constructor (
		address _core, 
		address _pcvDeposit, 
		address _oracle, 
		address _incentiveContract,
		uint _incentiveAmount,
		uint _minDistanceForReweightBPs,
		address _pair,
		address _router
	) public
		UniRef(_core, _pair, _router, _oracle)
	{
		pcvDeposit = IPCVDeposit(_pcvDeposit);
		incentiveContract = IUniswapIncentive(_incentiveContract);

		reweightIncentiveAmount = _incentiveAmount;
		minDistanceForReweight = Decimal.ratio(_minDistanceForReweightBPs, 10000);
	}

	receive() external payable {}

	function reweight() external override postGenesis {
		require(reweightEligible(), "EthUniswapPCVController: Not at incentive parity or not at min distance");
		_reweight();
		_incentivize();
	}

	function forceReweight() external override onlyGovernor {
		_reweight();
	}

	function setPCVDeposit(address _pcvDeposit) external override onlyGovernor {
		pcvDeposit = IPCVDeposit(_pcvDeposit);
		emit PCVDepositUpdate(_pcvDeposit);
	}

	function setReweightIncentive(uint amount) external override onlyGovernor {
		reweightIncentiveAmount = amount;
		emit ReweightIncentiveUpdate(amount);
	}

	function setReweightMinDistance(uint basisPoints) external override onlyGovernor {
		minDistanceForReweight = Decimal.ratio(basisPoints, 10000);
		emit ReweightMinDistanceUpdate(basisPoints);
	}

	function reweightEligible() public view override returns(bool) {
		bool magnitude = getDistanceToPeg().greaterThan(minDistanceForReweight);
		bool time = incentiveContract.isIncentiveParity();
		return magnitude && time;
	}

	function _incentivize() internal ifMinterSelf {
		fei().mint(msg.sender, reweightIncentiveAmount);
	}

	function _reweight() internal {
		_withdrawAll();
		_returnToPeg();

		uint balance = address(this).balance;
		pcvDeposit.deposit{value: balance}(balance);

		_burnFeiHeld();

		emit Reweight(msg.sender);
	}

	function _returnToPeg() internal {
		(uint feiReserves, uint ethReserves) = getReserves();
		if (feiReserves == 0 || ethReserves == 0) {
			return;
		}

		updateOracle();

    	require(isBelowPeg(peg()), "EthUniswapPCVController: already at or above peg");
    	
		uint amountEth = getAmountToPegOther();
    	_swapEth(amountEth, ethReserves, feiReserves);
	}

	function _swapEth(uint amountEth, uint ethReserves, uint feiReserves) internal {
		uint balance = address(this).balance;
		uint amount = Math.min(amountEth, balance);
		
		uint amountOut = UniswapV2Library.getAmountOut(amount, ethReserves, feiReserves);
		
		IWETH weth = IWETH(router.WETH());
		weth.deposit{value: amount}();
		weth.transfer(address(pair), amount);

		(uint amount0Out, uint amount1Out) = pair.token0() == address(weth) ? (uint(0), amountOut) : (amountOut, uint(0));
		pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
	}

	function _withdrawAll() internal {
		uint value = pcvDeposit.totalValue();
		pcvDeposit.withdraw(address(this), value);
	}
}


// File contracts/fei-protocol/orchestration/ControllerOrchestrator.sol

pragma solidity ^0.6.0;


contract ControllerOrchestrator is Ownable {

	function init(
		address core,
		address bondingCurveOracle, 
		address uniswapIncentive, 
		address ethUniswapPCVDeposit,
		address pair, 
		address router,
		uint reweightIncentive,
		uint reweightMinDistanceBPs
	) public onlyOwner returns(address) {
		return address(new EthUniswapPCVController(
				core, 
				ethUniswapPCVDeposit, 
				bondingCurveOracle, 
				uniswapIncentive,
				reweightIncentive,
				reweightMinDistanceBPs,
				pair, 
				router
			));
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// File contracts/fei-protocol/orchestration/CoreOrchestrator.sol

pragma solidity ^0.6.0;







interface IPCVDepositOrchestrator {
	function init(
		address core, 
		address pair, 
		address router,
		address oraclePair,
		uint32 twapDuration,
		bool price0
	) external returns(
		address ethUniswapPCVDeposit,
		address uniswapOracle
	);

	function detonate() external;
}

interface IBondingCurveOrchestrator {
	function init(
		address core, 
		address uniswapOracle, 
		address ethUniswapPCVDeposit, 
		uint scale,
		uint32 thawingDuration,
		uint32 bondingCurveIncentiveDuration,
		uint bondingCurveIncentiveAmount
	) external returns(
		address ethBondingCurve,
		address bondingCurveOracle
	);

	function detonate() external;
}

interface IIncentiveOrchestrator {
	function init(
		address core, 
		address bondingCurveOracle, 
		address fei, 
		address router,
		uint32 growthRate
	) external returns(address uniswapIncentive);
	function detonate() external;
}

interface IRouterOrchestrator {
	function init(
		address pair, 
		address weth,
		address incentive
	) external returns(address ethRouter);

	function detonate() external;
}

interface IControllerOrchestrator {
	function init(
		address core, 
		address bondingCurveOracle, 
		address uniswapIncentive, 
		address ethUniswapPCVDeposit, 
		address fei, 
		address router,
		uint reweightIncentive,
		uint reweightMinDistanceBPs
	) external returns(address ethUniswapPCVController);
	function detonate() external;
}

interface IIDOOrchestrator {
	function init(
		address core, 
		address admin, 
		address tribe, 
		address pair, 
		address router,
		uint32 releaseWindow
	) external returns (
		address ido,
		address timelockedDelegator
	);
	function detonate() external;
}

interface IGenesisOrchestrator {
	function init(
		address core, 
		address ethBondingCurve, 
		address ido,
		address tribeFeiPair,
		address oracle,
		uint32 genesisDuration,
		uint maxPriceBPs,
		uint exhangeRateDiscount,
		uint32 poolDuration
	) external returns (address genesisGroup, address pool);
	function detonate() external;
}

interface IGovernanceOrchestrator {
	function init(address admin, address tribe, uint timelockDelay) external returns (
		address governorAlpha, 
		address timelock
	);
	function detonate() external;
}

interface ITribe {
	function setMinter(address minter_) external;
}

// solhint-disable-next-line max-states-count
contract CoreOrchestrator is Ownable {
	address public admin;
	bool private constant TEST_MODE = true;

	// ----------- Uniswap Addresses -----------
	address public constant ETH_USDC_UNI_PAIR = address(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
	address public constant ROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

	address public constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
	IUniswapV2Factory public constant UNISWAP_FACTORY = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

	address public ethFeiPair;
	address public tribeFeiPair;

	// ----------- Time periods -----------
	uint32 constant public RELEASE_WINDOW = TEST_MODE ? 4 days : 4 * 365 days;

	uint public constant TIMELOCK_DELAY = TEST_MODE ? 1 hours : 3 days;
	uint32 public constant GENESIS_DURATION = TEST_MODE ? 1 minutes : 3 days;

	uint32 public constant POOL_DURATION = TEST_MODE ? 2 days : 2 * 365 days;
	uint32 public constant THAWING_DURATION = TEST_MODE ? 4 minutes : 4 weeks;

	uint32 public constant UNI_ORACLE_TWAP_DURATION = TEST_MODE ? 1 : 10 minutes; // 10 min twap

	uint32 public constant BONDING_CURVE_INCENTIVE_DURATION = TEST_MODE ? 1 : 1 days; // 1 day duration

	// ----------- Params -----------
	uint public constant MAX_GENESIS_PRICE_BPS = 9000;
	uint public constant EXCHANGE_RATE_DISCOUNT = 10;

	uint32 public constant INCENTIVE_GROWTH_RATE = TEST_MODE ? 1_000_000 : 333; // about 1 unit per hour assuming 12s block time

	uint public constant SCALE = 250_000_000e18;
	uint public constant BONDING_CURVE_INCENTIVE = 500e18;

	uint public constant REWEIGHT_INCENTIVE = 500e18;
	uint public constant MIN_REWEIGHT_DISTANCE_BPS = 100;

	bool public constant USDC_PER_ETH_IS_PRICE_0 = true;


	uint public tribeSupply;
	uint public constant IDO_TRIBE_PERCENTAGE = 20;
	uint public constant GENESIS_TRIBE_PERCENTAGE = 10;
	uint public constant DEV_TRIBE_PERCENTAGE = 20;
	uint public constant STAKING_TRIBE_PERCENTAGE = 20;

	// ----------- Orchestrators -----------
	IPCVDepositOrchestrator private pcvDepositOrchestrator;
	IBondingCurveOrchestrator private bcOrchestrator;
	IIncentiveOrchestrator private incentiveOrchestrator;
	IControllerOrchestrator private controllerOrchestrator;
	IIDOOrchestrator private idoOrchestrator;
	IGenesisOrchestrator private genesisOrchestrator;
	IGovernanceOrchestrator private governanceOrchestrator;
	IRouterOrchestrator private routerOrchestrator;

	// ----------- Deployed Contracts -----------
	Core public core;
	address public fei;
	address public tribe;
	address public feiRouter;

	address public ethUniswapPCVDeposit;
	address public ethBondingCurve;
		
	address public uniswapOracle;
	address public bondingCurveOracle;

	address public uniswapIncentive;

	address public ethUniswapPCVController;

	address public ido;
	address public timelockedDelegator;

	address public genesisGroup;
	address public pool;

	address public governorAlpha;
	address public timelock;

	constructor(
		address _pcvDepositOrchestrator,
		address _bcOrchestrator, 
		address _incentiveOrchestrator, 
		address _controllerOrchestrator,
		address _idoOrchestrator,
		address _genesisOrchestrator, 
		address _governanceOrchestrator,
		address _routerOrchestrator,
		address _admin
	) public {
		core = new Core();
		tribe = address(core.tribe());
		fei = address(core.fei());

		core.grantRevoker(_admin);

		pcvDepositOrchestrator = IPCVDepositOrchestrator(_pcvDepositOrchestrator);
		bcOrchestrator = IBondingCurveOrchestrator(_bcOrchestrator);
		incentiveOrchestrator = IIncentiveOrchestrator(_incentiveOrchestrator);
		idoOrchestrator = IIDOOrchestrator(_idoOrchestrator);
		controllerOrchestrator = IControllerOrchestrator(_controllerOrchestrator);
		genesisOrchestrator = IGenesisOrchestrator(_genesisOrchestrator);
		governanceOrchestrator = IGovernanceOrchestrator(_governanceOrchestrator);
		routerOrchestrator = IRouterOrchestrator(_routerOrchestrator);

		admin = _admin;
		tribeSupply = IERC20(tribe).totalSupply();
		if (TEST_MODE) {
			core.grantGovernor(_admin);
		}
	}

	function initPairs() public onlyOwner {
		ethFeiPair = UNISWAP_FACTORY.createPair(fei, WETH);
		tribeFeiPair = UNISWAP_FACTORY.createPair(tribe, fei);
	}

	function initPCVDeposit() public onlyOwner() {
		(ethUniswapPCVDeposit, uniswapOracle) = pcvDepositOrchestrator.init(
			address(core),
			ethFeiPair,
			ROUTER,
			ETH_USDC_UNI_PAIR,
			UNI_ORACLE_TWAP_DURATION,
			USDC_PER_ETH_IS_PRICE_0
		);
		core.grantMinter(ethUniswapPCVDeposit);
		pcvDepositOrchestrator.detonate();
	}

	function initBondingCurve() public onlyOwner {
		(ethBondingCurve,
		 bondingCurveOracle) = bcOrchestrator.init(
			 address(core), 
			 uniswapOracle, 
			 ethUniswapPCVDeposit, 
			 SCALE, 
			 THAWING_DURATION,
			 BONDING_CURVE_INCENTIVE_DURATION,
			 BONDING_CURVE_INCENTIVE
		);
		core.grantMinter(ethBondingCurve);
		IOracleRef(ethUniswapPCVDeposit).setOracle(bondingCurveOracle);
		bcOrchestrator.detonate();
	}

	function initIncentive() public onlyOwner {
		uniswapIncentive = incentiveOrchestrator.init(
			address(core), 
			bondingCurveOracle, 
			ethFeiPair,
			ROUTER,
			INCENTIVE_GROWTH_RATE
		);
		core.grantMinter(uniswapIncentive);
		core.grantBurner(uniswapIncentive);
		IFei(fei).setIncentiveContract(ethFeiPair, uniswapIncentive);
		incentiveOrchestrator.detonate();
	}

	function initRouter() public onlyOwner {
		feiRouter = routerOrchestrator.init(ethFeiPair, WETH, uniswapIncentive);
		
		IUniswapIncentive(uniswapIncentive).setSellAllowlisted(feiRouter, true);
		IUniswapIncentive(uniswapIncentive).setSellAllowlisted(ethUniswapPCVDeposit, true);
		IUniswapIncentive(uniswapIncentive).setSellAllowlisted(ethUniswapPCVController, true);

	}

	function initController() public onlyOwner {
		ethUniswapPCVController = controllerOrchestrator.init(
			address(core), 
			bondingCurveOracle, 
			uniswapIncentive, 
			ethUniswapPCVDeposit, 
			ethFeiPair,
			ROUTER,
			REWEIGHT_INCENTIVE,
			MIN_REWEIGHT_DISTANCE_BPS
		);
		core.grantMinter(ethUniswapPCVController);
		core.grantPCVController(ethUniswapPCVController);
		
		IUniswapIncentive(uniswapIncentive).setExemptAddress(ethUniswapPCVDeposit, true);
		IUniswapIncentive(uniswapIncentive).setExemptAddress(ethUniswapPCVController, true);

		controllerOrchestrator.detonate();
	}

	function initIDO() public onlyOwner {
		(ido, timelockedDelegator) = idoOrchestrator.init(address(core), admin, tribe, tribeFeiPair, ROUTER, RELEASE_WINDOW);
		core.grantMinter(ido);
		core.allocateTribe(ido, tribeSupply * IDO_TRIBE_PERCENTAGE / 100);
		core.allocateTribe(timelockedDelegator, tribeSupply * DEV_TRIBE_PERCENTAGE / 100);
		idoOrchestrator.detonate();
	}

	function initGenesis() public onlyOwner {
		(genesisGroup, pool) = genesisOrchestrator.init(
			address(core), 
			ethBondingCurve, 
			ido,
			tribeFeiPair,
			bondingCurveOracle,
			GENESIS_DURATION,
			MAX_GENESIS_PRICE_BPS,
			EXCHANGE_RATE_DISCOUNT,
			POOL_DURATION
		);
		core.setGenesisGroup(genesisGroup);
		core.allocateTribe(genesisGroup, tribeSupply * GENESIS_TRIBE_PERCENTAGE / 100);
		core.allocateTribe(pool, tribeSupply * STAKING_TRIBE_PERCENTAGE / 100);
		genesisOrchestrator.detonate();
	}

	function initGovernance() public onlyOwner {
		(governorAlpha, timelock) = governanceOrchestrator.init(
			admin, 
			tribe,
			TIMELOCK_DELAY
		);
		governanceOrchestrator.detonate();
		core.grantGovernor(timelock);
		ITribe(tribe).setMinter(timelock);
	}
}


// File contracts/fei-protocol/utils/SafeMath128.sol

// SPDX-License-Identifier: MIT

// SafeMath for 128 bit integers inspired by OpenZeppelin SafeMath
pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath128 { 
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint128 a, uint128 b) internal pure returns (uint128) {
        uint128 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint128 a, uint128 b) internal pure returns (uint128) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint128 a, uint128 b, string memory errorMessage) internal pure returns (uint128) {
        require(b <= a, errorMessage);
        uint128 c = a - b;

        return c;
    }

        /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint128 a, uint128 b) internal pure returns (uint128) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint128 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint128 a, uint128 b) internal pure returns (uint128) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint128 a, uint128 b, string memory errorMessage) internal pure returns (uint128) {
        require(b > 0, errorMessage);
        uint128 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}


// File contracts/fei-protocol/pool/Pool.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;








/// @title abstract implementation of IPool interface
/// @author Fei Protocol
abstract contract Pool is IPool, ERC20, ERC20Burnable, Timed {
	using Decimal for Decimal.D256;
	using SafeMath128 for uint128;
	using SafeCast for uint;

	bool internal initialized;

	IERC20 public override rewardToken;
	IERC20 public override stakedToken;

	uint128 public override claimedRewards;
	uint128 public override totalStaked;

    mapping (address => uint) public override stakedBalance;

	/// @notice Pool constructor
	/// @param _duration duration of the pool reward distribution
	/// @param _name the name of the pool token
	/// @param _ticker the token ticker for the pool token
	constructor(
		uint32 _duration,
		string memory _name,
		string memory _ticker
	) public ERC20(_name, _ticker) Timed(_duration) {}

	function claim(address from, address to) external override returns(uint amountReward) {
		amountReward = _claim(from, to);
		emit Claim(from, to, amountReward);
		return amountReward;
	}

	function deposit(address to, uint amount) external override {
		address from = msg.sender;
		_deposit(from, to, amount);
		emit Deposit(from, to, amount);
	}

	function withdraw(address to) external override returns(uint amountStaked, uint amountReward) {
		address from = msg.sender;
		amountReward = _claim(from, to);
		amountStaked = _withdraw(from, to);
		emit Withdraw(from, to, amountStaked, amountReward);
		return (amountStaked, amountReward);
	}

	function init() public override virtual {
		require(!initialized, "Pool: Already initialized");
		_initTimed();
		initialized = true;
	}

    function redeemableReward(address account) public view override returns(uint amountReward, uint amountPool) {
		amountPool = _redeemablePoolTokens(account);
		uint totalRedeemablePool = _totalRedeemablePoolTokens();
		if (totalRedeemablePool == 0) {
			return (0, 0);
		}
		return (releasedReward() * amountPool / totalRedeemablePool, amountPool);
    }

	function releasedReward() public view override returns (uint) {
		uint total = rewardBalance();
		uint unreleased = unreleasedReward();
		return total.sub(unreleased, "Pool: Released Reward underflow");
	}

	function unreleasedReward() public view override returns (uint) {
		if (isTimeEnded()) {
			return 0;
		}
		return _unreleasedReward(totalReward(), uint(duration), uint(timestamp()));
	}

	function totalReward() public view override returns (uint) {
		return rewardBalance() + uint(claimedRewards);
	}

	function rewardBalance() public view override returns (uint) {
		return rewardToken.balanceOf(address(this));
	}

	function burnFrom(address account, uint amount) public override {
		if (msg.sender == account) {
			increaseAllowance(account, amount);
		}
		super.burnFrom(account, amount);
	}

	function _totalRedeemablePoolTokens() internal view returns(uint) {
		uint total = totalSupply();
		uint balance = _twfb(uint(totalStaked));
		return total.sub(balance, "Pool: Total redeemable underflow");
	}

	function _redeemablePoolTokens(address account) internal view returns(uint) {
		uint total = balanceOf(account);
		uint balance = _twfb(stakedBalance[account]);
		return total.sub(balance, "Pool: Redeemable underflow");
	}

	function _unreleasedReward(uint _totalReward, uint _duration, uint _time) internal view virtual returns (uint);

	function _deposit(address from, address to, uint amount) internal {
		require(initialized, "Pool: Uninitialized");
		require(amount <= stakedToken.balanceOf(from), "Pool: Balance too low to stake");

		stakedToken.transferFrom(from, address(this), amount);

		stakedBalance[to] += amount;
		_incrementStaked(amount);
		
		uint poolTokens = _twfb(amount);
		require(poolTokens != 0, "Pool: Window has ended");

		_mint(to, poolTokens);
	}

	function _withdraw(address from, address to) internal returns(uint amountStaked) {
		amountStaked = stakedBalance[from];
		stakedBalance[from] = 0;
		stakedToken.transfer(to, amountStaked);

		uint amountPool = balanceOf(from);
		if (amountPool != 0) {
			_burn(from, amountPool);
		}
		return amountStaked;	
	}

	function _claim(address from, address to) internal returns(uint) {
		(uint amountReward, uint amountPool) = redeemableReward(from);
		require(amountPool != 0, "Pool: User has no redeemable pool tokens");

		burnFrom(from, amountPool);
		_incrementClaimed(amountReward);

		rewardToken.transfer(to, amountReward);
		return amountReward;
	}

	function _incrementClaimed(uint amount) internal {
		claimedRewards = claimedRewards.add(amount.toUint128());
	}

	function _incrementStaked(uint amount) internal {
		totalStaked = totalStaked.add(amount.toUint128());
	}

	function _twfb(uint amount) internal view returns(uint) {
		return amount * uint(remainingTime());
	}

	// Updates stored staked balance pro-rata for transfer and transferFrom
	function _beforeTokenTransfer(address from, address to, uint amount) internal override {
        if (from != address(0) && to != address(0)) {
 			Decimal.D256 memory ratio = Decimal.ratio(amount, balanceOf(from));
 			uint amountStaked = ratio.mul(stakedBalance[from]).asUint256();
			
 			stakedBalance[from] -= amountStaked;
 			stakedBalance[to] += amountStaked;
        }
    }

	function _setTokens(address _rewardToken, address _stakedToken) internal {
		rewardToken = IERC20(_rewardToken);
		stakedToken = IERC20(_stakedToken);	
	}
}


// File contracts/fei-protocol/pool/FeiPool.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title A Pool for earning TRIBE with staked FEI/TRIBE LP tokens
/// @author Fei Protocol
/// @notice deposited LP tokens will earn TRIBE over time at a linearly decreasing rate
contract FeiPool is Pool, CoreRef {
	
	/// @notice Fei Pool constructor
	/// @param _core Fei Core to reference
	/// @param _pair Uniswap pair to stake
	/// @param _duration duration of staking rewards
	constructor(address _core, address _pair, uint32 _duration) public 
		CoreRef(_core) Pool(_duration, "Fei USD Pool", "FPOOL") 
	{
		_setTokens(
			address(tribe()),
			_pair
		);
	}

	/// @notice sends tokens back to governance treasury. Only callable by governance
	/// @param amount the amount of tokens to send back to treasury
	function governorWithdraw(uint amount) external onlyGovernor {
		tribe().transfer(address(core()), amount);
	}

	function init() public override postGenesis {
		super.init();	
	}

	// Represents the integral of 2R/d - 2R/d^2 x dx from t to d
	// Integral equals 2Rx/d - Rx^2/d^2
	// Evaluated at t = 2R*t/d (start) - R*t^2/d^2 (end)
	// Evaluated at d = 2R - R = R
	// Solution = R - (start - end) or equivalently end + R - start (latter more convenient to code)
	function _unreleasedReward(
		uint _totalReward, 
		uint _duration, 
		uint _time
	) internal view override returns (uint) {
		// 2R*t/d 
		Decimal.D256 memory start = Decimal.ratio(_totalReward, _duration).mul(2).mul(_time);

		// R*t^2/d^2
		Decimal.D256 memory end = Decimal.ratio(_totalReward, _duration).div(_duration).mul(_time * _time);

		return end.add(_totalReward).sub(start).asUint256();
	}
}


// File contracts/fei-protocol/orchestration/GenesisOrchestrator.sol

pragma solidity ^0.6.0;



contract GenesisOrchestrator is Ownable {

	function init(
		address core, 
		address ethBondingCurve, 
		address ido, 
		address tribeFeiPair,
		address oracle,
		uint32 genesisDuration,
		uint maxPriceBPs,
		uint exhangeRateDiscount,
		uint32 poolDuration
	) public onlyOwner returns (address genesisGroup, address pool) {
		pool = address(new FeiPool(core, tribeFeiPair, poolDuration));
		genesisGroup = address(new GenesisGroup(
			core, 
			ethBondingCurve, 
			ido,
			oracle,
			pool, 
			genesisDuration, 
			maxPriceBPs, 
			exhangeRateDiscount
		));
		return (genesisGroup, pool);
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File contracts/fei-protocol/dao/GovernorAlpha.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

// Forked from Compound
// See https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorAlpha.sol
contract GovernorAlpha {
    /// @notice The name of this contract
    // solhint-disable-next-line const-name-snakecase
    string public constant name = "Compound Governor Alpha";

    /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
    function quorumVotes() public pure returns (uint) { return 1000000e18; } // 1,000,000 = 10% of Tribe

    /// @notice The number of votes required in order for a voter to become a proposer
    function proposalThreshold() public pure returns (uint) { return 100000e18; } // 100,000 = 1% of Tribe

    /// @notice The maximum number of actions that can be included in a proposal
    function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions

    /// @notice The delay before voting on a proposal may take place, once proposed
    function votingDelay() public pure returns (uint) { return 1; } // 1 block

    /// @notice The duration of voting on a proposal, in blocks
    function votingPeriod() public pure returns (uint) { return 17280; } // ~3 days in blocks (assuming 15s blocks)

    /// @notice The address of the Fei Protocol Timelock
    TimelockInterface public timelock;

    /// @notice The address of the Fei governance token
    CompInterface public tribe;

    /// @notice The address of the Governor Guardian
    address public guardian;

    /// @notice The total number of proposals
    uint public proposalCount;

    struct Proposal {
        /// @notice Unique id for looking up a proposal
        uint id;

        /// @notice Creator of the proposal
        address proposer;

        /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
        uint eta;

        /// @notice the ordered list of target addresses for calls to be made
        address[] targets;

        /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
        uint[] values;

        /// @notice The ordered list of function signatures to be called
        string[] signatures;

        /// @notice The ordered list of calldata to be passed to each call
        bytes[] calldatas;

        /// @notice The block at which voting begins: holders must delegate their votes prior to this block
        uint startBlock;

        /// @notice The block at which voting ends: votes must be cast prior to this block
        uint endBlock;

        /// @notice Current number of votes in favor of this proposal
        uint forVotes;

        /// @notice Current number of votes in opposition to this proposal
        uint againstVotes;

        /// @notice Flag marking whether the proposal has been canceled
        bool canceled;

        /// @notice Flag marking whether the proposal has been executed
        bool executed;

        /// @notice Receipts of ballots for the entire set of voters
        mapping (address => Receipt) receipts;
    }

    /// @notice Ballot receipt record for a voter
    struct Receipt {
        /// @notice Whether or not a vote has been cast
        bool hasVoted;

        /// @notice Whether or not the voter supports the proposal
        bool support;

        /// @notice The number of votes the voter had, which were cast
        uint96 votes;
    }

    /// @notice Possible states that a proposal may be in
    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed
    }

    /// @notice The official record of all proposals ever proposed
    mapping (uint => Proposal) public proposals;

    /// @notice The latest proposal for each proposer
    mapping (address => uint) public latestProposalIds;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the ballot struct used by the contract
    bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");

    /// @notice An event emitted when a new proposal is created
    event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);

    /// @notice An event emitted when a vote has been cast on a proposal
    event VoteCast(address voter, uint proposalId, bool support, uint votes);

    /// @notice An event emitted when a proposal has been canceled
    event ProposalCanceled(uint id);

    /// @notice An event emitted when a proposal has been queued in the Timelock
    event ProposalQueued(uint id, uint eta);

    /// @notice An event emitted when a proposal has been executed in the Timelock
    event ProposalExecuted(uint id);

    constructor(address timelock_, address tribe_, address guardian_) public {
        timelock = TimelockInterface(timelock_);
        tribe = CompInterface(tribe_);
        guardian = guardian_;
    }

    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
        require(tribe.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");
        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");
        require(targets.length != 0, "GovernorAlpha::propose: must provide actions");
        require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");

        uint latestProposalId = latestProposalIds[msg.sender];
        if (latestProposalId != 0) {
          ProposalState proposersLatestProposalState = state(latestProposalId);
          require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");
          require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");
        }

        uint startBlock = add256(block.number, votingDelay());
        uint endBlock = add256(startBlock, votingPeriod());

        proposalCount++;
        Proposal memory newProposal = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            eta: 0,
            targets: targets,
            values: values,
            signatures: signatures,
            calldatas: calldatas,
            startBlock: startBlock,
            endBlock: endBlock,
            forVotes: 0,
            againstVotes: 0,
            canceled: false,
            executed: false
        });

        proposals[newProposal.id] = newProposal;
        latestProposalIds[newProposal.proposer] = newProposal.id;

        emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
        return newProposal.id;
    }

    function queue(uint proposalId) public {
        require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");
        Proposal storage proposal = proposals[proposalId];
        // solhint-disable-next-line not-rely-on-time
        uint eta = add256(block.timestamp, timelock.delay());
        for (uint i = 0; i < proposal.targets.length; i++) {
            _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
        }
        proposal.eta = eta;
        emit ProposalQueued(proposalId, eta);
    }

    function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {
        require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorAlpha::_queueOrRevert: proposal action already queued at eta");
        timelock.queueTransaction(target, value, signature, data, eta);
    }

    function execute(uint proposalId) public payable {
        require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");
        Proposal storage proposal = proposals[proposalId];
        proposal.executed = true;
        for (uint i = 0; i < proposal.targets.length; i++) {
            timelock.executeTransaction{value : proposal.values[i]}(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
        }
        emit ProposalExecuted(proposalId);
    }

    function cancel(uint proposalId) public {
        ProposalState state = state(proposalId);
        require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");

        Proposal storage proposal = proposals[proposalId];
        require(msg.sender == guardian || tribe.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");

        proposal.canceled = true;
        for (uint i = 0; i < proposal.targets.length; i++) {
            timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
        }

        emit ProposalCanceled(proposalId);
    }

    function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
        Proposal storage p = proposals[proposalId];
        return (p.targets, p.values, p.signatures, p.calldatas);
    }

    function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {
        return proposals[proposalId].receipts[voter];
    }

    function state(uint proposalId) public view returns (ProposalState) {
        require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");
        Proposal storage proposal = proposals[proposalId];
        if (proposal.canceled) {
            return ProposalState.Canceled;
        } else if (block.number <= proposal.startBlock) {
            return ProposalState.Pending;
        } else if (block.number <= proposal.endBlock) {
            return ProposalState.Active;
        } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {
            return ProposalState.Defeated;
        } else if (proposal.eta == 0) {
            return ProposalState.Succeeded;
        } else if (proposal.executed) {
            return ProposalState.Executed;
        // solhint-disable-next-line not-rely-on-time
        } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
            return ProposalState.Expired;
        } else {
            return ProposalState.Queued;
        }
    }

    function castVote(uint proposalId, bool support) public {
        return _castVote(msg.sender, proposalId, support);
    }

    function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {
        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
        bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");
        return _castVote(signatory, proposalId, support);
    }

    function _castVote(address voter, uint proposalId, bool support) internal {
        require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");
        Proposal storage proposal = proposals[proposalId];
        Receipt storage receipt = proposal.receipts[voter];
        require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");
        uint96 votes = tribe.getPriorVotes(voter, proposal.startBlock);

        if (support) {
            proposal.forVotes = add256(proposal.forVotes, votes);
        } else {
            proposal.againstVotes = add256(proposal.againstVotes, votes);
        }

        receipt.hasVoted = true;
        receipt.support = support;
        receipt.votes = votes;

        emit VoteCast(voter, proposalId, support, votes);
    }

    function __acceptAdmin() public {
        require(msg.sender == guardian, "GovernorAlpha::__acceptAdmin: sender must be gov guardian");
        timelock.acceptAdmin();
    }

    function __abdicate() public {
        require(msg.sender == guardian, "GovernorAlpha::__abdicate: sender must be gov guardian");
        guardian = address(0);
    }

    function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
        require(msg.sender == guardian, "GovernorAlpha::__queueSetTimelockPendingAdmin: sender must be gov guardian");
        timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
    }

    function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
        require(msg.sender == guardian, "GovernorAlpha::__executeSetTimelockPendingAdmin: sender must be gov guardian");
        timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
    }

    function add256(uint256 a, uint256 b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "addition overflow");
        return c;
    }

    function sub256(uint256 a, uint256 b) internal pure returns (uint) {
        require(b <= a, "subtraction underflow");
        return a - b;
    }

    function getChainId() internal pure returns (uint) {
        uint chainId;
        // solhint-disable-next-line no-inline-assembly
        assembly { chainId := chainid() }
        return chainId;
    }
}

interface TimelockInterface {
    function delay() external view returns (uint);
    // solhint-disable-next-line func-name-mixedcase
    function GRACE_PERIOD() external view returns (uint);
    function acceptAdmin() external;
    function queuedTransactions(bytes32 hash) external view returns (bool);
    function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
    function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
    function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
}

interface CompInterface {
    function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
}


// File contracts/fei-protocol/orchestration/GovernanceOrchestrator.sol

pragma solidity ^0.6.0;



contract GovernanceOrchestrator is Ownable {

	function init(address admin, address tribe, uint timelockDelay) public onlyOwner returns (
		address governorAlpha, address timelock
	) {
		timelock = address(new Timelock(admin, timelockDelay));
		governorAlpha = address(new GovernorAlpha(address(timelock), tribe, admin));
		return (governorAlpha, timelock);
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File contracts/fei-protocol/orchestration/IDOOrchestrator.sol

pragma solidity ^0.6.0;



contract IDOOrchestrator is Ownable {

	function init(
		address core, 
		address admin, 
		address tribe, 
		address pair, 
		address router,
		uint32 releaseWindow
	) public onlyOwner returns (
		address ido,
		address timelockedDelegator
	) {
		ido = address(new IDO(core, admin, releaseWindow, pair, router));
		timelockedDelegator = address(new TimelockedDelegator(tribe, admin, releaseWindow));
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File contracts/fei-protocol/token/UniswapIncentive.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;







/// @title IUniswapIncentive implementation
/// @author Fei Protocol
contract UniswapIncentive is IUniswapIncentive, UniRef {
	using Decimal for Decimal.D256;
    using SafeMath32 for uint32;
    using SafeMath for uint;
    using SafeCast for uint;

    struct TimeWeightInfo {
        uint32 blockNo;
        uint32 weight;
        uint32 growthRate;
        bool active;
    }

    TimeWeightInfo private timeWeightInfo;

    uint32 public constant override TIME_WEIGHT_GRANULARITY = 100_000;

    mapping(address => bool) private _exempt;
    mapping(address => bool) private _allowlist;

    /// @notice UniswapIncentive constructor
    /// @param _core Fei Core to reference
    /// @param _oracle Oracle to reference
    /// @param _pair Uniswap Pair to incentivize
    /// @param _router Uniswap Router
	constructor(
        address _core, 
        address _oracle, 
        address _pair, 
        address _router,
        uint32 _growthRate
    ) public UniRef(_core, _pair, _router, _oracle) {
        _setTimeWeight(0, _growthRate, false);    
    }

    function incentivize(
    	address sender, 
    	address receiver, 
    	address operator, 
    	uint amountIn
    ) external override onlyFei {
        updateOracle();

    	if (isPair(sender)) {
    		incentivizeBuy(receiver, amountIn);
    	}

    	if (isPair(receiver)) {
            require(isSellAllowlisted(sender) || isSellAllowlisted(operator), "UniswapIncentive: Blocked Fei sender or operator");
    		incentivizeSell(sender, amountIn);
    	}
    }

    function setExemptAddress(address account, bool isExempt) external override onlyGovernor {
    	_exempt[account] = isExempt;
        emit ExemptAddressUpdate(account, isExempt);
    }

    function setSellAllowlisted(address account, bool isAllowed) external override onlyGovernor {
        _allowlist[account] = isAllowed;
        emit SellAllowedAddressUpdate(account, isAllowed);
    }

    function setTimeWeightGrowth(uint32 growthRate) external override onlyGovernor {
        TimeWeightInfo memory tw = timeWeightInfo;
        timeWeightInfo = TimeWeightInfo(tw.blockNo, tw.weight, growthRate, tw.active);
        emit GrowthRateUpdate(growthRate);
    }

    function setTimeWeight(uint32 weight, uint32 growth, bool active) external override onlyGovernor {
        _setTimeWeight(weight, growth, active);
        // TimeWeightInfo memory tw = timeWeightInfo;
        // timeWeightInfo = TimeWeightInfo(blockNo, tw.weight, tw.growthRate, tw.active);
    }

    function getGrowthRate() public view override returns (uint32) {
        return timeWeightInfo.growthRate;
    }

    function getTimeWeight() public view override returns (uint32) {
        TimeWeightInfo memory tw = timeWeightInfo;
        if (!tw.active) {
            return 0;
        }

        uint32 blockDelta = block.number.toUint32().sub(tw.blockNo);
        return tw.weight.add(blockDelta * tw.growthRate);
    }

    function isTimeWeightActive() public view override returns (bool) {
    	return timeWeightInfo.active;
    }

    function isExemptAddress(address account) public view override returns (bool) {
    	return _exempt[account];
    }

    function isSellAllowlisted(address account) public view override returns(bool) {
        return _allowlist[account];
    }

    function isIncentiveParity() public view override returns (bool) {
        uint32 weight = getTimeWeight();
        require(weight != 0, "UniswapIncentive: Incentive zero or not active");

        (Decimal.D256 memory price,,) = getUniswapPrice();
        Decimal.D256 memory deviation = calculateDeviation(price, peg());
        require(!deviation.equals(Decimal.zero()), "UniswapIncentive: Price already at or above peg");

        Decimal.D256 memory incentive = calculateBuyIncentiveMultiplier(deviation, weight);
        Decimal.D256 memory penalty = calculateSellPenaltyMultiplier(deviation);
        return incentive.equals(penalty);
    }

    function getBuyIncentive(uint amount) public view override returns(
        uint incentive, 
        uint32 weight,
        Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation
    ) {
        (initialDeviation, finalDeviation) = getPriceDeviations(-1 * int256(amount));
        weight = getTimeWeight();

        if (initialDeviation.equals(Decimal.zero())) {
            return (0, weight, initialDeviation, finalDeviation);
        }

        uint incentivizedAmount = amount;
        if (finalDeviation.equals(Decimal.zero())) {
            incentivizedAmount = getAmountToPegFei();
        }

        Decimal.D256 memory multiplier = calculateBuyIncentiveMultiplier(initialDeviation, weight);
        incentive = multiplier.mul(incentivizedAmount).asUint256();
        return (incentive, weight, initialDeviation, finalDeviation);
    }

    function getSellPenalty(uint amount) public view override returns(
        uint penalty, 
        Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation
    ) {
        (initialDeviation, finalDeviation) = getPriceDeviations(int256(amount));

        if (finalDeviation.equals(Decimal.zero())) {
            return (0, initialDeviation, finalDeviation);
        }

        uint incentivizedAmount = amount;
        if (initialDeviation.equals(Decimal.zero())) {
            uint amountToPeg = getAmountToPegFei();
            incentivizedAmount = amount.sub(amountToPeg, "UniswapIncentive: Underflow");
        }

        Decimal.D256 memory multiplier = calculateSellPenaltyMultiplier(finalDeviation); 
        penalty = multiplier.mul(incentivizedAmount).asUint256(); 
        return (penalty, initialDeviation, finalDeviation);   
    }

    function incentivizeBuy(address target, uint amountIn) internal ifMinterSelf {
    	if (isExemptAddress(target)) {
    		return;
    	}

        (uint incentive, uint32 weight,
        Decimal.D256 memory initialDeviation, 
        Decimal.D256 memory finalDeviation) = getBuyIncentive(amountIn);

        updateTimeWeight(initialDeviation, finalDeviation, weight);
        if (incentive != 0) {
            fei().mint(target, incentive);         
        }
    }

    function incentivizeSell(address target, uint amount) internal ifBurnerSelf {
    	if (isExemptAddress(target)) {
    		return;
    	}

        (uint penalty, Decimal.D256 memory initialDeviation,
        Decimal.D256 memory finalDeviation) = getSellPenalty(amount);

        uint32 weight = getTimeWeight();
        updateTimeWeight(initialDeviation, finalDeviation, weight);

        if (penalty != 0) {
            fei().burnFrom(target, penalty);
        }
    }

    function calculateBuyIncentiveMultiplier(
        Decimal.D256 memory deviation,
        uint32 weight
    ) internal pure returns (Decimal.D256 memory) {
        Decimal.D256 memory correspondingPenalty = calculateSellPenaltyMultiplier(deviation);
        Decimal.D256 memory buyMultiplier = deviation.mul(uint(weight)).div(uint(TIME_WEIGHT_GRANULARITY));
        
        if (correspondingPenalty.lessThan(buyMultiplier)) {
            return correspondingPenalty;
        }
        
        return buyMultiplier;
    }

    function calculateSellPenaltyMultiplier(
        Decimal.D256 memory deviation
    ) internal pure returns (Decimal.D256 memory) {
        return deviation.mul(deviation).mul(100); // m^2 * 100
    }

    function updateTimeWeight (
        Decimal.D256 memory initialDeviation, 
        Decimal.D256 memory finalDeviation, 
        uint32 currentWeight
    ) internal {
        // Reset after completion
        if (finalDeviation.equals(Decimal.zero())) {
            _setTimeWeight(0, getGrowthRate(), false);
            return;
        } 
        // Init
        if (initialDeviation.equals(Decimal.zero())) {
            _setTimeWeight(0, getGrowthRate(), true);
            return;
        }

        uint updatedWeight = uint(currentWeight);
        // Partial buy
        if (initialDeviation.greaterThan(finalDeviation)) {
            Decimal.D256 memory remainingRatio = finalDeviation.div(initialDeviation);
            updatedWeight = remainingRatio.mul(uint(currentWeight)).asUint256();
        }
        
        uint maxWeight = finalDeviation.mul(100).mul(uint(TIME_WEIGHT_GRANULARITY)).asUint256(); // m^2*100 (sell) = t*m (buy) 
        updatedWeight = Math.min(updatedWeight, maxWeight);
        _setTimeWeight(updatedWeight.toUint32(), getGrowthRate(), true);
    }

    function _setTimeWeight(uint32 weight, uint32 growthRate, bool active) internal {
        uint32 currentGrowth = getGrowthRate();

        uint32 blockNo = block.number.toUint32();

        timeWeightInfo = TimeWeightInfo(blockNo, weight, growthRate, active);

        emit TimeWeightUpdate(weight, active);   
        if (currentGrowth != growthRate) {
            emit GrowthRateUpdate(growthRate);
        }
    }
}


// File contracts/fei-protocol/orchestration/IncentiveOrchestrator.sol

pragma solidity ^0.6.0;


contract IncentiveOrchestrator is Ownable {

	UniswapIncentive public uniswapIncentive;


	function init(
		address core,
		address bondingCurveOracle, 
		address pair, 
		address router,
		uint32 growthRate
	) public onlyOwner returns(address) {
		return address(new UniswapIncentive(core, bondingCurveOracle, pair, router, growthRate));
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File contracts/fei-protocol/pcv/UniswapPCVDeposit.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;




/// @title abstract implementation for Uniswap LP PCV Deposit
/// @author Fei Protocol
abstract contract UniswapPCVDeposit is IPCVDeposit, UniRef {
	using Decimal for Decimal.D256;

	/// @notice Uniswap PCV Deposit constructor
	/// @param _core Fei Core for reference
	/// @param _pair Uniswap Pair to deposit to
	/// @param _router Uniswap Router
	/// @param _oracle oracle for reference
	constructor(
		address _core, 
		address _pair, 
		address _router, 
		address _oracle
	) public UniRef(_core, _pair, _router, _oracle) {}

	function withdraw(address to, uint amountUnderlying) external override onlyPCVController {
    	uint totalUnderlying = totalValue();
    	require(amountUnderlying <= totalUnderlying, "UniswapPCVDeposit: Insufficient underlying");

    	uint totalLiquidity = liquidityOwned();
    	Decimal.D256 memory ratioToWithdraw = Decimal.ratio(amountUnderlying, totalUnderlying);
    	uint liquidityToWithdraw = ratioToWithdraw.mul(totalLiquidity).asUint256();

    	uint amountWithdrawn = _removeLiquidity(liquidityToWithdraw);
		
    	_transferWithdrawn(to, amountWithdrawn);
		
    	_burnFeiHeld();

    	emit Withdrawal(msg.sender, to, amountWithdrawn);
    }

	function totalValue() public view override returns(uint) {
		(, uint tokenReserves) = getReserves();
    	return ratioOwned().mul(tokenReserves).asUint256();
    }

	function _getAmountFeiToDeposit(uint amountToken) internal view returns (uint amountFei) {
		(uint feiReserves, uint tokenReserves) = getReserves();
		if (feiReserves == 0 || tokenReserves == 0) {
			return peg().mul(amountToken).asUint256();
		}
		return UniswapV2Library.quote(amountToken, tokenReserves, feiReserves);
	}

    function _removeLiquidity(uint amount) internal virtual returns(uint);

    function _transferWithdrawn(address to, uint amount) internal virtual;

}


// File contracts/fei-protocol/pcv/EthUniswapPCVDeposit.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title implementation for an ETH Uniswap LP PCV Deposit
/// @author Fei Protocol
contract EthUniswapPCVDeposit is UniswapPCVDeposit {
    using Address for address payable;

	/// @notice ETH Uniswap PCV Deposit constructor
	/// @param _core Fei Core for reference
	/// @param _pair Uniswap Pair to deposit to
	/// @param _router Uniswap Router
	/// @param _oracle oracle for reference
    constructor(
        address _core, 
        address _pair, 
        address _router, 
        address _oracle
    ) public UniswapPCVDeposit(_core, _pair, _router, _oracle) {}

    receive() external payable {}

    function deposit(uint ethAmount) external override payable postGenesis {
    	require(ethAmount == msg.value, "Bonding Curve: Sent value does not equal input");
        
        uint feiAmount = _getAmountFeiToDeposit(ethAmount);

        _addLiquidity(ethAmount, feiAmount);

        emit Deposit(msg.sender, ethAmount);
    }

    function _removeLiquidity(uint liquidity) internal override returns (uint) {
        (, uint amountWithdrawn) = router.removeLiquidityETH(
            address(fei()),
            liquidity,
            0,
            0,
            address(this),
            uint(-1)
        );
        return amountWithdrawn;
    }

    function _transferWithdrawn(address to, uint amount) internal override {
        payable(to).sendValue(amount);
    }

    function _addLiquidity(uint ethAmount, uint feiAmount) internal {
        _mintFei(feiAmount);
        
        router.addLiquidityETH{value : ethAmount}(address(fei()),
            feiAmount,
            0,
            0,
            address(this),
            uint(-1)
        );
    }
}


// File contracts/fei-protocol/orchestration/PCVDepositOrchestrator.sol

pragma solidity ^0.6.0;



contract PCVDepositOrchestrator is Ownable {

	function init(
		address core, 
		address pair, 
		address router,
		address oraclePair,
		uint32 twapDuration,
		bool price0
	) public onlyOwner returns(
		address ethUniswapPCVDeposit,
		address uniswapOracle
	) {
		uniswapOracle = address(new UniswapOracle(core, 
			oraclePair, 
			twapDuration, 
			price0
		));
		ethUniswapPCVDeposit = address(new EthUniswapPCVDeposit(core, pair, router, uniswapOracle));

		return (
			ethUniswapPCVDeposit,
			uniswapOracle
		);
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File @uniswap/lib/contracts/libraries/TransferHelper.sol@v4.0.1-alpha

// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.6.0;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeApprove: approve failed'
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeTransfer: transfer failed'
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::transferFrom: transferFrom failed'
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
    }
}


// File contracts/fei-protocol/router/IUniswapSingleEthRouter.sol

pragma solidity ^0.6.0;

/// @title A Uniswap Router for token/ETH swaps
/// @author Fei Protocol
interface IUniswapSingleEthRouter {

    // ----------- state changing api -----------

    /// @notice swap ETH for tokens with some protections
    /// @param amountOutMin minimum tokens received
    /// @param to address to send tokens
    /// @param deadline block timestamp after which trade is invalid
    /// @return amountOut the amount of tokens received
    function swapExactETHForTokens(
        uint amountOutMin, 
        address to, 
        uint deadline
    ) external payable returns(uint amountOut);

    /// @notice swap tokens for ETH with some protections
    /// @param amountIn amount of tokens to sell
    /// @param amountOutMin minimum ETH received
    /// @param to address to send ETH
    /// @param deadline block timestamp after which trade is invalid
    /// @return amountOut the amount of ETH received
    function swapExactTokensForETH(
        uint amountIn, 
        uint amountOutMin, 
        address to, 
        uint deadline
    ) external returns (uint amountOut);
}


// File contracts/fei-protocol/router/UniswapSingleEthRouter.sol

pragma solidity ^0.6.0;




contract UniswapSingleEthRouter is IUniswapSingleEthRouter {
	IWETH public immutable WETH;
	IUniswapV2Pair public immutable PAIR;

	constructor(
		address pair, 
		address weth
	) public {
        PAIR = IUniswapV2Pair(pair);
		WETH = IWETH(weth);
	}

    receive() external payable {
        assert(msg.sender == address(WETH)); // only accept ETH via fallback from the WETH contract
    }

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'UniswapSingleEthRouter: EXPIRED');
        _;
    }

    function _getReserves() internal view returns(uint reservesETH, uint reservesOther, bool isETH0) {
        (uint reserves0, uint reserves1, ) = PAIR.getReserves();
        isETH0 = PAIR.token0() == address(WETH);
        return isETH0 ? (reserves0, reserves1, isETH0) : (reserves1, reserves0, isETH0);
    }

    function swapExactETHForTokens(uint amountOutMin, address to, uint deadline)
        public
        payable
        override
        ensure(deadline)
        returns (uint amountOut)
    {
        (uint reservesETH, uint reservesOther, bool isETH0) = _getReserves();

        uint amountIn = msg.value;
        amountOut = UniswapV2Library.getAmountOut(amountIn, reservesETH, reservesOther);
        require(amountOut >= amountOutMin, 'UniswapSingleEthRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        IWETH(WETH).deposit{value: amountIn}();
        assert(IWETH(WETH).transfer(address(PAIR), amountIn));

        (uint amount0Out, uint amount1Out) = isETH0 ? (uint(0), amountOut) : (amountOut, uint(0));
        PAIR.swap(amount0Out, amount1Out, to, new bytes(0));
    }

	function swapExactTokensForETH(uint amountIn, uint amountOutMin, address to, uint deadline)
        public
        override
        ensure(deadline)
        returns (uint amountOut)
    {
        (uint reservesETH, uint reservesOther, bool isETH0) = _getReserves();
        amountOut = UniswapV2Library.getAmountOut(amountIn, reservesOther, reservesETH);

        require(amountOut >= amountOutMin, 'UniswapSingleEthRouter: INSUFFICIENT_OUTPUT_AMOUNT');

        address token = isETH0 ? PAIR.token1() : PAIR.token0();
        TransferHelper.safeTransferFrom(
            token, msg.sender, address(PAIR), amountIn
        );

        (uint amount0Out, uint amount1Out) = isETH0 ? (amountOut, uint(0)) : (uint(0), amountOut);
        PAIR.swap(amount0Out, amount1Out, address(this), new bytes(0));

        IWETH(WETH).withdraw(amountOut);

        TransferHelper.safeTransferETH(to, amountOut);
    }
}


// File contracts/fei-protocol/router/IFeiRouter.sol

pragma solidity ^0.6.0;

/// @title A Uniswap Router for FEI/ETH swaps
/// @author Fei Protocol
interface IFeiRouter {

    // ----------- state changing api -----------

    /// @notice buy FEI for ETH with some protections
    /// @param minReward minimum mint reward for purchasing
    /// @param amountOutMin minimum FEI received
    /// @param to address to send FEI
    /// @param deadline block timestamp after which trade is invalid
    function buyFei(
        uint minReward, 
        uint amountOutMin, 
        address to, 
        uint deadline
    ) external payable returns(uint amountOut);

    /// @notice sell FEI for ETH with some protections
    /// @param maxPenalty maximum fei burn for purchasing
    /// @param amountIn amount of FEI to sell
    /// @param amountOutMin minimum ETH received
    /// @param to address to send ETH
    /// @param deadline block timestamp after which trade is invalid
    function sellFei(
        uint maxPenalty, 
        uint amountIn, 
        uint amountOutMin, 
        address to, 
        uint deadline
    ) external returns(uint amountOut);
}


// File contracts/fei-protocol/router/FeiRouter.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;




contract FeiRouter is UniswapSingleEthRouter, IFeiRouter {

	IUniswapIncentive public immutable INCENTIVE;

	constructor(
		address pair, 
		address weth,
		address incentive
	) public UniswapSingleEthRouter(pair, weth) {
		INCENTIVE = IUniswapIncentive(incentive);
	}

	function buyFei(
		uint minReward, 
		uint amountOutMin, 
		address to, 
		uint deadline
	) external payable override returns(uint amountOut) {
		IOracleRef(address(INCENTIVE)).updateOracle();

		uint reward = 0;
		if (!INCENTIVE.isExemptAddress(to)) {
			(reward,,,) = INCENTIVE.getBuyIncentive(amountOutMin);
		}
		require(reward >= minReward, "FeiRouter: Not enough reward");
		return swapExactETHForTokens(amountOutMin, to, deadline);
	}

	function sellFei(
		uint maxPenalty, 
		uint amountIn, 
		uint amountOutMin, 
		address to, 
		uint deadline
	) external override returns(uint amountOut) {
		IOracleRef(address(INCENTIVE)).updateOracle();

		uint penalty = 0;
		if (!INCENTIVE.isExemptAddress(to)) {
			(penalty,,) = INCENTIVE.getSellPenalty(amountIn);
		}
		require(penalty <= maxPenalty, "FeiRouter: Penalty too high");
		return swapExactTokensForETH(amountIn, amountOutMin, to, deadline);
	}
}


// File contracts/fei-protocol/orchestration/RouterOrchestrator.sol

pragma solidity ^0.6.0;


contract RouterOrchestrator is Ownable {

	function init(
		address pair, 
		address weth,
		address incentive
	) public onlyOwner returns(address ethRouter) {
		
		ethRouter = address(new FeiRouter(pair, 
			weth, 
			incentive
		));

		return ethRouter;
	}

	function detonate() public onlyOwner {
		selfdestruct(payable(owner()));
	}
}


// File contracts/fei-protocol/flat.sol




// File contracts/fei-protocol/Migrations.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
