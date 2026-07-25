--
-- PostgreSQL database dump
--

\restrict vBYZ8qPWuVvxgn1FYHu46hilwCrqvHTJew8mainK78a6mZizgw6SGLNdRedGSaj

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: AppStatus; Type: TYPE; Schema: public; Owner: hireera
--

CREATE TYPE public."AppStatus" AS ENUM (
    'APPLIED',
    'SHORTLISTED',
    'INTERVIEW',
    'REJECTED',
    'HIRED'
);


ALTER TYPE public."AppStatus" OWNER TO hireera;

--
-- Name: ConnStatus; Type: TYPE; Schema: public; Owner: hireera
--

CREATE TYPE public."ConnStatus" AS ENUM (
    'PENDING',
    'ACCEPTED',
    'DECLINED'
);


ALTER TYPE public."ConnStatus" OWNER TO hireera;

--
-- Name: JobStatus; Type: TYPE; Schema: public; Owner: hireera
--

CREATE TYPE public."JobStatus" AS ENUM (
    'OPEN',
    'CLOSED',
    'DRAFT'
);


ALTER TYPE public."JobStatus" OWNER TO hireera;

--
-- Name: JobType; Type: TYPE; Schema: public; Owner: hireera
--

CREATE TYPE public."JobType" AS ENUM (
    'FULL_TIME',
    'PART_TIME',
    'REMOTE',
    'CONTRACT',
    'INTERNSHIP'
);


ALTER TYPE public."JobType" OWNER TO hireera;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: hireera
--

CREATE TYPE public."Role" AS ENUM (
    'SEEKER',
    'RECRUITER',
    'ADMIN'
);


ALTER TYPE public."Role" OWNER TO hireera;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Application; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Application" (
    id text NOT NULL,
    "jobId" text NOT NULL,
    "seekerId" text NOT NULL,
    status public."AppStatus" DEFAULT 'APPLIED'::public."AppStatus" NOT NULL,
    "coverLetter" text,
    "appliedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Application" OWNER TO hireera;

--
-- Name: AuditLog; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."AuditLog" (
    id text NOT NULL,
    "adminId" text NOT NULL,
    action text NOT NULL,
    "targetType" text NOT NULL,
    "targetId" text NOT NULL,
    detail text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."AuditLog" OWNER TO hireera;

--
-- Name: Certification; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Certification" (
    id text NOT NULL,
    "seekerProfileId" text NOT NULL,
    name text NOT NULL,
    issuer text NOT NULL,
    "issueDate" timestamp(3) without time zone,
    "expiryDate" timestamp(3) without time zone,
    "credentialUrl" text
);


ALTER TABLE public."Certification" OWNER TO hireera;

--
-- Name: Comment; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Comment" (
    id text NOT NULL,
    "postId" text NOT NULL,
    "authorId" text NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Comment" OWNER TO hireera;

--
-- Name: Connection; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Connection" (
    id text NOT NULL,
    "requesterId" text NOT NULL,
    "receiverId" text NOT NULL,
    status public."ConnStatus" DEFAULT 'PENDING'::public."ConnStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Connection" OWNER TO hireera;

--
-- Name: Education; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Education" (
    id text NOT NULL,
    "seekerProfileId" text NOT NULL,
    school text NOT NULL,
    degree text NOT NULL,
    field text,
    "startYear" integer NOT NULL,
    "endYear" integer,
    grade text,
    description text
);


ALTER TABLE public."Education" OWNER TO hireera;

--
-- Name: Experience; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Experience" (
    id text NOT NULL,
    "seekerProfileId" text NOT NULL,
    title text NOT NULL,
    company text NOT NULL,
    location text,
    "jobType" public."JobType",
    "startDate" timestamp(3) without time zone NOT NULL,
    "endDate" timestamp(3) without time zone,
    "isCurrent" boolean DEFAULT false NOT NULL,
    description text,
    "order" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Experience" OWNER TO hireera;

--
-- Name: Job; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Job" (
    id text NOT NULL,
    "recruiterId" text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    location text NOT NULL,
    "jobType" public."JobType" NOT NULL,
    "salaryMin" integer,
    "salaryMax" integer,
    skills text[],
    "experienceLevel" text,
    deadline timestamp(3) without time zone,
    status public."JobStatus" DEFAULT 'OPEN'::public."JobStatus" NOT NULL,
    "viewCount" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Job" OWNER TO hireera;

--
-- Name: Message; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    "senderId" text NOT NULL,
    "receiverId" text NOT NULL,
    content text NOT NULL,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Message" OWNER TO hireera;

--
-- Name: Notification; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Notification" (
    id text NOT NULL,
    "userId" text NOT NULL,
    type text NOT NULL,
    message text NOT NULL,
    link text,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Notification" OWNER TO hireera;

--
-- Name: Post; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Post" (
    id text NOT NULL,
    "authorId" text NOT NULL,
    content text NOT NULL,
    "mediaUrl" text,
    "isFlagged" boolean DEFAULT false NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Post" OWNER TO hireera;

--
-- Name: PostLike; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."PostLike" (
    "postId" text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."PostLike" OWNER TO hireera;

--
-- Name: Project; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Project" (
    id text NOT NULL,
    "seekerProfileId" text NOT NULL,
    name text NOT NULL,
    description text,
    url text,
    "techStack" text[],
    "startDate" timestamp(3) without time zone,
    "endDate" timestamp(3) without time zone
);


ALTER TABLE public."Project" OWNER TO hireera;

--
-- Name: RecruiterProfile; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."RecruiterProfile" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "companyName" text NOT NULL,
    "companyLogo" text,
    industry text,
    "companySize" text,
    website text,
    about text,
    location text
);


ALTER TABLE public."RecruiterProfile" OWNER TO hireera;

--
-- Name: RefreshToken; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."RefreshToken" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."RefreshToken" OWNER TO hireera;

--
-- Name: Report; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."Report" (
    id text NOT NULL,
    "reporterId" text NOT NULL,
    "targetType" text NOT NULL,
    "targetId" text NOT NULL,
    "postId" text,
    reason text NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Report" OWNER TO hireera;

--
-- Name: SeekerProfile; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."SeekerProfile" (
    id text NOT NULL,
    "userId" text NOT NULL,
    headline text,
    about text,
    location text,
    phone text,
    website text,
    "linkedinUrl" text,
    "githubUrl" text,
    "resumeUrl" text,
    "resumeData" jsonb,
    "openToWork" boolean DEFAULT false NOT NULL,
    skills text[],
    languages text[],
    "profileCompletion" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."SeekerProfile" OWNER TO hireera;

--
-- Name: User; Type: TABLE; Schema: public; Owner: hireera
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL,
    role public."Role" DEFAULT 'SEEKER'::public."Role" NOT NULL,
    "avatarUrl" text,
    "isVerified" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "isBanned" boolean DEFAULT false NOT NULL,
    "banReason" text,
    "verifyToken" text,
    "resetToken" text,
    "resetExpiry" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."User" OWNER TO hireera;

--
-- Data for Name: Application; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Application" (id, "jobId", "seekerId", status, "coverLetter", "appliedAt", "updatedAt") FROM stdin;
cmphac18d000t10an8adr3lke	cmpha9f6i000p10an5f0rso4g	cmok7y5hg00008zo61np2pv5f	APPLIED	\N	2026-05-22 19:00:51.133	2026-05-22 19:00:51.133
cmphdbow6000s13glx8xxiylp	cmpha9f6i000p10an5f0rso4g	cmphchuyi000213glzjk6l7w4	APPLIED	\N	2026-05-22 20:24:33.971	2026-05-22 20:24:33.971
cmphwqsv60006fugkfti3yfga	cmpha9f6i000p10an5f0rso4g	cmphwlf1g0000fugkbczuke0j	APPLIED	\N	2026-05-23 05:28:11.68	2026-05-23 05:28:11.68
cmpi36ewd00096b6tw5ggpx7r	cmpi3657c00076b6toy4jtchl	cmphwlf1g0000fugkbczuke0j	APPLIED	\N	2026-05-23 08:28:17.773	2026-05-23 08:28:17.773
\.


--
-- Data for Name: AuditLog; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."AuditLog" (id, "adminId", action, "targetType", "targetId", detail, "createdAt") FROM stdin;
\.


--
-- Data for Name: Certification; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Certification" (id, "seekerProfileId", name, issuer, "issueDate", "expiryDate", "credentialUrl") FROM stdin;
\.


--
-- Data for Name: Comment; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Comment" (id, "postId", "authorId", content, "createdAt") FROM stdin;
\.


--
-- Data for Name: Connection; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Connection" (id, "requesterId", "receiverId", status, "createdAt", "updatedAt") FROM stdin;
cmok7y5ne000l8zo6sic7tows	cmok7y5hg00008zo61np2pv5f	cmok7y5j100018zo6ih6nhdds	ACCEPTED	2026-04-29 15:37:40.634	2026-04-29 15:37:40.634
cmoy51uyn000v12z8nzysydyp	cmok7y5hg00008zo61np2pv5f	cmok7y5jh00028zo6jpuyrxyf	PENDING	2026-05-09 09:25:21.023	2026-05-09 09:25:21.023
cmphcigbs000813gl0ao50mw2	cmphchuyi000213glzjk6l7w4	cmok7y5hg00008zo61np2pv5f	PENDING	2026-05-22 20:01:49.865	2026-05-22 20:01:49.865
\.


--
-- Data for Name: Education; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Education" (id, "seekerProfileId", school, degree, field, "startYear", "endYear", grade, description) FROM stdin;
seed-edu-1	cmok7y5jx00048zo6y6cq4pix	VTU Bengaluru	B.E. Computer Science	Computer Science	2015	2019	\N	\N
\.


--
-- Data for Name: Experience; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Experience" (id, "seekerProfileId", title, company, location, "jobType", "startDate", "endDate", "isCurrent", description, "order") FROM stdin;
seed-exp-1	cmok7y5jx00048zo6y6cq4pix	Senior Frontend Developer	Infosys Ltd.	Bengaluru	FULL_TIME	2021-01-01 00:00:00	\N	t	Led frontend architecture for enterprise SaaS products.	0
\.


--
-- Data for Name: Job; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Job" (id, "recruiterId", title, description, location, "jobType", "salaryMin", "salaryMax", skills, "experienceLevel", deadline, status, "viewCount", "createdAt", "updatedAt") FROM stdin;
cmpi34y8h00056b6td35eppgh	cmok7y5lj00068zo668esvn9j	Senior djha	UYUQHQIJOK	bangalore	FULL_TIME	80000	1500000	{JAVA}	MID	2026-05-17 00:00:00	OPEN	0	2026-05-23 08:27:09.521	2026-05-23 08:27:09.521
cmpi3657c00076b6toy4jtchl	cmok7y5lj00068zo668esvn9j	JGUGHUHIHI	uyuyuhuutguu	BHUHI	FULL_TIME	8890	88876	{java}	MID	2026-05-31 00:00:00	OPEN	0	2026-05-23 08:28:05.208	2026-05-23 08:28:05.208
cmpha9f6i000p10an5f0rso4g	cmok7y5lj00068zo668esvn9j	Senior Development	Need a hardworking employee	NYC	FULL_TIME	15000	5000	{JAVA}	MID	2026-05-27 00:00:00	OPEN	3	2026-05-22 18:58:49.172	2026-05-22 19:10:53.842
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Message" (id, "senderId", "receiverId", content, "isRead", "createdAt") FROM stdin;
cmphbkkmn001n10ane93e47v8	cmok7y5j100018zo6ih6nhdds	cmok7y5hg00008zo61np2pv5f	Hi	t	2026-05-22 19:35:29.136
cmphblfz2001t10an099ik4sn	cmok7y5hg00008zo61np2pv5f	cmok7y5j100018zo6ih6nhdds	Hello	t	2026-05-22 19:36:09.759
cmphbo5bo001v10anrnpkyd21	cmok7y5j100018zo6ih6nhdds	cmok7y5hg00008zo61np2pv5f	Hi ma'am	t	2026-05-22 19:38:15.922
cmphbobr4001x10anvecivixq	cmok7y5hg00008zo61np2pv5f	cmok7y5j100018zo6ih6nhdds	Hello	t	2026-05-22 19:38:24.256
cmphdc45c000w13glgkbpsiff	cmok7y5j100018zo6ih6nhdds	cmphchuyi000213glzjk6l7w4	Hi	t	2026-05-22 20:24:53.761
cmphws4sn000cfugkb2tyul42	cmok7y5j100018zo6ih6nhdds	cmphwlf1g0000fugkbczuke0j	Hiiii	t	2026-05-23 05:29:13.799
cmphx4xkj000kfugka76v3pf7	cmok7y5j100018zo6ih6nhdds	cmphwlf1g0000fugkbczuke0j	hELLLOOO	t	2026-05-23 05:39:10.963
cmpi36q2e000d6b6tqwlmx7sq	cmok7y5j100018zo6ih6nhdds	cmphwlf1g0000fugkbczuke0j	HIiii	t	2026-05-23 08:28:32.246
cmphdcaea000y13gliw7f6pgh	cmphchuyi000213glzjk6l7w4	cmok7y5j100018zo6ih6nhdds	Hello	t	2026-05-22 20:25:01.858
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Notification" (id, "userId", type, message, link, "isRead", "createdAt") FROM stdin;
cmoy51v0q000x12z8wxqdxp5c	cmok7y5jh00028zo6jpuyrxyf	CONNECTION_REQUEST	Jane Smith sent you a connection request	/network	f	2026-05-09 09:25:21.097
cmp8cnzzn000wfgxcl7rqzq50	cmok7y5hg00008zo61np2pv5f	APPLICATION_UPDATE	Your application for Senior React Developer was shortlisted! 🎉	\N	f	2026-05-16 12:56:13.043
cmp8cnzzn000xfgxcisl3qafi	cmok7y5hg00008zo61np2pv5f	CONNECTION_REQUEST	Alex Kumar accepted your connection request.	\N	f	2026-05-16 12:56:13.043
cmp8cnzzn000yfgxcwft1gz1i	cmok7y5hg00008zo61np2pv5f	JOB_MATCH	New job match: Node.js Backend Engineer at TechCorp Solutions	\N	f	2026-05-16 12:56:13.043
cmp8cnzzn000zfgxczg3bue7a	cmok7y5hg00008zo61np2pv5f	POST_LIKE	Alex Kumar liked your post about TypeScript.	\N	f	2026-05-16 12:56:13.043
cmpfrfv3t00051qbw8bslu9hc	cmok7y5j100018zo6ih6nhdds	JOB_APPLICATION	Jane Smith applied for Internship — Full Stack	/recruiter/jobs/cmp8bnfkm000g110t5y7ieqx3/applicants	f	2026-05-21 17:24:10.937
cmph6x0oe000910anpo9naqk4	cmok7y5hg00008zo61np2pv5f	CONNECTION_REQUEST	Raghu Paul sent you a connection request	/network	f	2026-05-22 17:25:11.726
cmphac1gm000v10an56olkcxb	cmok7y5j100018zo6ih6nhdds	JOB_APPLICATION	Jane Smith applied for Senior Development	/recruiter/jobs/cmpha9f6i000p10an5f0rso4g/applicants	f	2026-05-22 19:00:51.33
cmphbkkpw001p10an8kw7cfjm	cmok7y5hg00008zo61np2pv5f	NEW_MESSAGE	Alex Kumar sent you a message	/messages/cmok7y5j100018zo6ih6nhdds	f	2026-05-22 19:35:29.198
cmphcigdr000a13glphxs6g21	cmok7y5hg00008zo61np2pv5f	CONNECTION_REQUEST	Raghu Paul sent you a connection request	/network	f	2026-05-22 20:01:49.935
cmphdbozf000u13glwa9wzxlz	cmok7y5j100018zo6ih6nhdds	JOB_APPLICATION	Raghu Paul applied for Senior Development	/recruiter/jobs/cmpha9f6i000p10an5f0rso4g/applicants	f	2026-05-22 20:24:34.079
cmphe6bs5001513gl7g16dxnc	cmok7y5hg00008zo61np2pv5f	NEW_POST	Alex Kumar shared a new post	/feed	f	2026-05-22 20:48:23.048
cmphef1k5001f13glpx30ag1c	cmok7y5j100018zo6ih6nhdds	POST_LIKED	Jane Smith liked your post	/feed	f	2026-05-22 20:55:09.936
cmphef2lk001h13glwff4fxao	cmok7y5j100018zo6ih6nhdds	POST_LIKED	Jane Smith liked your post	/feed	f	2026-05-22 20:55:11.336
cmphwqt5n0008fugkqj387kez	cmok7y5j100018zo6ih6nhdds	JOB_APPLICATION	Raghu Paul applied for Senior Development	/recruiter/jobs/cmpha9f6i000p10an5f0rso4g/applicants	f	2026-05-23 05:28:11.975
cmphws4vg000efugknvdz2xnc	cmphwlf1g0000fugkbczuke0j	NEW_MESSAGE	Alex Kumar sent you a message	/messages/cmok7y5j100018zo6ih6nhdds	f	2026-05-23 05:29:13.894
cmphx4xnj000mfugku3tz8hcr	cmphwlf1g0000fugkbczuke0j	NEW_MESSAGE	Alex Kumar sent you a message	/messages/cmok7y5j100018zo6ih6nhdds	f	2026-05-23 05:39:11.013
cmpi36ezm000b6b6tqi5y1nul	cmok7y5j100018zo6ih6nhdds	JOB_APPLICATION	Raghu Paul applied for JGUGHUHIHI	/recruiter/jobs/cmpi3657c00076b6toy4jtchl/applicants	f	2026-05-23 08:28:17.89
cmpi36q3u000f6b6t1monsbdf	cmphwlf1g0000fugkbczuke0j	NEW_MESSAGE	Alex Kumar sent you a message	/messages/cmok7y5j100018zo6ih6nhdds	f	2026-05-23 08:28:32.298
cmpi37qw6000i6b6twik0t3ju	cmok7y5hg00008zo61np2pv5f	NEW_POST	Alex Kumar shared a new post	/feed	f	2026-05-23 08:29:19.972
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Post" (id, "authorId", content, "mediaUrl", "isFlagged", "isDeleted", "createdAt", "updatedAt") FROM stdin;
cmok7y5mz000h8zo6owat5t3u	cmok7y5hg00008zo61np2pv5f	🚀 Excited to share that I just completed a full-stack project using React + Node.js + PostgreSQL! Always learning. #OpenToWork #ReactJS	\N	f	f	2026-04-29 15:37:40.62	2026-04-29 15:37:40.62
cmok7y5mz000i8zo67e7ezqt9	cmok7y5j100018zo6ih6nhdds	📢 We are hiring! TechCorp Solutions is looking for talented developers. Check out our open positions on HireEra!	\N	f	f	2026-04-29 15:37:40.62	2026-04-29 15:37:40.62
cmok7y5mz000j8zo6n6c9n1gb	cmok7y5hg00008zo61np2pv5f	TypeScript has completely changed how I write JavaScript. The type safety alone saves hours of debugging. Highly recommend the switch! 💡	\N	f	f	2026-04-29 15:37:40.62	2026-04-29 15:37:40.62
cmoy4d038000hfi5ocqwfzjox	cmok7y5hg00008zo61np2pv5f	🚀 Excited to share that I just completed a full-stack project using React + Node.js + PostgreSQL! Always learning. #OpenToWork #ReactJS	\N	f	f	2026-05-09 09:06:01.268	2026-05-09 09:06:01.268
cmoy4d038000ifi5o5vndrh4g	cmok7y5j100018zo6ih6nhdds	📢 We are hiring! TechCorp Solutions is looking for talented developers. Check out our open positions on HireEra!	\N	f	f	2026-05-09 09:06:01.268	2026-05-09 09:06:01.268
cmoy4d038000jfi5ol521s5ba	cmok7y5hg00008zo61np2pv5f	TypeScript has completely changed how I write JavaScript. The type safety alone saves hours of debugging. Highly recommend the switch! 💡	\N	f	f	2026-05-09 09:06:01.268	2026-05-09 09:06:01.268
cmp8bl549000h147e5o2p2wkj	cmok7y5hg00008zo61np2pv5f	🚀 Excited to share that I just completed a full-stack project using React + Node.js + PostgreSQL! Always learning. #OpenToWork #ReactJS	\N	f	f	2026-05-16 12:26:00.105	2026-05-16 12:26:00.105
cmp8bl549000i147ezezue7ne	cmok7y5j100018zo6ih6nhdds	📢 We are hiring! TechCorp Solutions is looking for talented developers. Check out our open positions on HireEra!	\N	f	f	2026-05-16 12:26:00.105	2026-05-16 12:26:00.105
cmp8bl549000j147ek03wm3hx	cmok7y5hg00008zo61np2pv5f	TypeScript has completely changed how I write JavaScript. The type safety alone saves hours of debugging. Highly recommend the switch! 💡	\N	f	f	2026-05-16 12:26:00.105	2026-05-16 12:26:00.105
cmp8bnfks000h110th8rheedx	cmok7y5hg00008zo61np2pv5f	🚀 Excited to share that I just completed a full-stack project using React + Node.js + PostgreSQL! Always learning. #OpenToWork #ReactJS	\N	f	f	2026-05-16 12:27:46.973	2026-05-16 12:27:46.973
cmp8bnfks000i110tgmawrhth	cmok7y5j100018zo6ih6nhdds	📢 We are hiring! TechCorp Solutions is looking for talented developers. Check out our open positions on HireEra!	\N	f	f	2026-05-16 12:27:46.973	2026-05-16 12:27:46.973
cmp8bnfks000j110tmmdduhrs	cmok7y5hg00008zo61np2pv5f	TypeScript has completely changed how I write JavaScript. The type safety alone saves hours of debugging. Highly recommend the switch! 💡	\N	f	f	2026-05-16 12:27:46.973	2026-05-16 12:27:46.973
cmp8bs20c000h7qgnusmbzj6s	cmok7y5hg00008zo61np2pv5f	🚀 Excited to share that I just completed a full-stack project using React + Node.js + PostgreSQL! Always learning. #OpenToWork #ReactJS	\N	f	f	2026-05-16 12:31:22.668	2026-05-16 12:31:22.668
cmp8bs20c000i7qgn9l7lgidu	cmok7y5j100018zo6ih6nhdds	📢 We are hiring! TechCorp Solutions is looking for talented developers. Check out our open positions on HireEra!	\N	f	f	2026-05-16 12:31:22.668	2026-05-16 12:31:22.668
cmp8bs20c000j7qgn047tip7f	cmok7y5hg00008zo61np2pv5f	TypeScript has completely changed how I write JavaScript. The type safety alone saves hours of debugging. Highly recommend the switch! 💡	\N	f	f	2026-05-16 12:31:22.668	2026-05-16 12:31:22.668
cmp8cnzwg000hfgxcdtg1etmb	cmok7y5hg00008zo61np2pv5f	🚀 Excited to share that I just completed a full-stack project using React + Node.js + PostgreSQL! Always learning. #OpenToWork #ReactJS	\N	f	f	2026-05-16 12:56:12.928	2026-05-16 12:56:12.928
cmp8cnzwg000ifgxc35q2d8gb	cmok7y5j100018zo6ih6nhdds	📢 We are hiring! TechCorp Solutions is looking for talented developers. Check out our open positions on HireEra!	\N	f	f	2026-05-16 12:56:12.928	2026-05-16 12:56:12.928
cmp8cnzwg000jfgxcazyqs590	cmok7y5hg00008zo61np2pv5f	TypeScript has completely changed how I write JavaScript. The type safety alone saves hours of debugging. Highly recommend the switch! 💡	\N	f	f	2026-05-16 12:56:12.928	2026-05-16 12:56:12.928
cmphe6b82001413glb1jt0z74	cmok7y5j100018zo6ih6nhdds	Hiiiiiiiiiiiiiii\n	\N	f	f	2026-05-22 20:48:22.551	2026-05-22 20:48:22.551
cmphe6mit001713glqnei96md	cmphchuyi000213glzjk6l7w4	Hi How's life\n	\N	f	f	2026-05-22 20:48:37.253	2026-05-22 20:48:37.253
cmphe7j5g001913glnkeyzuls	cmphchuyi000213glzjk6l7w4	Hi how's life\n	\N	f	f	2026-05-22 20:49:19.537	2026-05-22 20:49:19.537
cmphwwtdx000gfugk6p95heim	cmphwlf1g0000fugkbczuke0j	Hi\n	\N	f	f	2026-05-23 05:32:52.293	2026-05-23 05:32:52.293
cmpi37qts000h6b6tli7thcnq	cmok7y5j100018zo6ih6nhdds	gauhajojjdso	\N	f	f	2026-05-23 08:29:19.888	2026-05-23 08:29:19.888
\.


--
-- Data for Name: PostLike; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."PostLike" ("postId", "userId", "createdAt") FROM stdin;
cmphe6b82001413glb1jt0z74	cmok7y5hg00008zo61np2pv5f	2026-05-22 20:55:11.326
\.


--
-- Data for Name: Project; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Project" (id, "seekerProfileId", name, description, url, "techStack", "startDate", "endDate") FROM stdin;
\.


--
-- Data for Name: RecruiterProfile; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."RecruiterProfile" (id, "userId", "companyName", "companyLogo", industry, "companySize", website, about, location) FROM stdin;
cmok7y5lj00068zo668esvn9j	cmok7y5j100018zo6ih6nhdds	TechCorp Solutions	\N	Software Development	201-500	https://techcorp.example.com	Building next-gen SaaS products.	Mumbai, India
\.


--
-- Data for Name: RefreshToken; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."RefreshToken" (id, "userId", "tokenHash", "expiresAt", "createdAt") FROM stdin;
cmoy4fzkv000112z8ake0rd27	cmok7y5hg00008zo61np2pv5f	78849de94745e8686b0009ac0f82a3fa1b2fccf146616834d115861e160f5bf3	2026-05-16 09:08:20.531	2026-05-09 09:08:20.543
cmoy4gi6r000312z8qnuw3hqg	cmok7y5hg00008zo61np2pv5f	424cac19ebf1b830a1b00ed535c6b40288b14dd904336f056586c1e87a737715	2026-05-16 09:08:44.674	2026-05-09 09:08:44.691
cmoy4hkcc000512z8bdqg5gyo	cmok7y5hg00008zo61np2pv5f	54185d6d829b4640525b8559c632cb853fd1cd6b97f04943debac59df44af1d7	2026-05-16 09:09:34.121	2026-05-09 09:09:34.14
cmoy4j6ix000712z89qihc4gn	cmok7y5hg00008zo61np2pv5f	a2e11c354969600b9b85f34e0d37146c93f2239d4e69c2c5701d990afae6b20a	2026-05-16 09:10:49.541	2026-05-09 09:10:49.543
cmoy4o7ot000912z8ckl6cl6a	cmok7y5hg00008zo61np2pv5f	c8b14cf594c52321c5d7a919396562608605a9e1f9a6ef675bb53df1d7d4cd4f	2026-05-16 09:14:44.329	2026-05-09 09:14:44.333
cmoy4ob6y000b12z8vkzm6ss5	cmok7y5hg00008zo61np2pv5f	b182098901405b095d5ae0a2c05b5bde5aed3adeb8f983e489ea5d68cca075fa	2026-05-16 09:14:48.869	2026-05-09 09:14:48.873
cmoy4oces000d12z8sms5dn7f	cmok7y5hg00008zo61np2pv5f	9dfc91bbb1698d3a5fe4d1910d6c40f8f7e7398096e4fbcc354f97ef2392d73b	2026-05-16 09:14:50.45	2026-05-09 09:14:50.453
cmoy4oj3l000f12z80toevdfm	cmok7y5hg00008zo61np2pv5f	753063d7b126ebe3952f93a4c03805059bc88b0605f589bedfcc0142a3af100d	2026-05-16 09:14:59.114	2026-05-09 09:14:59.118
cmoy4ok8t000h12z8ydcmsb36	cmok7y5hg00008zo61np2pv5f	9865da4e8e56b6e66f11be8ce6023185421a23a047906a867f0fc98141428564	2026-05-16 09:15:00.604	2026-05-09 09:15:00.606
cmoy4ya9t000j12z8nara16fp	cmok7y5hg00008zo61np2pv5f	5775c71294664b0fcb6bf63f1976f8f620a74a263c33e2a49ee6b22118de7815	2026-05-16 09:22:34.234	2026-05-09 09:22:34.238
cmoy4yctq000l12z81wuf6f1e	cmok7y5hg00008zo61np2pv5f	8f0bb069ae20c63b6bfe96208f748252ef0f7369b9b08110739e5f9876d623ce	2026-05-16 09:22:37.544	2026-05-09 09:22:37.55
cmoy4ylfv000n12z8kepnv4as	cmok7y5hg00008zo61np2pv5f	d65dce50710e77162dcf7f35892e82666f256157ca587363424eb274450e13fe	2026-05-16 09:22:48.703	2026-05-09 09:22:48.708
cmoy4z1ba000p12z86xejxgjm	cmok7y5hg00008zo61np2pv5f	b7fb01c7e0fe7c27b4aae9d9feef5658fd0ddac96704975d7aa61e7e50c2f83c	2026-05-16 09:23:09.285	2026-05-09 09:23:09.286
cmoy4zb8p000r12z8g85l55xz	cmok7y5hg00008zo61np2pv5f	5812f5a5f7bfdb0983aac689757a1badf4f616cdfa51bf6a62262fa83b16f873	2026-05-16 09:23:22.15	2026-05-09 09:23:22.153
cmoy50vr7000t12z898tqiza1	cmok7y5hg00008zo61np2pv5f	aa5934cf8351d6e93626680b271e3dced4e58693425eaa865a6e173054c654b4	2026-05-16 09:24:35.393	2026-05-09 09:24:35.395
cmoycaq250001shjazozjdzzz	cmok7y5hg00008zo61np2pv5f	f2175b2509e69ccd7ece399d93b2815c5612f1575b03934603ed1cdfae70ad24	2026-05-16 12:48:11.872	2026-05-09 12:48:11.88
cmp7wrf4x0001mrfqcnfto8ca	cmok7y5hg00008zo61np2pv5f	d4d6c2e981485d1b76c1bce602bbb3d8e32f85080c30aa88185dfb3a13f3eff2	2026-05-23 05:30:58.777	2026-05-16 05:30:58.779
cmp7wvmpw0003mrfq2gcba1b0	cmok7y5hg00008zo61np2pv5f	4481c468db4289fb0e14280a4930983351de94b05c1979c8fbf87050299f604e	2026-05-23 05:34:15.234	2026-05-16 05:34:15.236
cmp89qh1c0001rj1zsowhx0iq	cmok7y5hg00008zo61np2pv5f	d94808a449fc9d6344fd0b254ce285d5671724ce9e183fdba482d59d9eb2b5de	2026-05-23 11:34:09.561	2026-05-16 11:34:09.596
cmp89tox50003rj1znqin54ki	cmok7y5hg00008zo61np2pv5f	3f46027f850f09cd12dfe0b10cb973b4eeb01c523688f74ebde77379bc758f7e	2026-05-23 11:36:39.782	2026-05-16 11:36:39.785
cmp89ycgs00015wohg28cwl39	cmok7y5hg00008zo61np2pv5f	bea6dc39f622258d09a2bc6c3db025e41d9c5abeb6408d1458c4c9da7add1585	2026-05-23 11:40:16.916	2026-05-16 11:40:16.923
cmp8amf8e00035woheqnrdd2o	cmok7y5hg00008zo61np2pv5f	2c396c0641ce47d8eecd28aca51c7b054a1cf9334c2db7054553f0e772beae56	2026-05-23 11:59:00.251	2026-05-16 11:59:00.253
cmp8cvxah00055wohqe61789t	cmok7y5hg00008zo61np2pv5f	20b4aa9ff204d391d0646f82b830bb34acf5fa6261b10499d54f0f99039942c1	2026-05-23 13:02:22.761	2026-05-16 13:02:22.768
cmp8dhc8w0001shg6nebyblcv	cmok7y5hg00008zo61np2pv5f	0476beec5620f9f2e47332a51f53e818478d4a35191f70344fbc007a00b75727	2026-05-23 13:19:01.743	2026-05-16 13:19:01.751
cmp8e1trb0003shg65w24t2rz	cmok7y5hg00008zo61np2pv5f	fc1d059dac18c0578fbb61b7b1ce3803039cad56dfc9d138249141375f75e8f0	2026-05-23 13:34:57.67	2026-05-16 13:34:57.71
cmp8g4d8s00014xwn07v6rzf5	cmok7y5hg00008zo61np2pv5f	ed3362df83d9581c4b9beba12dcc77e0014570654f05148f0755c29d8cc7ad15	2026-05-23 14:32:55.222	2026-05-16 14:32:55.536
cmp8h1os60001hwpa0933g4i5	cmok7y5hg00008zo61np2pv5f	d392b8ebe4bb14da4037066c6fcc9d23b8baa2827b3e5446783e1d128da44d9e	2026-05-23 14:58:50.149	2026-05-16 14:58:50.153
cmpfiqa9y000111m1v08xu0sh	cmok7y5hg00008zo61np2pv5f	46395a1cfd3213b7212e1b667c7c5a29bc9307e85a3b166cb935f57d03c60b2b	2026-05-28 13:20:20.604	2026-05-21 13:20:20.609
cmpfirxm8000311m11dr5hmvr	cmok7y5hg00008zo61np2pv5f	c492661c2c1dfe4c8b4fa334c7ffafcb9456fd5522859ce2068621b66db1adc7	2026-05-28 13:21:37.516	2026-05-21 13:21:37.52
cmpfistvx000511m1uju4rvmr	cmok7y5hg00008zo61np2pv5f	a79e5bf306cc6ccc7064bbb43ef9aba0260f4acbb28c0d9ccc791645c1d47cb0	2026-05-28 13:22:19.339	2026-05-21 13:22:19.341
cmpfiu4tt00015jj7949zrsd2	cmok7y5hg00008zo61np2pv5f	46dd75f0855a9894ab8e313bdb787d094fff3ce6a1bd7342a0654246b7684ca1	2026-05-28 13:23:20.168	2026-05-21 13:23:20.177
cmpfiuy4c00035jj75nkpccuh	cmok7y5hg00008zo61np2pv5f	4e388e8ea79c721ea410f9467bbc7ee85471b6c2c404dfd07598f208c63f4aa5	2026-05-28 13:23:58.137	2026-05-21 13:23:58.14
cmpfiw7940001vwqoxba7t8e7	cmok7y5hg00008zo61np2pv5f	41fa1292ad5fec1e052d16e11582013a5712543d3e67e81cee86489ad79c812e	2026-05-28 13:24:56.626	2026-05-21 13:24:56.632
cmpfj6u2n0001pje523aljkxk	cmok7y5hg00008zo61np2pv5f	aaaf3f71d96f356f6da38caa5395104f5076b1e5242bbe38c85dbf56bbb13e9e	2026-05-28 13:33:12.763	2026-05-21 13:33:12.767
cmpfjg2ir00014iqgsnu0t2ni	cmok7y5hg00008zo61np2pv5f	23730b187644e2f5279901efea01cea18e66d534cab11c9882e77be1b007218d	2026-05-28 13:40:23.61	2026-05-21 13:40:23.619
cmpfjgqdf00034iqg2kss8dfs	cmok7y5hg00008zo61np2pv5f	164d7e017c43cf1d38fb497e128a62b699d1f619c7a104fe564b1586594cf451	2026-05-28 13:40:54.526	2026-05-21 13:40:54.531
cmpfoyqvd00054iqguv76v60s	cmok7y5hg00008zo61np2pv5f	e1b283bb9e15bfc3bd6cf8664033ac98a6eddbfe179dfa2d95602f98eba366e8	2026-05-28 16:14:53.01	2026-05-21 16:14:53.043
cmpfp734z00074iqgu0dmkjsi	cmok7y5hg00008zo61np2pv5f	97f9f249b09137eba12d5f34aaf38f565b5c9efb28a8dbdd36787103d509694f	2026-05-28 16:21:22.21	2026-05-21 16:21:22.212
cmpfqywu700011qbw1dg8l2d4	cmok7y5hg00008zo61np2pv5f	a39836638b8584755558272d3f6be6c43535a8046666d72b8b9e1fda3b8ae24d	2026-05-28 17:11:00.015	2026-05-21 17:11:00.025
cmpfsnwux00071qbw1bmlabsa	cmok7y5hg00008zo61np2pv5f	4c679303957c1b26a74c3a4359dfc0abc0db6ef525e9dad72411b096f55921a1	2026-05-28 17:58:26.039	2026-05-21 17:58:26.067
cmpfstggu00091qbw74ozdeky	cmok7y5hg00008zo61np2pv5f	a750e1172d1280606132244ff3239b4b5b71cb46c6a522368efa3ed271edf19e	2026-05-28 18:02:44.764	2026-05-21 18:02:44.767
cmpha6jxo000l10ang1y27q0r	cmok7y5j100018zo6ih6nhdds	8db107d514a7a32dab6dc8929521cfc479aca23660b0e538ce27b01f794acc87	2026-05-29 18:56:35.276	2026-05-22 18:56:35.348
cmpha6twg000n10ansii832cu	cmok7y5j100018zo6ih6nhdds	f379f38d53758579f96b91274f273324ab0fe465d63d56ffc970228b4f837fa9	2026-05-29 18:56:48.35	2026-05-22 18:56:48.352
cmphabqi1000r10anxhvmmi03	cmok7y5hg00008zo61np2pv5f	19b356640abe33924d76550bae4de295741182dd7d422d87eeaf8493405c19ec	2026-05-29 19:00:37.224	2026-05-22 19:00:37.225
cmphayhx3000z10anp3y1xmin	cmok7y5j100018zo6ih6nhdds	4a10d91734a78196a938bf276bd26ccf7821c6fb4d33d270aa187d398f8a4f43	2026-05-29 19:18:19.093	2026-05-22 19:18:19.189
cmphbk3wh001j10animptaspa	cmok7y5j100018zo6ih6nhdds	52347459d390b833ec65ac0b5365df07a071d46a045684e314e9ef0bdac19c1b	2026-05-29 19:35:07.45	2026-05-22 19:35:07.456
cmphcg8y4000113glqdfk7iap	cmok7y5hg00008zo61np2pv5f	f6a5584674fd59f50bdd3327c89ab5333c70ac368cbddfb0a87c20249bb31b6c	2026-05-29 20:00:06.974	2026-05-22 20:00:06.98
cmphcintx000c13glp0xxsxze	cmok7y5j100018zo6ih6nhdds	74f43beb85c70ae330b8d28d1033a900ab28f1b193ebb527f97a345291665766	2026-05-29 20:01:59.588	2026-05-22 20:01:59.589
cmphd3ve8000g13gleztes4z9	cmphchuyi000213glzjk6l7w4	5eab2b0f084ea52ac46f8772a51075824c43b04831389354169946e19f9d4cf5	2026-05-29 20:18:29.158	2026-05-22 20:18:29.163
cmphd42st000i13glw273dhao	cmok7y5hg00008zo61np2pv5f	0c601849c38368a4a4cb202c5591e90750cf95d882448b5286ecd78ff46be97f	2026-05-29 20:18:38.763	2026-05-22 20:18:38.765
cmphd53fh000k13glyg8dg6mw	cmok7y5hg00008zo61np2pv5f	9d31078ccaf507c933e106d54b0083235ec894b1861d60c76bf1935e515fa42b	2026-05-29 20:19:26.233	2026-05-22 20:19:26.237
cmphd5ms9000m13glwvfz5xpd	cmphchuyi000213glzjk6l7w4	32584ecda5174a97ec5c2dd05c7c092b5ef36a099b7cfbde49f0042ba3084e20	2026-05-29 20:19:51.32	2026-05-22 20:19:51.321
cmpheekys001b13glpb2vfa74	cmphchuyi000213glzjk6l7w4	8cc09fd9336c50e82dc0fc87dddbf01ddac69e732ec6f5d70583a49c0c7d61fd	2026-05-29 20:54:48.48	2026-05-22 20:54:48.484
cmpheeta0001d13gle603jiix	cmok7y5hg00008zo61np2pv5f	6a04698f93c3920b448d38e335647c9e3563d8e556552f403f1c236d12ed712b	2026-05-29 20:54:59.255	2026-05-22 20:54:59.257
cmpheilca001j13gln07vc492	cmok7y5j100018zo6ih6nhdds	8ee18116c542b3afa75afd925d4a3e9ae6d30b7a97b6536c1420369da71ddb11	2026-05-29 20:57:55.592	2026-05-22 20:57:55.594
cmphve8vp0004405sq5ey8y22	cmphve6pz0000405sq2q8ldrk	ddc399f43c60a8738f6947a7f917677c608b74af77c42d4ab44ebe5b37cec508	2026-05-30 04:50:26.29	2026-05-23 04:50:26.294
cmphwo4ze0004fugkeyma74qp	cmphwlf1g0000fugkbczuke0j	4037d02b47d70de7ed73be5f12d4569cf7b9fd9430067d6da3f95e0f1723e188	2026-05-30 05:26:07.411	2026-05-23 05:26:07.419
cmphwrdza000afugkko44yutl	cmok7y5j100018zo6ih6nhdds	25551592f2a38c64d6923a9dbe3f45f9f733d54bc2288f27fe114231a97a5c89	2026-05-30 05:28:39.045	2026-05-23 05:28:39.046
cmphx0ae7000ifugkorqoln8m	cmphwlf1g0000fugkbczuke0j	25247483f92c205afb8251e788cf447f787a5e3a857faba4d5ba54b0a7b25998	2026-05-30 05:35:34.301	2026-05-23 05:35:34.303
cmphy7l940003iopb1nhd5mku	cmok7y5j100018zo6ih6nhdds	078224355ba6e65769ebd3922937608dbe187e61ceaca2577015f097d755a234	2026-05-30 06:09:14.583	2026-05-23 06:09:14.584
cmpi2qhno00016b6tithu5hzk	cmphwlf1g0000fugkbczuke0j	3ebccd026b4def16bfe97f5c21dbaef3f9c63ed7634989056c5903e648c22855	2026-05-30 08:15:54.843	2026-05-23 08:15:54.846
cmpi3392x00036b6td2pt4e3p	cmok7y5j100018zo6ih6nhdds	15584fb48d517a40985728626d2c7554b8d27e06be141b97218f6c220ee21b61	2026-05-30 08:25:50.264	2026-05-23 08:25:50.265
cmptg2ndc0001yznhbsaucvw9	cmok7y5hg00008zo61np2pv5f	7375a3db8829efd05bdf1650785ea083a6a369a257c8315093deb6ba1aa7d4b2	2026-06-07 07:14:45.054	2026-05-31 07:14:45.062
cmptk3mds0005ov2tg4h7xz7r	cmok7y5j100018zo6ih6nhdds	f4cd7a9e05a85ce5630dc825230bc869b66ff5b3aed28a7f2af1c6ec4872a1a4	2026-06-07 09:07:28.911	2026-05-31 09:07:28.913
\.


--
-- Data for Name: Report; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."Report" (id, "reporterId", "targetType", "targetId", "postId", reason, status, "createdAt") FROM stdin;
\.


--
-- Data for Name: SeekerProfile; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."SeekerProfile" (id, "userId", headline, about, location, phone, website, "linkedinUrl", "githubUrl", "resumeUrl", "resumeData", "openToWork", skills, languages, "profileCompletion") FROM stdin;
cmok7y5jx00048zo6y6cq4pix	cmok7y5hg00008zo61np2pv5f	Senior Frontend Developer	5+ years of experience building scalable React applications with TypeScript and Node.js.	Bengaluru, India	+91 9876543210	\N	https://linkedin.com/in/janesmith	https://github.com/janesmith	\N	{"skills": ["Leadership", "Strategy", "Python"], "summary": "Highly skilled Senior Frontend Developer with 6+ years of experience engineering high-performance SaaS applications in the FinTech and E-commerce sectors. Proven track record of optimizing web performance, including driving a 35% reduction in page load times and a 4% lift in checkout conversions. Expert in React, Next.js, and TypeScript, with a strong passion for building scalable design systems and mentoring engineering teams.", "projects": [{"id": 1779383903442, "link": "", "name": "", "description": ""}], "education": [{"id": 1779383809366, "field": "IT", "degree": "Bsc", "school": "Harvard", "endYear": "4", "startYear": "3"}], "experience": [{"id": 1779383748062, "title": "Full stack developer", "company": "Netflix", "endDate": "", "location": "", "isCurrent": true, "startDate": "2024-05", "description": ""}], "personalInfo": {"name": "R Raghu Paul", "email": "seeker@hireera.com", "phone": "", "website": "", "headline": "Senior ", "location": ""}, "certifications": [{"id": 1779383911426, "name": "", "year": "", "issuer": ""}]}	t	{Leadership,Strategy,Python}	{English,Hindi}	80
cmphchv1d000413gl9rld1hu2	cmphchuyi000213glzjk6l7w4	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	0
cmphve6ry0002405swu4z064x	cmphve6pz0000405sq2q8ldrk	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	0
cmphwlf3g0002fugkjexyjuzd	cmphwlf1g0000fugkbczuke0j	\N	\N	\N	\N	\N	\N	\N	\N	{"skills": ["python"], "summary": "Results-driven Senior Developer with 8+ years of experience in designing, developing, and deploying scalable software solutions, leveraging expertise in Java, Python, and cloud-based technologies to drive innovation and excellence in digital transformation initiatives.", "projects": [{"id": 1779524360465, "link": "IHSISHUSH", "name": "VHAUGAUGHU", "description": "JUSGHUHSUHSH"}], "education": [{"id": 1779524328817, "field": "ojsojso", "degree": "skjsij", "school": "ijhisjis", "endYear": "4", "startYear": "3"}], "experience": [{"id": 1779524267114, "title": "Fulll syadjhisi", "company": "jhsijsih", "endDate": "2026-02", "location": "", "isCurrent": false, "startDate": "2026-06", "description": "ihuhujij"}], "personalInfo": {"name": "Raghu Paul", "email": "rraghu.ece25@cmrit.ac.in", "phone": "8688876679", "website": "", "headline": "Senior developer", "location": "Bangalore"}, "certifications": [{"id": 1779524371988, "name": "AWD", "year": "5", "issuer": "SSJH"}]}	f	{python}	\N	0
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: hireera
--

COPY public."User" (id, name, email, "passwordHash", role, "avatarUrl", "isVerified", "isActive", "isBanned", "banReason", "verifyToken", "resetToken", "resetExpiry", "createdAt", "updatedAt") FROM stdin;
cmphwlf1g0000fugkbczuke0j	Raghu Paul	rraghu.ece25@cmrit.ac.in	$2a$12$S9JZY0YO9Hnpj62umVLfw.8ICrEp72zPTYRYAofpWuGZC4buOwJhG	SEEKER	/uploads/avatars/b8ea68013225a4bf128247aaf1b55aa4.webp	t	t	f	\N	\N	\N	\N	2026-05-23 05:24:00.485	2026-05-23 05:31:23.062
cmok7y5j100018zo6ih6nhdds	Alex Kumar	recruiter@hireera.com	$2a$12$M4LZEGusMdZgi/dNwFram.urWY90HUSJJgcjwZ1H/d0Vd1ZNYRK8C	RECRUITER	\N	t	t	f	\N	\N	\N	\N	2026-04-29 15:37:40.477	2026-05-22 16:47:17.69
cmok7y5jh00028zo6jpuyrxyf	Admin User	admin@hireera.com	$2a$12$M4LZEGusMdZgi/dNwFram.urWY90HUSJJgcjwZ1H/d0Vd1ZNYRK8C	ADMIN	\N	t	t	f	\N	\N	\N	\N	2026-04-29 15:37:40.491	2026-05-22 16:47:17.69
cmok7y5hg00008zo61np2pv5f	Jane Smith	seeker@hireera.com	$2a$12$M4LZEGusMdZgi/dNwFram.urWY90HUSJJgcjwZ1H/d0Vd1ZNYRK8C	SEEKER	/uploads/avatars/5c19b3a363d49357dcbb933006f3a497.webp	t	t	f	\N	\N	\N	\N	2026-04-29 15:37:40.416	2026-05-22 16:47:17.69
cmphchuyi000213glzjk6l7w4	Raghu Paul	raghuturned18@gmail.com	$2a$12$iPHNPYtxNUtb8shY9rwNXeY5VoGMolPE4NKjrJvs.OUH1psmTPNNu	SEEKER	\N	t	t	f	\N	fb0d5df329e7f1679f39f26154db4396767ff11bdc678af3b2c9dcc174aaf176	\N	\N	2026-05-22 20:01:22.17	2026-05-22 20:01:22.17
cmphve6pz0000405sq2q8ldrk	San Nair	sanjith.ece25@cmrit.ac.in	$2a$12$62EtRg2hE1DxFfOfRmG6/uB17vXDfT7LtPAYmzPgcEhI8h3YQ0PzW	SEEKER	\N	t	t	f	\N	894341ab3fcc23a4a953f2fac5cfd8dca08eadf3da3bf23726007597d8d2c579	\N	\N	2026-05-23 04:50:23.495	2026-05-23 04:50:23.495
\.


--
-- Name: Application Application_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Application"
    ADD CONSTRAINT "Application_pkey" PRIMARY KEY (id);


--
-- Name: AuditLog AuditLog_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."AuditLog"
    ADD CONSTRAINT "AuditLog_pkey" PRIMARY KEY (id);


--
-- Name: Certification Certification_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Certification"
    ADD CONSTRAINT "Certification_pkey" PRIMARY KEY (id);


--
-- Name: Comment Comment_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_pkey" PRIMARY KEY (id);


--
-- Name: Connection Connection_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Connection"
    ADD CONSTRAINT "Connection_pkey" PRIMARY KEY (id);


--
-- Name: Education Education_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Education"
    ADD CONSTRAINT "Education_pkey" PRIMARY KEY (id);


--
-- Name: Experience Experience_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Experience"
    ADD CONSTRAINT "Experience_pkey" PRIMARY KEY (id);


--
-- Name: Job Job_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Job"
    ADD CONSTRAINT "Job_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (id);


--
-- Name: PostLike PostLike_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."PostLike"
    ADD CONSTRAINT "PostLike_pkey" PRIMARY KEY ("postId", "userId");


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);


--
-- Name: Project Project_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_pkey" PRIMARY KEY (id);


--
-- Name: RecruiterProfile RecruiterProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."RecruiterProfile"
    ADD CONSTRAINT "RecruiterProfile_pkey" PRIMARY KEY (id);


--
-- Name: RefreshToken RefreshToken_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "RefreshToken_pkey" PRIMARY KEY (id);


--
-- Name: Report Report_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_pkey" PRIMARY KEY (id);


--
-- Name: SeekerProfile SeekerProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."SeekerProfile"
    ADD CONSTRAINT "SeekerProfile_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Application_jobId_seekerId_key; Type: INDEX; Schema: public; Owner: hireera
--

CREATE UNIQUE INDEX "Application_jobId_seekerId_key" ON public."Application" USING btree ("jobId", "seekerId");


--
-- Name: Connection_requesterId_receiverId_key; Type: INDEX; Schema: public; Owner: hireera
--

CREATE UNIQUE INDEX "Connection_requesterId_receiverId_key" ON public."Connection" USING btree ("requesterId", "receiverId");


--
-- Name: RecruiterProfile_userId_key; Type: INDEX; Schema: public; Owner: hireera
--

CREATE UNIQUE INDEX "RecruiterProfile_userId_key" ON public."RecruiterProfile" USING btree ("userId");


--
-- Name: RefreshToken_tokenHash_key; Type: INDEX; Schema: public; Owner: hireera
--

CREATE UNIQUE INDEX "RefreshToken_tokenHash_key" ON public."RefreshToken" USING btree ("tokenHash");


--
-- Name: SeekerProfile_userId_key; Type: INDEX; Schema: public; Owner: hireera
--

CREATE UNIQUE INDEX "SeekerProfile_userId_key" ON public."SeekerProfile" USING btree ("userId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: hireera
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Application Application_jobId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Application"
    ADD CONSTRAINT "Application_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES public."Job"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Application Application_seekerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Application"
    ADD CONSTRAINT "Application_seekerId_fkey" FOREIGN KEY ("seekerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AuditLog AuditLog_adminId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."AuditLog"
    ADD CONSTRAINT "AuditLog_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Certification Certification_seekerProfileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Certification"
    ADD CONSTRAINT "Certification_seekerProfileId_fkey" FOREIGN KEY ("seekerProfileId") REFERENCES public."SeekerProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Comment Comment_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Comment Comment_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Connection Connection_receiverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Connection"
    ADD CONSTRAINT "Connection_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Connection Connection_requesterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Connection"
    ADD CONSTRAINT "Connection_requesterId_fkey" FOREIGN KEY ("requesterId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Education Education_seekerProfileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Education"
    ADD CONSTRAINT "Education_seekerProfileId_fkey" FOREIGN KEY ("seekerProfileId") REFERENCES public."SeekerProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Experience Experience_seekerProfileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Experience"
    ADD CONSTRAINT "Experience_seekerProfileId_fkey" FOREIGN KEY ("seekerProfileId") REFERENCES public."SeekerProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Job Job_recruiterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Job"
    ADD CONSTRAINT "Job_recruiterId_fkey" FOREIGN KEY ("recruiterId") REFERENCES public."RecruiterProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_receiverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Notification Notification_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostLike PostLike_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."PostLike"
    ADD CONSTRAINT "PostLike_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostLike PostLike_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."PostLike"
    ADD CONSTRAINT "PostLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Post Post_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Project Project_seekerProfileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_seekerProfileId_fkey" FOREIGN KEY ("seekerProfileId") REFERENCES public."SeekerProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RecruiterProfile RecruiterProfile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."RecruiterProfile"
    ADD CONSTRAINT "RecruiterProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RefreshToken RefreshToken_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "RefreshToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Report Report_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Report Report_reporterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SeekerProfile SeekerProfile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hireera
--

ALTER TABLE ONLY public."SeekerProfile"
    ADD CONSTRAINT "SeekerProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vBYZ8qPWuVvxgn1FYHu46hilwCrqvHTJew8mainK78a6mZizgw6SGLNdRedGSaj

