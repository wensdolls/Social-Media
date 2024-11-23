import { describe, it, expect, beforeEach } from 'vitest';

// Mock the Clarity contract functions
const mockContract = {
  users: new Map(),
  posts: new Map(),
  nextPostId: 0,
  createUser: (username: string, displayName: string, bio: string) => {
    if (mockContract.users.has(username)) {
      return { err: 103 }; // err-already-exists
    }
    mockContract.users.set(username, { address: 'mock-address', displayName, bio });
    return { ok: true };
  },
  createPost: (content: string) => {
    const postId = mockContract.nextPostId++;
    mockContract.posts.set(postId, { author: 'mock-address', content, likes: 0 });
    return { ok: postId };
  },
  likePost: (postId: number) => {
    const post = mockContract.posts.get(postId);
    if (!post) {
      return { err: 101 }; // err-not-found
    }
    post.likes++;
    return { ok: true };
  },
  getUser: (username: string) => mockContract.users.get(username) || null,
  getPost: (postId: number) => mockContract.posts.get(postId) || null,
};

describe('social-media-platform', () => {
  beforeEach(() => {
    mockContract.users.clear();
    mockContract.posts.clear();
    mockContract.nextPostId = 0;
  });
  
  it('allows a user to create a profile', () => {
    const result = mockContract.createUser('alice', 'Alice', 'I love blockchain!');
    expect(result).toEqual({ ok: true });
    expect(mockContract.getUser('alice')).toEqual({
      address: 'mock-address',
      displayName: 'Alice',
      bio: 'I love blockchain!',
    });
  });
  
  it('prevents creating a user with an existing username', () => {
    mockContract.createUser('bob', 'Bob', 'Blockchain enthusiast');
    const result = mockContract.createUser('bob', 'Another Bob', 'Duplicate username');
    expect(result).toEqual({ err: 103 }); // err-already-exists
  });
  
  it('allows a user to create a post', () => {
    const result = mockContract.createPost('Hello, Stacks!');
    expect(result).toEqual({ ok: 0 });
    expect(mockContract.getPost(0)).toEqual({
      author: 'mock-address',
      content: 'Hello, Stacks!',
      likes: 0,
    });
  });
  
  it('allows a user to like a post', () => {
    mockContract.createPost('Stacks is awesome!');
    const result = mockContract.likePost(0);
    expect(result).toEqual({ ok: true });
    expect(mockContract.getPost(0)?.likes).toBe(1);
  });
  
  it('returns an error when liking a non-existent post', () => {
    const result = mockContract.likePost(999);
    expect(result).toEqual({ err: 101 }); // err-not-found
  });
});

