const request = require('supertest');
const server = require('../index');

describe('GET /', () => {
  it('responds with Hello Node!', async () => {
    const res = await request(server).get('/');
    expect(res.status).toBe(200);
    expect(res.text).toBe('Hello Node!\n');
  });
});