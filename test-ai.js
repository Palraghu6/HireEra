const http = require('http');

function post(path, data, token) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify(data);
    const opts = {
      hostname: 'localhost', port: 4000, path, method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
    };
    if (token) opts.headers['Authorization'] = `Bearer ${token}`;
    const req = http.request(opts, res => {
      let chunks = '';
      res.on('data', d => chunks += d);
      res.on('end', () => {
        try { resolve(JSON.parse(chunks)); }
        catch { resolve({ success: false, raw: chunks }); }
      });
    });
    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

async function main() {
  console.log('🔐 Logging in...');
  const auth = await post('/api/auth/login', { email: 'seeker@hireera.com', password: 'password123' });
  const token = auth.data.accessToken;
  console.log('✅ Logged in\n');

  const tests = [
    ['1. AI Chat', '/api/ai/chat', { messages: [{ role: 'user', content: 'Hi, what jobs should I look for?' }] }],
    ['2. Resume Improve', '/api/ai/resume/improve-summary', { summary: 'Developer with React experience', targetRole: 'Frontend Dev' }],
    ['3. Suggest Skills', '/api/ai/resume/suggest-skills', { jobTitle: 'React Developer', existingSkills: ['React'] }],
    ['4. Match Job', '/api/ai/resume/match-job', { resumeData: { skills: ['React', 'Node'], headline: 'Frontend Dev' }, jobDescription: 'Senior React Developer with 5 years experience in TypeScript' }],
    ['5. ATS Check', '/api/ai/resume/ats-check', { resumeData: { personalInfo: { name: 'Test' }, summary: 'Dev', skills: ['React'], experience: [] } }],
    ['6. Rank Candidates', '/api/ai/recruiter/rank-candidates', { jobDescription: 'React Developer', candidates: [{ userId: '1', skills: ['React'], headline: 'Dev' }] }],
    ['7. Screen Resume', '/api/ai/recruiter/screen-resume', { resumeData: { skills: ['React', 'Node'], headline: 'Senior Dev', summary: '5 years exp' }, jobDescription: 'React Developer needed' }],
    ['8. Generate JD', '/api/ai/recruiter/generate-job-description', { role: 'React Developer', experienceLevel: 'Senior', skills: ['React', 'TypeScript'] }],
    ['9. Interview Qs', '/api/ai/recruiter/interview-questions', { jobTitle: 'React Dev', skills: ['React', 'TS'] }],
  ];

  for (const [name, path, data] of tests) {
    process.stdout.write(`${name}... `);
    try {
      const res = await post(path, data, token);
      if (res.success) {
        const preview = JSON.stringify(res.data).substring(0, 120);
        console.log(`✅ ${preview}...`);
      } else {
        console.log(`❌ ${res.message || 'Failed'}`);
      }
    } catch (e) {
      console.log(`❌ Error: ${e.message}`);
    }
    await sleep(3000); // respect rate limits
  }

  console.log('\n🏁 All 9 endpoints tested!');
}

main().catch(console.error);
