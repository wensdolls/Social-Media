# Social Media Platform Smart Contract

A decentralized social media platform built on the Stacks blockchain using Clarity smart contracts. This contract enables basic social media functionality including user profiles, post creation, and post interactions.

## Features

- **User Management**
    - Create user profiles with username, display name, and bio
    - Username uniqueness verification
    - Profile information stored on-chain

- **Post System**
    - Create posts with content up to 1000 characters
    - Automatic post ID assignment
    - Like system for post engagement

- **Administrative Controls**
    - Contract owner management
    - Built-in security checks

## Contract Structure

### Constants
```clarity
contract-owner    : Principal who owns the contract
err-owner-only    : Error code for unauthorized owner actions (u100)
err-not-found     : Error code for non-existent resources (u101)
err-unauthorized  : Error code for unauthorized access (u102)
err-already-exists: Error code for duplicate resources (u103)
```

### Data Maps
- **Users Map**
  ```clarity
  users: { username: (string-ascii 20) } -> {
    address: principal,
    display-name: (string-utf8 50),
    bio: (string-utf8 280)
  }
  ```

- **Posts Map**
  ```clarity
  posts: { post-id: uint } -> {
    author: principal,
    content: (string-utf8 1000),
    likes: uint
  }
  ```

## Public Functions

### User Management

#### create-user
Creates a new user profile
```clarity
(define-public (create-user (username (string-ascii 20)) 
                          (display-name (string-utf8 50)) 
                          (bio (string-utf8 280)))
```
- **Parameters**
    - `username`: Unique identifier for the user (max 20 ASCII characters)
    - `display-name`: User's display name (max 50 UTF-8 characters)
    - `bio`: User's biography (max 280 UTF-8 characters)
- **Returns**: `(ok true)` if successful, `(err err-already-exists)` if username taken

### Post Management

#### create-post
Creates a new post
```clarity
(define-public (create-post (content (string-utf8 1000))))
```
- **Parameters**
    - `content`: Post content (max 1000 UTF-8 characters)
- **Returns**: `(ok uint)` with the post ID if successful

#### like-post
Likes a specific post
```clarity
(define-public (like-post (post-id uint)))
```
- **Parameters**
    - `post-id`: ID of the post to like
- **Returns**: `(ok true)` if successful, `(err err-not-found)` if post doesn't exist

## Read-Only Functions

### get-user
Retrieves user information
```clarity
(define-read-only (get-user (username (string-ascii 20))))
```
- **Parameters**
    - `username`: Username to look up
- **Returns**: User data or none if not found

### get-post
Retrieves post information
```clarity
(define-read-only (get-post (post-id uint)))
```
- **Parameters**
    - `post-id`: Post ID to look up
- **Returns**: Post data or none if not found

## Administrative Functions

### update-contract-owner
Updates the contract owner (restricted to current owner)
```clarity
(define-public (update-contract-owner (new-owner principal)))
```
- **Parameters**
    - `new-owner`: Principal of the new contract owner
- **Returns**: `(ok true)` if successful, `(err err-owner-only)` if not authorized

## Development Setup

1. Install [Clarinet](https://github.com/hirosystems/clarinet)
2. Clone this repository
3. Run tests:
   ```bash
   clarinet test
   ```

## Security Considerations

- All functions include appropriate access controls
- User uniqueness is enforced at the contract level
- Post creation and interactions are tracked and verified
- Administrative functions are restricted to contract owner

## License

[Add your chosen license here]

## Contributing

[Add contribution guidelines here]
