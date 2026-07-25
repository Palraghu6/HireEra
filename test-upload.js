const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

async function test() {
  try {
    // 1. Login
    const loginRes = await axios.post('http://localhost:4000/api/auth/login', {
      email: 'seeker@hireera.com',
      password: 'password123'
    });
    const token = loginRes.data.data.accessToken;

    // 2. Upload
    const form = new FormData();
    form.append('avatar', fs.createReadStream('dummy.png'));

    const uploadRes = await axios.post('http://localhost:4000/api/profile/me/avatar', form, {
      headers: {
        ...form.getHeaders(),
        Authorization: `Bearer ${token}`
      }
    });
    console.log('Upload success:', uploadRes.data);
  } catch (err) {
    console.error('Error:', err.response ? err.response.data : err.message);
  }
}
test();
