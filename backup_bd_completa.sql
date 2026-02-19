--
-- PostgreSQL database dump
--

\restrict eoXdEdi4T4XfwqazlRjin2DtikbI2kOqOSUodsh38ume1WiWOI2aoMj35Qo21Be

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: EventType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."EventType" AS ENUM (
    'BAPTISM',
    'MARRIAGE',
    'DEATH'
);


--
-- Name: Role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Role" AS ENUM (
    'SUBJECT',
    'FATHER',
    'MOTHER',
    'GROOM',
    'BRIDE',
    'GRANDFATHER_PATERNAL',
    'GRANDMOTHER_PATERNAL',
    'GRANDFATHER_MATERNAL',
    'GRANDMOTHER_MATERNAL',
    'GODFATHER',
    'GODMOTHER',
    'WITNESS',
    'PRIEST',
    'OTHER'
);


--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'ADMIN',
    'USER'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Event; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Event" (
    type public."EventType" NOT NULL,
    year integer,
    month integer,
    day integer,
    "sourceUrl" text,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    id integer NOT NULL,
    "parishId" integer NOT NULL,
    "createdById" integer NOT NULL,
    "updatedById" integer
);


--
-- Name: Event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Event_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Event_id_seq" OWNED BY public."Event".id;


--
-- Name: Family; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Family" (
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "contextParishId" integer,
    "createdById" integer,
    "updatedById" integer,
    id integer NOT NULL,
    "fatherId" integer,
    "motherId" integer,
    "marriageEventId" integer
);


--
-- Name: Family_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Family_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Family_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Family_id_seq" OWNED BY public."Family".id;


--
-- Name: Individual; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Individual" (
    name text NOT NULL,
    sex text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "contextParishId" integer,
    "createdById" integer,
    "legitimacyStatusId" integer,
    "updatedById" integer,
    id integer NOT NULL,
    "familyOfOriginId" integer
);


--
-- Name: Individual_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Individual_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Individual_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Individual_id_seq" OWNED BY public."Individual".id;


--
-- Name: Kinship; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Kinship" (
    id integer NOT NULL,
    name text NOT NULL,
    "isOriginal" boolean DEFAULT false NOT NULL
);


--
-- Name: Kinship_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Kinship_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Kinship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Kinship_id_seq" OWNED BY public."Kinship".id;


--
-- Name: LegitimacyStatus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."LegitimacyStatus" (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: LegitimacyStatus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."LegitimacyStatus_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: LegitimacyStatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."LegitimacyStatus_id_seq" OWNED BY public."LegitimacyStatus".id;


--
-- Name: Parish; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Parish" (
    name text NOT NULL,
    district text,
    municipality text,
    id integer NOT NULL,
    "isOriginal" boolean DEFAULT false NOT NULL
);


--
-- Name: Parish_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Parish_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Parish_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Parish_id_seq" OWNED BY public."Parish".id;


--
-- Name: Participation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Participation" (
    role public."Role" NOT NULL,
    nickname text,
    "contextParishId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdById" integer,
    "deathPlaceId" integer,
    "kinshipId" integer,
    "participationRoleId" integer,
    "professionOriginal" text,
    "titleId" integer,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "updatedById" integer,
    id integer NOT NULL,
    "eventId" integer NOT NULL,
    "individualId" integer NOT NULL,
    "professionId" integer,
    "residenceId" integer,
    "originId" integer,
    "lineageIndex" text
);


--
-- Name: ParticipationRole; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ParticipationRole" (
    id integer NOT NULL,
    name text NOT NULL,
    "isOriginal" boolean DEFAULT false NOT NULL
);


--
-- Name: ParticipationRole_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ParticipationRole_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ParticipationRole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ParticipationRole_id_seq" OWNED BY public."ParticipationRole".id;


--
-- Name: Participation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Participation_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Participation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Participation_id_seq" OWNED BY public."Participation".id;


--
-- Name: Place; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Place" (
    name text NOT NULL,
    id integer NOT NULL,
    "parishId" integer NOT NULL,
    "isOriginal" boolean DEFAULT false NOT NULL
);


--
-- Name: Place_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Place_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Place_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Place_id_seq" OWNED BY public."Place".id;


--
-- Name: Profession; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Profession" (
    name text NOT NULL,
    id integer NOT NULL,
    "isOriginal" boolean DEFAULT false NOT NULL
);


--
-- Name: Profession_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Profession_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Profession_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Profession_id_seq" OWNED BY public."Profession".id;


--
-- Name: Title; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Title" (
    id integer NOT NULL,
    name text NOT NULL,
    "isOriginal" boolean DEFAULT false NOT NULL
);


--
-- Name: Title_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Title_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Title_id_seq" OWNED BY public."Title".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    name text,
    email text NOT NULL,
    password text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "currentParishId" integer,
    id integer NOT NULL,
    "currentEventType" text,
    role public."UserRole" DEFAULT 'USER'::public."UserRole" NOT NULL
);


--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: Event id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Event" ALTER COLUMN id SET DEFAULT nextval('public."Event_id_seq"'::regclass);


--
-- Name: Family id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family" ALTER COLUMN id SET DEFAULT nextval('public."Family_id_seq"'::regclass);


--
-- Name: Individual id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual" ALTER COLUMN id SET DEFAULT nextval('public."Individual_id_seq"'::regclass);


--
-- Name: Kinship id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Kinship" ALTER COLUMN id SET DEFAULT nextval('public."Kinship_id_seq"'::regclass);


--
-- Name: LegitimacyStatus id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."LegitimacyStatus" ALTER COLUMN id SET DEFAULT nextval('public."LegitimacyStatus_id_seq"'::regclass);


--
-- Name: Parish id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Parish" ALTER COLUMN id SET DEFAULT nextval('public."Parish_id_seq"'::regclass);


--
-- Name: Participation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation" ALTER COLUMN id SET DEFAULT nextval('public."Participation_id_seq"'::regclass);


--
-- Name: ParticipationRole id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ParticipationRole" ALTER COLUMN id SET DEFAULT nextval('public."ParticipationRole_id_seq"'::regclass);


--
-- Name: Place id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Place" ALTER COLUMN id SET DEFAULT nextval('public."Place_id_seq"'::regclass);


--
-- Name: Profession id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Profession" ALTER COLUMN id SET DEFAULT nextval('public."Profession_id_seq"'::regclass);


--
-- Name: Title id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Title" ALTER COLUMN id SET DEFAULT nextval('public."Title_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Data for Name: Event; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Event" (type, year, month, day, "sourceUrl", notes, "createdAt", "updatedAt", id, "parishId", "createdById", "updatedById") FROM stdin;
MARRIAGE	1800	13	45	\N	\N	2026-01-15 20:40:45.647	2026-01-16 11:24:19.188	3	131301	1	1
BAPTISM	1600	12	30	\N	\N	2026-01-14 22:13:45.909	2026-01-16 13:59:29.679	1	131301	1	1
BAPTISM	1980	11	30	\N	\N	2026-01-14 22:21:34.624	2026-01-16 14:53:59.08	2	131301	1	1
\.


--
-- Data for Name: Family; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Family" ("createdAt", "updatedAt", "contextParishId", "createdById", "updatedById", id, "fatherId", "motherId", "marriageEventId") FROM stdin;
2026-01-15 17:50:31.044	2026-01-15 17:51:08.908	\N	1	1	5	28	29	\N
2026-01-15 17:49:30.453	2026-01-15 17:51:08.912	\N	1	1	4	26	25	\N
2026-01-15 20:40:45.752	2026-01-15 20:40:45.752	\N	1	1	6	\N	33	\N
2026-01-15 20:40:45.759	2026-01-15 20:40:45.759	\N	1	1	7	32	\N	\N
2026-01-15 20:40:45.763	2026-01-15 20:40:45.763	\N	1	1	8	30	31	3
\.


--
-- Data for Name: Individual; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Individual" (name, sex, "createdAt", "updatedAt", "contextParishId", "createdById", "legitimacyStatusId", "updatedById", id, "familyOfOriginId") FROM stdin;
noivo	M	2026-01-15 20:40:45.707	2026-01-16 11:24:19.192	\N	1	\N	1	30	\N
noiva	F	2026-01-15 20:40:45.723	2026-01-16 11:24:19.207	\N	1	1	1	31	7
Pai de noiva	D	2026-01-15 21:04:17.675	2026-01-16 11:24:19.213	\N	1	\N	1	37	\N
mae da noiva 2	F	2026-01-15 20:54:20.64	2026-01-16 11:24:19.219	\N	1	\N	1	35	\N
avô da noiva	M	2026-01-15 21:04:17.692	2026-01-16 11:24:19.224	\N	1	\N	1	38	\N
avó da noiva 2	F	2026-01-15 20:54:20.649	2026-01-16 11:24:19.231	\N	1	\N	1	36	\N
padrino	M	2026-01-15 20:40:45.764	2026-01-16 11:24:19.239	\N	1	\N	1	34	\N
Mariana	F	2026-01-14 22:13:45.914	2026-01-16 13:59:29.686	\N	1	\N	1	1	4
pai de mariana	M	2026-01-15 17:49:42.097	2026-01-16 13:59:29.697	\N	1	\N	1	26	\N
mae teste final	F	2026-01-15 17:49:30.439	2026-01-16 13:59:29.703	\N	1	\N	1	25	5
avó de mariana	M	2026-01-15 17:50:31.031	2026-01-16 13:59:29.711	\N	1	\N	1	28	\N
avô d ema	F	2026-01-15 17:50:52.576	2026-01-16 13:59:29.719	\N	1	\N	1	29	\N
padrinho de mariana	M	2026-01-15 17:49:57.989	2026-01-16 13:59:29.729	\N	1	\N	1	27	\N
Paulo	M	2026-01-16 11:38:32.608	2026-01-16 14:53:59.084	131301	1	\N	1	39	\N
avó da noiva	F	2026-01-15 20:40:45.749	2026-01-15 20:40:45.749	\N	1	\N	1	33	\N
mae da noiva	M	2026-01-15 20:40:45.738	2026-01-15 20:40:45.757	\N	1	\N	1	32	6
\.


--
-- Data for Name: Kinship; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Kinship" (id, name, "isOriginal") FROM stdin;
0	Neto	f
1	Pai	f
2	Mãe	f
3	Avó	f
4	Avô	f
6	Filho	f
7	Filha	f
8	Tio	f
9	Tia	f
10	Primo	f
11	Prima	f
12	Genro	f
13	Nora	f
14	Cônjuge	f
15	Irmão	f
16	Irmã	f
17	Cunhado	f
18	Cunhada	f
19	Neta	f
20	Sogro	f
21	Sogra	f
22	Sobrinho	f
23	Sobrinha	f
24	Padrasto	f
25	Madrasta	f
26	Enteado	f
27	Enteada	f
28	Afilhado	f
29	Afilhada	f
\.


--
-- Data for Name: LegitimacyStatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."LegitimacyStatus" (id, name) FROM stdin;
1	Legítimo
2	Natural
3	Exposto
\.


--
-- Data for Name: Parish; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Parish" (name, district, municipality, id, "isOriginal") FROM stdin;
Agadão	Aveiro	Águeda	0	f
Agadão	Aveiro	Águeda	10101	f
Aguada de Baixo	Aveiro	Águeda	10102	f
Aguada de Cima	Aveiro	Águeda	10103	f
Águeda	Aveiro	Águeda	10104	f
Barrô	Aveiro	Águeda	10105	f
Belazaima do Chão	Aveiro	Águeda	10106	f
Castanheira do Vouga	Aveiro	Águeda	10107	f
Espinhel	Aveiro	Águeda	10108	f
Fermentelos	Aveiro	Águeda	10109	f
Lamas do Vouga	Aveiro	Águeda	10110	f
Macieira de Alcoba	Aveiro	Águeda	10111	f
Macinhata do Vouga	Aveiro	Águeda	10112	f
Óis da Ribeira	Aveiro	Águeda	10113	f
Préstimo	Aveiro	Águeda	10114	f
Recardães	Aveiro	Águeda	10115	f
Segadães	Aveiro	Águeda	10116	f
Travassô	Aveiro	Águeda	10117	f
Trofa	Aveiro	Águeda	10118	f
Valongo do Vouga	Aveiro	Águeda	10119	f
Borralha	Aveiro	Águeda	10120	f
Albergaria-a-Velha	Aveiro	Albergaria-a-Velha	10201	f
Alquerubim	Aveiro	Albergaria-a-Velha	10202	f
Angeja	Aveiro	Albergaria-a-Velha	10203	f
Branca	Aveiro	Albergaria-a-Velha	10204	f
Frossos	Aveiro	Albergaria-a-Velha	10205	f
Ribeira de Fráguas	Aveiro	Albergaria-a-Velha	10206	f
São João de Loure	Aveiro	Albergaria-a-Velha	10207	f
Valmaior	Aveiro	Albergaria-a-Velha	10208	f
Amoreira da Gândara	Aveiro	Anadia	10301	f
Ancas	Aveiro	Anadia	10302	f
Arcos	Aveiro	Anadia	10303	f
Avelãs de Caminho	Aveiro	Anadia	10304	f
Avelãs de Cima	Aveiro	Anadia	10305	f
Mogofores	Aveiro	Anadia	10306	f
Moita	Aveiro	Anadia	10307	f
Óis do Bairro	Aveiro	Anadia	10308	f
Sangalhos	Aveiro	Anadia	10309	f
São Lourenço do Bairro	Aveiro	Anadia	10310	f
Tamengos	Aveiro	Anadia	10311	f
Vila Nova de Monsarros	Aveiro	Anadia	10312	f
Vilarinho do Bairro	Aveiro	Anadia	10313	f
Paredes do Bairro	Aveiro	Anadia	10314	f
Aguim	Aveiro	Anadia	10315	f
Albergaria da Serra	Aveiro	Arouca	10401	f
Alvarenga	Aveiro	Arouca	10402	f
Arouca	Aveiro	Arouca	10403	f
Burgo	Aveiro	Arouca	10404	f
Cabreiros	Aveiro	Arouca	10405	f
Canelas	Aveiro	Arouca	10406	f
Chave	Aveiro	Arouca	10407	f
Covelo de Paivó	Aveiro	Arouca	10408	f
Escariz	Aveiro	Arouca	10409	f
Espiunca	Aveiro	Arouca	10410	f
Fermedo	Aveiro	Arouca	10411	f
Janarde	Aveiro	Arouca	10412	f
Mansores	Aveiro	Arouca	10413	f
Moldes	Aveiro	Arouca	10414	f
Rossas	Aveiro	Arouca	10415	f
Santa Eulália	Aveiro	Arouca	10416	f
São Miguel do Mato	Aveiro	Arouca	10417	f
Tropeço	Aveiro	Arouca	10418	f
Urrô	Aveiro	Arouca	10419	f
Várzea	Aveiro	Arouca	10420	f
Aradas	Aveiro	Aveiro	10501	f
Cacia	Aveiro	Aveiro	10502	f
Eirol	Aveiro	Aveiro	10503	f
Eixo	Aveiro	Aveiro	10504	f
Esgueira	Aveiro	Aveiro	10505	f
Glória	Aveiro	Aveiro	10506	f
Nariz	Aveiro	Aveiro	10507	f
Oliveirinha	Aveiro	Aveiro	10508	f
Requeixo	Aveiro	Aveiro	10509	f
São Bernardo	Aveiro	Aveiro	10510	f
São Jacinto	Aveiro	Aveiro	10511	f
Vera Cruz	Aveiro	Aveiro	10512	f
Santa Joana	Aveiro	Aveiro	10513	f
Nossa Senhora de Fátima	Aveiro	Aveiro	10514	f
Bairros	Aveiro	Castelo de Paiva	10601	f
Fornos	Aveiro	Castelo de Paiva	10602	f
Paraíso	Aveiro	Castelo de Paiva	10603	f
Pedorido	Aveiro	Castelo de Paiva	10604	f
Raiva	Aveiro	Castelo de Paiva	10605	f
Real	Aveiro	Castelo de Paiva	10606	f
Santa Maria de Sardoura	Aveiro	Castelo de Paiva	10607	f
São Martinho de Sardoura	Aveiro	Castelo de Paiva	10608	f
Sobrado	Aveiro	Castelo de Paiva	10609	f
Anta	Aveiro	Espinho	10701	f
Espinho	Aveiro	Espinho	10702	f
Guetim	Aveiro	Espinho	10703	f
Paramos	Aveiro	Espinho	10704	f
Silvalde	Aveiro	Espinho	10705	f
Avanca	Aveiro	Estarreja	10801	f
Beduído	Aveiro	Estarreja	10802	f
Canelas	Aveiro	Estarreja	10803	f
Fermelã	Aveiro	Estarreja	10804	f
Pardilhó	Aveiro	Estarreja	10805	f
Salreu	Aveiro	Estarreja	10806	f
Veiros	Aveiro	Estarreja	10807	f
Argoncilhe	Aveiro	Santa Maria da Feira	10901	f
Arrifana	Aveiro	Santa Maria da Feira	10902	f
Canedo	Aveiro	Santa Maria da Feira	10903	f
Escapães	Aveiro	Santa Maria da Feira	10904	f
Espargo	Aveiro	Santa Maria da Feira	10905	f
Feira	Aveiro	Santa Maria da Feira	10906	f
Fiães	Aveiro	Santa Maria da Feira	10907	f
Fornos	Aveiro	Santa Maria da Feira	10908	f
Gião	Aveiro	Santa Maria da Feira	10909	f
Guisande	Aveiro	Santa Maria da Feira	10910	f
Lobão	Aveiro	Santa Maria da Feira	10911	f
Louredo	Aveiro	Santa Maria da Feira	10912	f
Lourosa	Aveiro	Santa Maria da Feira	10913	f
Milheirós de Poiares	Aveiro	Santa Maria da Feira	10914	f
Mosteiró	Aveiro	Santa Maria da Feira	10915	f
Mozelos	Aveiro	Santa Maria da Feira	10916	f
Nogueira da Regedoura	Aveiro	Santa Maria da Feira	10917	f
São Paio de Oleiros	Aveiro	Santa Maria da Feira	10918	f
Paços de Brandão	Aveiro	Santa Maria da Feira	10919	f
Quintos	Beja	Beja	20507	f
Pigeiros	Aveiro	Santa Maria da Feira	10920	f
Rio Meão	Aveiro	Santa Maria da Feira	10921	f
Romariz	Aveiro	Santa Maria da Feira	10922	f
Sanfins	Aveiro	Santa Maria da Feira	10923	f
Sanguedo	Aveiro	Santa Maria da Feira	10924	f
Santa Maria de Lamas	Aveiro	Santa Maria da Feira	10925	f
São João de Ver	Aveiro	Santa Maria da Feira	10926	f
Caldas de São Jorge	Aveiro	Santa Maria da Feira	10927	f
Souto	Aveiro	Santa Maria da Feira	10928	f
Travanca	Aveiro	Santa Maria da Feira	10929	f
Vale	Aveiro	Santa Maria da Feira	10930	f
Vila Maior	Aveiro	Santa Maria da Feira	10931	f
Gafanha do Carmo	Aveiro	Ílhavo	11001	f
Gafanha da Encarnação	Aveiro	Ílhavo	11002	f
Gafanha da Nazaré	Aveiro	Ílhavo	11003	f
Ílhavo (São Salvador)	Aveiro	Ílhavo	11004	f
Antes	Aveiro	Mealhada	11101	f
Barcouço	Aveiro	Mealhada	11102	f
Casal Comba	Aveiro	Mealhada	11103	f
Luso	Aveiro	Mealhada	11104	f
Mealhada	Aveiro	Mealhada	11105	f
Pampilhosa	Aveiro	Mealhada	11106	f
Vacariça	Aveiro	Mealhada	11107	f
Ventosa do Bairro	Aveiro	Mealhada	11108	f
Bunheiro	Aveiro	Murtosa	11201	f
Monte	Aveiro	Murtosa	11202	f
Murtosa	Aveiro	Murtosa	11203	f
Torreira	Aveiro	Murtosa	11204	f
Carregosa	Aveiro	Oliveira de Azeméis	11301	f
Cesar	Aveiro	Oliveira de Azeméis	11302	f
Fajões	Aveiro	Oliveira de Azeméis	11303	f
Loureiro	Aveiro	Oliveira de Azeméis	11304	f
Macieira de Sarnes	Aveiro	Oliveira de Azeméis	11305	f
Macinhata da Seixa	Aveiro	Oliveira de Azeméis	11306	f
Madail	Aveiro	Oliveira de Azeméis	11307	f
Nogueira do Cravo	Aveiro	Oliveira de Azeméis	11308	f
Oliveira de Azeméis	Aveiro	Oliveira de Azeméis	11309	f
Ossela	Aveiro	Oliveira de Azeméis	11310	f
Palmaz	Aveiro	Oliveira de Azeméis	11311	f
Pindelo	Aveiro	Oliveira de Azeméis	11312	f
Pinheiro da Bemposta	Aveiro	Oliveira de Azeméis	11313	f
Santiago da Riba-Ul	Aveiro	Oliveira de Azeméis	11314	f
São Martinho da Gândara	Aveiro	Oliveira de Azeméis	11315	f
Travanca	Aveiro	Oliveira de Azeméis	11316	f
Ul	Aveiro	Oliveira de Azeméis	11317	f
São Roque	Aveiro	Oliveira de Azeméis	11318	f
Vila de Cucujães	Aveiro	Oliveira de Azeméis	11319	f
Bustos	Aveiro	Oliveira do Bairro	11401	f
Mamarrosa	Aveiro	Oliveira do Bairro	11402	f
Oiã	Aveiro	Oliveira do Bairro	11403	f
Oliveira do Bairro	Aveiro	Oliveira do Bairro	11404	f
Palhaça	Aveiro	Oliveira do Bairro	11405	f
Troviscal	Aveiro	Oliveira do Bairro	11406	f
Arada	Aveiro	Ovar	11501	f
Cortegaça	Aveiro	Ovar	11502	f
Esmoriz	Aveiro	Ovar	11503	f
Maceda	Aveiro	Ovar	11504	f
Ovar	Aveiro	Ovar	11505	f
São Vicente de Pereira Jusã	Aveiro	Ovar	11506	f
Válega	Aveiro	Ovar	11507	f
São João	Aveiro	Ovar	11508	f
São João da Madeira	Aveiro	São João da Madeira	11601	f
Cedrim	Aveiro	Sever do Vouga	11701	f
Couto de Esteves	Aveiro	Sever do Vouga	11702	f
Paradela	Aveiro	Sever do Vouga	11703	f
Pessegueiro do Vouga	Aveiro	Sever do Vouga	11704	f
Rocas do Vouga	Aveiro	Sever do Vouga	11705	f
Sever do Vouga	Aveiro	Sever do Vouga	11706	f
Silva Escura	Aveiro	Sever do Vouga	11707	f
Talhadas	Aveiro	Sever do Vouga	11708	f
Dornelas	Aveiro	Sever do Vouga	11709	f
Calvão	Aveiro	Vagos	11801	f
Covão do Lobo	Aveiro	Vagos	11802	f
Fonte de Angeão	Aveiro	Vagos	11803	f
Gafanha da Boa Hora	Aveiro	Vagos	11804	f
Ouca	Aveiro	Vagos	11805	f
Ponte de Vagos	Aveiro	Vagos	11806	f
Sosa	Aveiro	Vagos	11807	f
Vagos	Aveiro	Vagos	11808	f
Santo António de Vagos	Aveiro	Vagos	11809	f
Santo André de Vagos	Aveiro	Vagos	11810	f
Santa Catarina	Aveiro	Vagos	11811	f
Arões	Aveiro	Vale de Cambra	11901	f
São Pedro de Castelões	Aveiro	Vale de Cambra	11902	f
Cepelos	Aveiro	Vale de Cambra	11903	f
Codal	Aveiro	Vale de Cambra	11904	f
Junqueira	Aveiro	Vale de Cambra	11905	f
Macieira de Cambra	Aveiro	Vale de Cambra	11906	f
Roge	Aveiro	Vale de Cambra	11907	f
Vila Chã	Aveiro	Vale de Cambra	11908	f
Vila Cova de Perrinho	Aveiro	Vale de Cambra	11909	f
Aljustrel	Beja	Aljustrel	20101	f
Ervidel	Beja	Aljustrel	20102	f
Messejana	Beja	Aljustrel	20103	f
São João de Negrilhos	Beja	Aljustrel	20104	f
Rio de Moinhos	Beja	Aljustrel	20105	f
Almodôvar	Beja	Almodôvar	20201	f
Gomes Aires	Beja	Almodôvar	20202	f
Rosário	Beja	Almodôvar	20203	f
Santa Clara-a-Nova	Beja	Almodôvar	20204	f
Santa Cruz	Beja	Almodôvar	20205	f
São Barnabé	Beja	Almodôvar	20206	f
Senhora da Graça de Padrões	Beja	Almodôvar	20207	f
Aldeia dos Fernandes	Beja	Almodôvar	20208	f
Alvito	Beja	Alvito	20301	f
Vila Nova da Baronia	Beja	Alvito	20302	f
Barrancos	Beja	Barrancos	20401	f
Albernoa	Beja	Beja	20501	f
Baleizão	Beja	Beja	20502	f
Beringel	Beja	Beja	20503	f
Cabeça Gorda	Beja	Beja	20504	f
Mombeja	Beja	Beja	20505	f
Nossa Senhora das Neves	Beja	Beja	20506	f
Salvada	Beja	Beja	20508	f
Beja (Salvador)	Beja	Beja	20509	f
Santa Clara de Louredo	Beja	Beja	20510	f
Beja (Santa Maria da Feira)	Beja	Beja	20511	f
Santa Vitória	Beja	Beja	20512	f
Beja (Santiago Maior)	Beja	Beja	20513	f
São Brissos	Beja	Beja	20514	f
Beja (São João Baptista)	Beja	Beja	20515	f
São Matias	Beja	Beja	20516	f
Trindade	Beja	Beja	20517	f
Trigaches	Beja	Beja	20518	f
Casével	Beja	Castro Verde	20601	f
Castro Verde	Beja	Castro Verde	20602	f
Entradas	Beja	Castro Verde	20603	f
Santa Bárbara de Padrões	Beja	Castro Verde	20604	f
São Marcos da Ataboeira	Beja	Castro Verde	20605	f
Cuba	Beja	Cuba	20701	f
Faro do Alentejo	Beja	Cuba	20702	f
Vila Alva	Beja	Cuba	20703	f
Vila Ruiva	Beja	Cuba	20704	f
Alfundão	Beja	Ferreira do Alentejo	20801	f
Ferreira do Alentejo	Beja	Ferreira do Alentejo	20802	f
Figueira dos Cavaleiros	Beja	Ferreira do Alentejo	20803	f
Odivelas	Beja	Ferreira do Alentejo	20804	f
Peroguarda	Beja	Ferreira do Alentejo	20805	f
Canhestros	Beja	Ferreira do Alentejo	20806	f
Alcaria Ruiva	Beja	Mértola	20901	f
Corte do Pinto	Beja	Mértola	20902	f
Espírito Santo	Beja	Mértola	20903	f
Mértola	Beja	Mértola	20904	f
Santana de Cambas	Beja	Mértola	20905	f
São João dos Caldeireiros	Beja	Mértola	20906	f
São Miguel do Pinheiro	Beja	Mértola	20907	f
São Pedro de Solis	Beja	Mértola	20908	f
São Sebastião dos Carros	Beja	Mértola	20909	f
Amareleja	Beja	Moura	21001	f
Póvoa de São Miguel	Beja	Moura	21002	f
Safara	Beja	Moura	21003	f
Moura (Santo Agostinho)	Beja	Moura	21004	f
Santo Aleixo da Restauração	Beja	Moura	21005	f
Santo Amador	Beja	Moura	21006	f
Moura (São João Baptista)	Beja	Moura	21007	f
Sobral da Adiça	Beja	Moura	21008	f
Colos	Beja	Odemira	21101	f
Relíquias	Beja	Odemira	21102	f
Sabóia	Beja	Odemira	21103	f
Santa Clara-a-Velha	Beja	Odemira	21104	f
Odemira (Santa Maria)	Beja	Odemira	21105	f
São Luís	Beja	Odemira	21106	f
São Martinho das Amoreiras	Beja	Odemira	21107	f
Odemira (São Salvador)	Beja	Odemira	21108	f
São Teotónio	Beja	Odemira	21109	f
Vale de Santiago	Beja	Odemira	21110	f
Vila Nova de Milfontes	Beja	Odemira	21111	f
Pereiras-Gare	Beja	Odemira	21112	f
Bicos	Beja	Odemira	21113	f
Zambujeira do Mar	Beja	Odemira	21114	f
Luzianes-Gare	Beja	Odemira	21115	f
Boavista dos Pinheiros	Beja	Odemira	21116	f
Longueira/Almograve	Beja	Odemira	21117	f
Conceição	Beja	Ourique	21201	f
Garvão	Beja	Ourique	21202	f
Ourique	Beja	Ourique	21203	f
Panóias	Beja	Ourique	21204	f
Santa Luzia	Beja	Ourique	21205	f
Santana da Serra	Beja	Ourique	21206	f
Aldeia Nova de São Bento	Beja	Serpa	21301	f
Brinches	Beja	Serpa	21302	f
Pias	Beja	Serpa	21303	f
Serpa (Salvador)	Beja	Serpa	21304	f
Serpa (Santa Maria)	Beja	Serpa	21305	f
Vale de Vargo	Beja	Serpa	21306	f
Vila Verde de Ficalho	Beja	Serpa	21307	f
Pedrógão	Beja	Vidigueira	21401	f
Selmes	Beja	Vidigueira	21402	f
Vidigueira	Beja	Vidigueira	21403	f
Vila de Frades	Beja	Vidigueira	21404	f
Amares	Braga	Amares	30101	f
Barreiros	Braga	Amares	30102	f
Besteiros	Braga	Amares	30103	f
Bico	Braga	Amares	30104	f
Caires	Braga	Amares	30105	f
Caldelas	Braga	Amares	30106	f
Carrazedo	Braga	Amares	30107	f
Dornelas	Braga	Amares	30108	f
Ferreiros	Braga	Amares	30109	f
Figueiredo	Braga	Amares	30110	f
Fiscal	Braga	Amares	30111	f
Goães	Braga	Amares	30112	f
Lago	Braga	Amares	30113	f
Paranhos	Braga	Amares	30114	f
Paredes Secas	Braga	Amares	30115	f
Portela	Braga	Amares	30116	f
Prozelo	Braga	Amares	30117	f
Rendufe	Braga	Amares	30118	f
Bouro (Santa Maria)	Braga	Amares	30119	f
Bouro (Santa Marta)	Braga	Amares	30120	f
Sequeiros	Braga	Amares	30121	f
Seramil	Braga	Amares	30122	f
Torre	Braga	Amares	30123	f
Vilela	Braga	Amares	30124	f
Abade de Neiva	Braga	Barcelos	30201	f
Aborim	Braga	Barcelos	30202	f
Adães	Braga	Barcelos	30203	f
Aguiar	Braga	Barcelos	30204	f
Airó	Braga	Barcelos	30205	f
Aldreu	Braga	Barcelos	30206	f
Alheira	Braga	Barcelos	30207	f
Alvelos	Braga	Barcelos	30208	f
Arcozelo	Braga	Barcelos	30209	f
Areias	Braga	Barcelos	30210	f
Areias de Vilar	Braga	Barcelos	30211	f
Balugães	Braga	Barcelos	30212	f
Barcelinhos	Braga	Barcelos	30213	f
Barcelos	Braga	Barcelos	30214	f
Barqueiros	Braga	Barcelos	30215	f
Cambeses	Braga	Barcelos	30216	f
Campo	Braga	Barcelos	30217	f
Carapeços	Braga	Barcelos	30218	f
Carreira	Braga	Barcelos	30219	f
Carvalhal	Braga	Barcelos	30220	f
Carvalhos	Braga	Barcelos	30221	f
Chavão	Braga	Barcelos	30222	f
Chorente	Braga	Barcelos	30223	f
Cossourado	Braga	Barcelos	30224	f
Courel	Braga	Barcelos	30225	f
Couto	Braga	Barcelos	30226	f
Creixomil	Braga	Barcelos	30227	f
Cristelo	Braga	Barcelos	30228	f
Durrães	Braga	Barcelos	30229	f
Encourados	Braga	Barcelos	30230	f
Faria	Braga	Barcelos	30231	f
Feitos	Braga	Barcelos	30232	f
Fonte Coberta	Braga	Barcelos	30233	f
Fornelos	Braga	Barcelos	30234	f
Fragoso	Braga	Barcelos	30235	f
Gamil	Braga	Barcelos	30236	f
Gilmonde	Braga	Barcelos	30237	f
Góios	Braga	Barcelos	30238	f
Grimancelos	Braga	Barcelos	30239	f
Gueral	Braga	Barcelos	30240	f
Igreja Nova	Braga	Barcelos	30241	f
Lama	Braga	Barcelos	30242	f
Lijó	Braga	Barcelos	30243	f
Macieira de Rates	Braga	Barcelos	30244	f
Manhente	Braga	Barcelos	30245	f
Mariz	Braga	Barcelos	30246	f
Martim	Braga	Barcelos	30247	f
Midões	Braga	Barcelos	30248	f
Milhazes	Braga	Barcelos	30249	f
Minhotães	Braga	Barcelos	30250	f
Monte de Fralães	Braga	Barcelos	30251	f
Moure	Braga	Barcelos	30252	f
Negreiros	Braga	Barcelos	30253	f
Oliveira	Braga	Barcelos	30254	f
Palme	Braga	Barcelos	30255	f
Panque	Braga	Barcelos	30256	f
Paradela	Braga	Barcelos	30257	f
Pedra Furada	Braga	Barcelos	30258	f
Pereira	Braga	Barcelos	30259	f
Perelhal	Braga	Barcelos	30260	f
Pousa	Braga	Barcelos	30261	f
Quintiães	Braga	Barcelos	30262	f
Remelhe	Braga	Barcelos	30263	f
Roriz	Braga	Barcelos	30264	f
Rio Covo (Santa Eugénia)	Braga	Barcelos	30265	f
Rio Covo (Santa Eulália)	Braga	Barcelos	30266	f
Tamel (Santa Leocádia)	Braga	Barcelos	30267	f
Galegos (Santa Maria)	Braga	Barcelos	30268	f
Bastuço (Santo Estêvão)	Braga	Barcelos	30269	f
Bastuço (São João)	Braga	Barcelos	30270	f
Alvito (São Martinho)	Braga	Barcelos	30271	f
Galegos (São Martinho)	Braga	Barcelos	30272	f
Vila Frescainha (São Martinho)	Braga	Barcelos	30273	f
Alvito (São Pedro)	Braga	Barcelos	30274	f
Vila Frescainha (São Pedro)	Braga	Barcelos	30275	f
Tamel (São Pedro Fins)	Braga	Barcelos	30276	f
Tamel (São Veríssimo)	Braga	Barcelos	30277	f
Sequeade	Braga	Barcelos	30278	f
Silva	Braga	Barcelos	30279	f
Silveiros	Braga	Barcelos	30280	f
Tregosa	Braga	Barcelos	30281	f
Ucha	Braga	Barcelos	30282	f
Várzea	Braga	Barcelos	30283	f
Viatodos	Braga	Barcelos	30284	f
Vila Boa	Braga	Barcelos	30285	f
Vila Cova	Braga	Barcelos	30286	f
Vila Seca	Braga	Barcelos	30287	f
Vilar de Figos	Braga	Barcelos	30288	f
Vilar do Monte	Braga	Barcelos	30289	f
Adaúfe	Braga	Braga	30301	f
Arcos	Braga	Braga	30302	f
Arentim	Braga	Braga	30303	f
Aveleda	Braga	Braga	30304	f
Cabreiros	Braga	Braga	30305	f
Celeirós	Braga	Braga	30306	f
Braga (Cividade)	Braga	Braga	30307	f
Crespos	Braga	Braga	30308	f
Cunha	Braga	Braga	30309	f
Dume	Braga	Braga	30310	f
Escudeiros	Braga	Braga	30311	f
Espinho	Braga	Braga	30312	f
Esporões	Braga	Braga	30313	f
Ferreiros	Braga	Braga	30314	f
Figueiredo	Braga	Braga	30315	f
Fraião	Braga	Braga	30316	f
Frossos	Braga	Braga	30317	f
Gondizalves	Braga	Braga	30318	f
Gualtar	Braga	Braga	30319	f
Guisande	Braga	Braga	30320	f
Lamaçães	Braga	Braga	30321	f
Lamas	Braga	Braga	30322	f
Lomar	Braga	Braga	30323	f
Braga (Maximinos)	Braga	Braga	30324	f
Mire de Tibães	Braga	Braga	30325	f
Morreira	Braga	Braga	30326	f
Navarra	Braga	Braga	30327	f
Nogueira	Braga	Braga	30328	f
Nogueiró	Braga	Braga	30329	f
Padim da Graça	Braga	Braga	30330	f
Palmeira	Braga	Braga	30331	f
Panoias	Braga	Braga	30332	f
Parada de Tibães	Braga	Braga	30333	f
Pedralva	Braga	Braga	30334	f
Pousada	Braga	Braga	30335	f
Priscos	Braga	Braga	30336	f
Real	Braga	Braga	30337	f
Ruilhe	Braga	Braga	30338	f
Santa Lucrécia de Algeriz	Braga	Braga	30339	f
Penso (Santo Estêvão)	Braga	Braga	30340	f
Braga (São João do Souto)	Braga	Braga	30341	f
Braga (São José de São Lázaro)	Braga	Braga	30342	f
Passos (São Julião)	Braga	Braga	30343	f
Este (São Mamede)	Braga	Braga	30344	f
Merelim (São Paio)	Braga	Braga	30345	f
Este (São Pedro)	Braga	Braga	30346	f
Merelim (São Pedro)	Braga	Braga	30347	f
Oliveira (São Pedro)	Braga	Braga	30348	f
Braga (São Vicente)	Braga	Braga	30349	f
Penso (São Vicente)	Braga	Braga	30350	f
Braga (São Vítor)	Braga	Braga	30351	f
Braga (Sé)	Braga	Braga	30352	f
Semelhe	Braga	Braga	30353	f
Sequeira	Braga	Braga	30354	f
Sobreposta	Braga	Braga	30355	f
Tadim	Braga	Braga	30356	f
Tebosa	Braga	Braga	30357	f
Tenões	Braga	Braga	30358	f
Trandeiras	Braga	Braga	30359	f
Vilaça	Braga	Braga	30360	f
Vimieiro	Braga	Braga	30361	f
Fradelos	Braga	Braga	30362	f
Abadim	Braga	Cabeceiras de Basto	30401	f
Alvite	Braga	Cabeceiras de Basto	30402	f
Arco de Baúlhe	Braga	Cabeceiras de Basto	30403	f
Basto	Braga	Cabeceiras de Basto	30404	f
Bucos	Braga	Cabeceiras de Basto	30405	f
Cabeceiras de Basto	Braga	Cabeceiras de Basto	30406	f
Cavez	Braga	Cabeceiras de Basto	30407	f
Faia	Braga	Cabeceiras de Basto	30408	f
Gondiães	Braga	Cabeceiras de Basto	30409	f
Outeiro	Braga	Cabeceiras de Basto	30410	f
Painzela	Braga	Cabeceiras de Basto	30411	f
Passos	Braga	Cabeceiras de Basto	30412	f
Pedraça	Braga	Cabeceiras de Basto	30413	f
Refojos de Basto	Braga	Cabeceiras de Basto	30414	f
Rio Douro	Braga	Cabeceiras de Basto	30415	f
Vila Nune	Braga	Cabeceiras de Basto	30416	f
Vilar de Cunhas	Braga	Cabeceiras de Basto	30417	f
Agilde	Braga	Celorico de Basto	30501	f
Arnóia	Braga	Celorico de Basto	30502	f
Borba de Montanha	Braga	Celorico de Basto	30503	f
Britelo	Braga	Celorico de Basto	30504	f
Caçarilhe	Braga	Celorico de Basto	30505	f
Canedo de Basto	Braga	Celorico de Basto	30506	f
Carvalho	Braga	Celorico de Basto	30507	f
Codeçoso	Braga	Celorico de Basto	30508	f
Corgo	Braga	Celorico de Basto	30509	f
Fervença	Braga	Celorico de Basto	30510	f
Gagos	Braga	Celorico de Basto	30511	f
Gémeos	Braga	Celorico de Basto	30512	f
Infesta	Braga	Celorico de Basto	30513	f
Molares	Braga	Celorico de Basto	30514	f
Moreira do Castelo	Braga	Celorico de Basto	30515	f
Ourilhe	Braga	Celorico de Basto	30516	f
Rego	Braga	Celorico de Basto	30517	f
Ribas	Braga	Celorico de Basto	30518	f
Basto (Santa Tecla)	Braga	Celorico de Basto	30519	f
Basto (São Clemente)	Braga	Celorico de Basto	30520	f
Vale de Bouro	Braga	Celorico de Basto	30521	f
Veade	Braga	Celorico de Basto	30522	f
Antas	Braga	Esposende	30601	f
Apúlia	Braga	Esposende	30602	f
Belinho	Braga	Esposende	30603	f
Curvos	Braga	Esposende	30604	f
Esposende	Braga	Esposende	30605	f
Fão	Braga	Esposende	30606	f
Fonte Boa	Braga	Esposende	30607	f
Forjães	Braga	Esposende	30608	f
Gandra	Braga	Esposende	30609	f
Gemeses	Braga	Esposende	30610	f
Mar	Braga	Esposende	30611	f
Marinhas	Braga	Esposende	30612	f
Palmeira de Faro	Braga	Esposende	30613	f
Rio Tinto	Braga	Esposende	30614	f
Vila Chã	Braga	Esposende	30615	f
Aboim	Braga	Fafe	30701	f
Agrela	Braga	Fafe	30702	f
Antime	Braga	Fafe	30703	f
Ardegão	Braga	Fafe	30704	f
Armil	Braga	Fafe	30705	f
Arnozela	Braga	Fafe	30706	f
Cepães	Braga	Fafe	30707	f
Estorãos	Braga	Fafe	30708	f
Fafe	Braga	Fafe	30709	f
Fareja	Braga	Fafe	30710	f
Felgueiras	Braga	Fafe	30711	f
Fornelos	Braga	Fafe	30712	f
Freitas	Braga	Fafe	30713	f
Golães	Braga	Fafe	30714	f
Gontim	Braga	Fafe	30715	f
Medelo	Braga	Fafe	30716	f
Monte	Braga	Fafe	30717	f
Moreira do Rei	Braga	Fafe	30718	f
Passos	Braga	Fafe	30719	f
Pedraído	Braga	Fafe	30720	f
Queimadela	Braga	Fafe	30721	f
Quinchães	Braga	Fafe	30722	f
Regadas	Braga	Fafe	30723	f
Revelhe	Braga	Fafe	30724	f
Ribeiros	Braga	Fafe	30725	f
Arões (Santa Cristina)	Braga	Fafe	30726	f
Silvares (São Clemente)	Braga	Fafe	30727	f
São Gens	Braga	Fafe	30728	f
Silvares (São Martinho)	Braga	Fafe	30729	f
Arões (São Romão)	Braga	Fafe	30730	f
Seidões	Braga	Fafe	30731	f
Serafão	Braga	Fafe	30732	f
Travassós	Braga	Fafe	30733	f
Várzea Cova	Braga	Fafe	30734	f
Vila Cova	Braga	Fafe	30735	f
Vinhós	Braga	Fafe	30736	f
Aldão	Braga	Guimarães	30801	f
Arosa	Braga	Guimarães	30802	f
Atães	Braga	Guimarães	30803	f
Azurém	Braga	Guimarães	30804	f
Balazar	Braga	Guimarães	30805	f
Barco	Braga	Guimarães	30806	f
Brito	Braga	Guimarães	30807	f
Caldelas	Braga	Guimarães	30808	f
Calvos	Braga	Guimarães	30809	f
Castelões	Braga	Guimarães	30810	f
Conde	Braga	Guimarães	30811	f
Costa	Braga	Guimarães	30812	f
Creixomil	Braga	Guimarães	30813	f
Donim	Braga	Guimarães	30814	f
Fermentões	Braga	Guimarães	30815	f
Figueiredo	Braga	Guimarães	30816	f
Gandarela	Braga	Guimarães	30817	f
Gémeos	Braga	Guimarães	30818	f
Gominhães	Braga	Guimarães	30819	f
Gonça	Braga	Guimarães	30820	f
Gondar	Braga	Guimarães	30821	f
Gondomar	Braga	Guimarães	30822	f
Guardizela	Braga	Guimarães	30823	f
Infantas	Braga	Guimarães	30824	f
Leitões	Braga	Guimarães	30826	f
Longos	Braga	Guimarães	30827	f
Lordelo	Braga	Guimarães	30828	f
Mascotelos	Braga	Guimarães	30829	f
Mesão Frio	Braga	Guimarães	30830	f
Moreira de Cónegos	Braga	Guimarães	30831	f
Nespereira	Braga	Guimarães	30832	f
Oleiros	Braga	Guimarães	30833	f
Guimarães (Oliveira do Castelo)	Braga	Guimarães	30834	f
Pencelo	Braga	Guimarães	30835	f
Pinheiro	Braga	Guimarães	30836	f
Polvoreira	Braga	Guimarães	30837	f
Ponte	Braga	Guimarães	30838	f
Rendufe	Braga	Guimarães	30839	f
Ronfe	Braga	Guimarães	30840	f
Briteiros (Salvador)	Braga	Guimarães	30841	f
Prazins (Santa Eufémia)	Braga	Guimarães	30842	f
Briteiros (Santa Leocádia)	Braga	Guimarães	30843	f
Airão (Santa Maria)	Braga	Guimarães	30844	f
Souto (Santa Maria)	Braga	Guimarães	30845	f
Candoso (Santiago)	Braga	Guimarães	30846	f
Briteiros (Santo Estêvão)	Braga	Guimarães	30847	f
Prazins (Santo Tirso)	Braga	Guimarães	30848	f
Sande (São Clemente)	Braga	Guimarães	30849	f
Selho (São Cristóvão)	Braga	Guimarães	30850	f
São Faustino	Braga	Guimarães	30851	f
Airão (São João Baptista)	Braga	Guimarães	30853	f
Selho (São Jorge)	Braga	Guimarães	30854	f
Sande (São Lourenço)	Braga	Guimarães	30855	f
Selho (São Lourenço)	Braga	Guimarães	30856	f
Candoso (São Martinho)	Braga	Guimarães	30857	f
Sande (São Martinho)	Braga	Guimarães	30858	f
Guimarães (São Paio)	Braga	Guimarães	30860	f
Souto (São Salvador)	Braga	Guimarães	30862	f
Guimarães (São Sebastião)	Braga	Guimarães	30863	f
Abação (São Tomé)	Braga	Guimarães	30864	f
São Torcato	Braga	Guimarães	30865	f
Serzedelo	Braga	Guimarães	30866	f
Serzedo	Braga	Guimarães	30867	f
Silvares	Braga	Guimarães	30868	f
Tabuadelo	Braga	Guimarães	30869	f
Urgezes	Braga	Guimarães	30871	f
Vermil	Braga	Guimarães	30872	f
Sande (Vila Nova)	Braga	Guimarães	30873	f
Águas Santas	Braga	Póvoa de Lanhoso	30901	f
Ajude	Braga	Póvoa de Lanhoso	30902	f
Brunhais	Braga	Póvoa de Lanhoso	30903	f
Calvos	Braga	Póvoa de Lanhoso	30904	f
Campos	Braga	Póvoa de Lanhoso	30905	f
Covelas	Braga	Póvoa de Lanhoso	30906	f
Esperança	Braga	Póvoa de Lanhoso	30907	f
Ferreiros	Braga	Póvoa de Lanhoso	30908	f
Fonte Arcada	Braga	Póvoa de Lanhoso	30909	f
Frades	Braga	Póvoa de Lanhoso	30910	f
Friande	Braga	Póvoa de Lanhoso	30911	f
Galegos	Braga	Póvoa de Lanhoso	30912	f
Garfe	Braga	Póvoa de Lanhoso	30913	f
Geraz do Minho	Braga	Póvoa de Lanhoso	30914	f
Lanhoso	Braga	Póvoa de Lanhoso	30915	f
Louredo	Braga	Póvoa de Lanhoso	30916	f
Monsul	Braga	Póvoa de Lanhoso	30917	f
Moure	Braga	Póvoa de Lanhoso	30918	f
Póvoa de Lanhoso (N Senhora do Amparo)	Braga	Póvoa de Lanhoso	30919	f
Oliveira	Braga	Póvoa de Lanhoso	30920	f
Rendufinho	Braga	Póvoa de Lanhoso	30921	f
Santo Emilião	Braga	Póvoa de Lanhoso	30922	f
São João de Rei	Braga	Póvoa de Lanhoso	30923	f
Serzedelo	Braga	Póvoa de Lanhoso	30924	f
Sobradelo da Goma	Braga	Póvoa de Lanhoso	30925	f
Taíde	Braga	Póvoa de Lanhoso	30926	f
Travassos	Braga	Póvoa de Lanhoso	30927	f
Verim	Braga	Póvoa de Lanhoso	30928	f
Vilela	Braga	Póvoa de Lanhoso	30929	f
Balança	Braga	Terras de Bouro	31001	f
Brufe	Braga	Terras de Bouro	31002	f
Campo do Gerês	Braga	Terras de Bouro	31003	f
Carvalheira	Braga	Terras de Bouro	31004	f
Chamoim	Braga	Terras de Bouro	31005	f
Chorense	Braga	Terras de Bouro	31006	f
Cibões	Braga	Terras de Bouro	31007	f
Covide	Braga	Terras de Bouro	31008	f
Gondoriz	Braga	Terras de Bouro	31009	f
Moimenta	Braga	Terras de Bouro	31010	f
Monte	Braga	Terras de Bouro	31011	f
Ribeira	Braga	Terras de Bouro	31012	f
Rio Caldo	Braga	Terras de Bouro	31013	f
Souto	Braga	Terras de Bouro	31014	f
Valdosende	Braga	Terras de Bouro	31015	f
Vilar	Braga	Terras de Bouro	31016	f
Vilar da Veiga	Braga	Terras de Bouro	31017	f
Anissó	Braga	Vieira do Minho	31101	f
Anjos	Braga	Vieira do Minho	31102	f
Campos	Braga	Vieira do Minho	31103	f
Caniçada	Braga	Vieira do Minho	31104	f
Cantelães	Braga	Vieira do Minho	31105	f
Cova	Braga	Vieira do Minho	31106	f
Eira Vedra	Braga	Vieira do Minho	31107	f
Guilhofrei	Braga	Vieira do Minho	31108	f
Louredo	Braga	Vieira do Minho	31109	f
Mosteiro	Braga	Vieira do Minho	31110	f
Parada do Bouro	Braga	Vieira do Minho	31111	f
Pinheiro	Braga	Vieira do Minho	31112	f
Rossas	Braga	Vieira do Minho	31113	f
Ruivães	Braga	Vieira do Minho	31114	f
Salamonde	Braga	Vieira do Minho	31115	f
Soengas	Braga	Vieira do Minho	31116	f
Soutelo	Braga	Vieira do Minho	31117	f
Tabuaças	Braga	Vieira do Minho	31118	f
Ventosa	Braga	Vieira do Minho	31119	f
Vieira do Minho	Braga	Vieira do Minho	31120	f
Vilar do Chão	Braga	Vieira do Minho	31121	f
Abade de Vermoim	Braga	Vila Nova de Famalicão	31201	f
Antas	Braga	Vila Nova de Famalicão	31202	f
Avidos	Braga	Vila Nova de Famalicão	31203	f
Bairro	Braga	Vila Nova de Famalicão	31204	f
Bente	Braga	Vila Nova de Famalicão	31205	f
Brufe	Braga	Vila Nova de Famalicão	31206	f
Cabeçudos	Braga	Vila Nova de Famalicão	31207	f
Calendário	Braga	Vila Nova de Famalicão	31208	f
Carreira	Braga	Vila Nova de Famalicão	31209	f
Castelões	Braga	Vila Nova de Famalicão	31210	f
Cavalões	Braga	Vila Nova de Famalicão	31211	f
Cruz	Braga	Vila Nova de Famalicão	31212	f
Delães	Braga	Vila Nova de Famalicão	31213	f
Esmeriz	Braga	Vila Nova de Famalicão	31214	f
Fradelos	Braga	Vila Nova de Famalicão	31215	f
Gavião	Braga	Vila Nova de Famalicão	31216	f
Gondifelos	Braga	Vila Nova de Famalicão	31217	f
Jesufrei	Braga	Vila Nova de Famalicão	31218	f
Joane	Braga	Vila Nova de Famalicão	31219	f
Lagoa	Braga	Vila Nova de Famalicão	31220	f
Landim	Braga	Vila Nova de Famalicão	31221	f
Lemenhe	Braga	Vila Nova de Famalicão	31222	f
Louro	Braga	Vila Nova de Famalicão	31223	f
Lousado	Braga	Vila Nova de Famalicão	31224	f
Mogege	Braga	Vila Nova de Famalicão	31225	f
Mouquim	Braga	Vila Nova de Famalicão	31226	f
Nine	Braga	Vila Nova de Famalicão	31227	f
Novais	Braga	Vila Nova de Famalicão	31228	f
Outiz	Braga	Vila Nova de Famalicão	31229	f
Pedome	Braga	Vila Nova de Famalicão	31230	f
Portela	Braga	Vila Nova de Famalicão	31231	f
Pousada de Saramagos	Braga	Vila Nova de Famalicão	31232	f
Requião	Braga	Vila Nova de Famalicão	31233	f
Riba de Ave	Braga	Vila Nova de Famalicão	31234	f
Ribeirão	Braga	Vila Nova de Famalicão	31235	f
Ruivães	Braga	Vila Nova de Famalicão	31236	f
Arnoso (Santa Eulália)	Braga	Vila Nova de Famalicão	31237	f
Arnoso (Santa Maria)	Braga	Vila Nova de Famalicão	31238	f
Oliveira (Santa Maria)	Braga	Vila Nova de Famalicão	31239	f
Vale (São Cosme)	Braga	Vila Nova de Famalicão	31240	f
Vale (São Martinho)	Braga	Vila Nova de Famalicão	31241	f
Oliveira (São Mateus)	Braga	Vila Nova de Famalicão	31242	f
Seide (São Miguel)	Braga	Vila Nova de Famalicão	31243	f
Seide (São Paio)	Braga	Vila Nova de Famalicão	31244	f
Sezures	Braga	Vila Nova de Famalicão	31245	f
Telhado	Braga	Vila Nova de Famalicão	31246	f
Vermoim	Braga	Vila Nova de Famalicão	31247	f
Vila Nova de Famalicão	Braga	Vila Nova de Famalicão	31248	f
Vilarinho das Cambas	Braga	Vila Nova de Famalicão	31249	f
Aboim da Nóbrega	Braga	Vila Verde	31301	f
Arcozelo	Braga	Vila Verde	31302	f
Atães	Braga	Vila Verde	31303	f
Atiães	Braga	Vila Verde	31304	f
Azões	Braga	Vila Verde	31305	f
Barbudo	Braga	Vila Verde	31306	f
Barros	Braga	Vila Verde	31307	f
Cabanelas	Braga	Vila Verde	31308	f
Cervães	Braga	Vila Verde	31309	f
Codeceda	Braga	Vila Verde	31310	f
Coucieiro	Braga	Vila Verde	31311	f
Covas	Braga	Vila Verde	31312	f
Dossãos	Braga	Vila Verde	31313	f
Duas Igrejas	Braga	Vila Verde	31314	f
Esqueiros	Braga	Vila Verde	31315	f
Freiriz	Braga	Vila Verde	31316	f
Geme	Braga	Vila Verde	31317	f
Goães	Braga	Vila Verde	31318	f
Godinhaços	Braga	Vila Verde	31319	f
Gomide	Braga	Vila Verde	31320	f
Gondiães	Braga	Vila Verde	31321	f
Gondomar	Braga	Vila Verde	31322	f
Laje	Braga	Vila Verde	31323	f
Lanhas	Braga	Vila Verde	31324	f
Loureira	Braga	Vila Verde	31325	f
Marrancos	Braga	Vila Verde	31326	f
Mós	Braga	Vila Verde	31327	f
Moure	Braga	Vila Verde	31328	f
Nevogilde	Braga	Vila Verde	31329	f
Oleiros	Braga	Vila Verde	31330	f
Parada de Gatim	Braga	Vila Verde	31331	f
Passó	Braga	Vila Verde	31332	f
Pedregais	Braga	Vila Verde	31333	f
Penascais	Braga	Vila Verde	31334	f
Pico	Braga	Vila Verde	31335	f
Pico de Regalados	Braga	Vila Verde	31336	f
Ponte	Braga	Vila Verde	31337	f
Portela das Cabras	Braga	Vila Verde	31338	f
Rio Mau	Braga	Vila Verde	31339	f
Sabariz	Braga	Vila Verde	31340	f
Sande	Braga	Vila Verde	31341	f
Vila do Prado	Braga	Vila Verde	31342	f
Oriz (Santa Marinha)	Braga	Vila Verde	31343	f
Carreiras (Santiago)	Braga	Vila Verde	31344	f
Escariz (São Mamede)	Braga	Vila Verde	31345	f
Escariz (São Martinho)	Braga	Vila Verde	31346	f
Valbom (São Martinho)	Braga	Vila Verde	31347	f
Carreiras (São Miguel)	Braga	Vila Verde	31348	f
Oriz (São Miguel)	Braga	Vila Verde	31349	f
Prado (São Miguel)	Braga	Vila Verde	31350	f
Valbom (São Pedro)	Braga	Vila Verde	31351	f
Soutelo	Braga	Vila Verde	31352	f
Travassós	Braga	Vila Verde	31353	f
Turiz	Braga	Vila Verde	31354	f
Valdreu	Braga	Vila Verde	31355	f
Valões	Braga	Vila Verde	31356	f
Vila Verde	Braga	Vila Verde	31357	f
Vilarinho	Braga	Vila Verde	31358	f
Santa Eulália	Braga	Vizela	31401	f
Caldas de Vizela (São João)	Braga	Vizela	31402	f
Caldas de Vizela (São Miguel)	Braga	Vizela	31403	f
Infias	Braga	Vizela	31404	f
Tagilde	Braga	Vizela	31405	f
Vizela (Santo Adrião)	Braga	Vizela	31406	f
Vizela (São Paio)	Braga	Vizela	31407	f
Agrobom	Bragança	Alfândega da Fé	40101	f
Alfândega da Fé	Bragança	Alfândega da Fé	40102	f
Cerejais	Bragança	Alfândega da Fé	40103	f
Eucisia	Bragança	Alfândega da Fé	40104	f
Ferradosa	Bragança	Alfândega da Fé	40105	f
Gebelim	Bragança	Alfândega da Fé	40106	f
Gouveia	Bragança	Alfândega da Fé	40107	f
Parada	Bragança	Alfândega da Fé	40108	f
Pombal	Bragança	Alfândega da Fé	40109	f
Saldonha	Bragança	Alfândega da Fé	40110	f
Sambade	Bragança	Alfândega da Fé	40111	f
Sendim da Ribeira	Bragança	Alfândega da Fé	40112	f
Sendim da Serra	Bragança	Alfândega da Fé	40113	f
Soeima	Bragança	Alfândega da Fé	40114	f
Vale Pereiro	Bragança	Alfândega da Fé	40115	f
Vales	Bragança	Alfândega da Fé	40116	f
Valverde	Bragança	Alfândega da Fé	40117	f
Vilar Chão	Bragança	Alfândega da Fé	40118	f
Vilarelhos	Bragança	Alfândega da Fé	40119	f
Vilares de Vilariça	Bragança	Alfândega da Fé	40120	f
Alfaião	Bragança	Bragança	40201	f
Aveleda	Bragança	Bragança	40202	f
Babe	Bragança	Bragança	40203	f
Baçal	Bragança	Bragança	40204	f
Calvelhe	Bragança	Bragança	40205	f
Carragosa	Bragança	Bragança	40206	f
Carrazedo	Bragança	Bragança	40207	f
Castrelos	Bragança	Bragança	40208	f
Castro de Avelãs	Bragança	Bragança	40209	f
Coelhoso	Bragança	Bragança	40210	f
Deilão	Bragança	Bragança	40211	f
Donai	Bragança	Bragança	40212	f
Espinhosela	Bragança	Bragança	40213	f
Failde	Bragança	Bragança	40214	f
França	Bragança	Bragança	40215	f
Gimonde	Bragança	Bragança	40216	f
Gondesende	Bragança	Bragança	40217	f
Gostei	Bragança	Bragança	40218	f
Grijó de Parada	Bragança	Bragança	40219	f
Izeda	Bragança	Bragança	40220	f
Macedo do Mato	Bragança	Bragança	40221	f
Meixedo	Bragança	Bragança	40222	f
Milhão	Bragança	Bragança	40223	f
Mós	Bragança	Bragança	40224	f
Nogueira	Bragança	Bragança	40225	f
Outeiro	Bragança	Bragança	40226	f
Parada	Bragança	Bragança	40227	f
Paradinha Nova	Bragança	Bragança	40228	f
Parâmio	Bragança	Bragança	40229	f
Pinela	Bragança	Bragança	40230	f
Pombares	Bragança	Bragança	40231	f
Quintanilha	Bragança	Bragança	40232	f
Quintela de Lampaças	Bragança	Bragança	40233	f
Rabal	Bragança	Bragança	40234	f
Rebordainhos	Bragança	Bragança	40235	f
Rebordãos	Bragança	Bragança	40236	f
Rio Frio	Bragança	Bragança	40237	f
Rio de Onor	Bragança	Bragança	40238	f
Salsas	Bragança	Bragança	40239	f
Samil	Bragança	Bragança	40240	f
Santa Comba de Rossas	Bragança	Bragança	40241	f
Bragança (Santa Maria)	Bragança	Bragança	40242	f
São Julião de Palácios	Bragança	Bragança	40243	f
São Pedro de Sarracenos	Bragança	Bragança	40244	f
Bragança (Sé)	Bragança	Bragança	40245	f
Sendas	Bragança	Bragança	40246	f
Serapicos	Bragança	Bragança	40247	f
Sortes	Bragança	Bragança	40248	f
Zoio	Bragança	Bragança	40249	f
Amedo	Bragança	Carrazeda de Ansiães	40301	f
Beira Grande	Bragança	Carrazeda de Ansiães	40302	f
Belver	Bragança	Carrazeda de Ansiães	40303	f
Carrazeda de Ansiães	Bragança	Carrazeda de Ansiães	40304	f
Castanheiro	Bragança	Carrazeda de Ansiães	40305	f
Fonte Longa	Bragança	Carrazeda de Ansiães	40306	f
Lavandeira	Bragança	Carrazeda de Ansiães	40307	f
Linhares	Bragança	Carrazeda de Ansiães	40308	f
Marzagão	Bragança	Carrazeda de Ansiães	40309	f
Mogo de Malta	Bragança	Carrazeda de Ansiães	40310	f
Parambos	Bragança	Carrazeda de Ansiães	40311	f
Pereiros	Bragança	Carrazeda de Ansiães	40312	f
Pinhal do Norte	Bragança	Carrazeda de Ansiães	40313	f
Pombal	Bragança	Carrazeda de Ansiães	40314	f
Ribalonga	Bragança	Carrazeda de Ansiães	40315	f
Seixo de Ansiães	Bragança	Carrazeda de Ansiães	40316	f
Selores	Bragança	Carrazeda de Ansiães	40317	f
Vilarinho da Castanheira	Bragança	Carrazeda de Ansiães	40318	f
Zedes	Bragança	Carrazeda de Ansiães	40319	f
Fornos	Bragança	Freixo de Espada à Cinta	40401	f
Freixo de Espada à Cinta	Bragança	Freixo de Espada à Cinta	40402	f
Lagoaça	Bragança	Freixo de Espada à Cinta	40403	f
Ligares	Bragança	Freixo de Espada à Cinta	40404	f
Mazouco	Bragança	Freixo de Espada à Cinta	40405	f
Poiares	Bragança	Freixo de Espada à Cinta	40406	f
Ala	Bragança	Macedo de Cavaleiros	40501	f
Amendoeira	Bragança	Macedo de Cavaleiros	40502	f
Arcas	Bragança	Macedo de Cavaleiros	40503	f
Bagueixe	Bragança	Macedo de Cavaleiros	40504	f
Bornes	Bragança	Macedo de Cavaleiros	40505	f
Burga	Bragança	Macedo de Cavaleiros	40506	f
Carrapatas	Bragança	Macedo de Cavaleiros	40507	f
Castelãos	Bragança	Macedo de Cavaleiros	40508	f
Chacim	Bragança	Macedo de Cavaleiros	40509	f
Cortiços	Bragança	Macedo de Cavaleiros	40510	f
Corujas	Bragança	Macedo de Cavaleiros	40511	f
Edroso	Bragança	Macedo de Cavaleiros	40512	f
Espadanedo	Bragança	Macedo de Cavaleiros	40513	f
Ferreira	Bragança	Macedo de Cavaleiros	40514	f
Grijó de Vale Benfeito	Bragança	Macedo de Cavaleiros	40515	f
Lagoa	Bragança	Macedo de Cavaleiros	40516	f
Lamalonga	Bragança	Macedo de Cavaleiros	40517	f
Lamas de Podence	Bragança	Macedo de Cavaleiros	40518	f
Lombo	Bragança	Macedo de Cavaleiros	40519	f
Macedo de Cavaleiros	Bragança	Macedo de Cavaleiros	40520	f
Morais	Bragança	Macedo de Cavaleiros	40521	f
Murçós	Bragança	Macedo de Cavaleiros	40522	f
Olmos	Bragança	Macedo de Cavaleiros	40523	f
Peredo	Bragança	Macedo de Cavaleiros	40524	f
Podence	Bragança	Macedo de Cavaleiros	40525	f
Salselas	Bragança	Macedo de Cavaleiros	40526	f
Santa Combinha	Bragança	Macedo de Cavaleiros	40527	f
Sesulfe	Bragança	Macedo de Cavaleiros	40528	f
Soutelo Mourisco	Bragança	Macedo de Cavaleiros	40529	f
Talhas	Bragança	Macedo de Cavaleiros	40530	f
Talhinhas	Bragança	Macedo de Cavaleiros	40531	f
Vale Benfeito	Bragança	Macedo de Cavaleiros	40532	f
Vale da Porca	Bragança	Macedo de Cavaleiros	40533	f
Vale de Prados	Bragança	Macedo de Cavaleiros	40534	f
Vilar do Monte	Bragança	Macedo de Cavaleiros	40535	f
Vilarinho de Agrochão	Bragança	Macedo de Cavaleiros	40536	f
Vilarinho do Monte	Bragança	Macedo de Cavaleiros	40537	f
Vinhas	Bragança	Macedo de Cavaleiros	40538	f
Atenor	Bragança	Miranda do Douro	40601	f
Cicouro	Bragança	Miranda do Douro	40602	f
Constantim	Bragança	Miranda do Douro	40603	f
Duas Igrejas	Bragança	Miranda do Douro	40604	f
Genísio	Bragança	Miranda do Douro	40605	f
Ifanes	Bragança	Miranda do Douro	40606	f
Malhadas	Bragança	Miranda do Douro	40607	f
Miranda do Douro	Bragança	Miranda do Douro	40608	f
Palaçoulo	Bragança	Miranda do Douro	40609	f
Paradela	Bragança	Miranda do Douro	40610	f
Picote	Bragança	Miranda do Douro	40611	f
Póvoa	Bragança	Miranda do Douro	40612	f
São Martinho de Angueira	Bragança	Miranda do Douro	40613	f
Sendim	Bragança	Miranda do Douro	40614	f
Silva	Bragança	Miranda do Douro	40615	f
Vila Chã de Braciosa	Bragança	Miranda do Douro	40616	f
Águas Vivas	Bragança	Miranda do Douro	40617	f
Abambres	Bragança	Mirandela	40701	f
Abreiro	Bragança	Mirandela	40702	f
Aguieiras	Bragança	Mirandela	40703	f
Alvites	Bragança	Mirandela	40704	f
Avantos	Bragança	Mirandela	40705	f
Avidagos	Bragança	Mirandela	40706	f
Barcel	Bragança	Mirandela	40707	f
Bouça	Bragança	Mirandela	40708	f
Cabanelas	Bragança	Mirandela	40709	f
Caravelas	Bragança	Mirandela	40710	f
Carvalhais	Bragança	Mirandela	40711	f
Cedães	Bragança	Mirandela	40712	f
Cobro	Bragança	Mirandela	40713	f
Fradizela	Bragança	Mirandela	40714	f
Franco	Bragança	Mirandela	40715	f
Frechas	Bragança	Mirandela	40716	f
Freixeda	Bragança	Mirandela	40717	f
Lamas de Orelhão	Bragança	Mirandela	40718	f
Marmelos	Bragança	Mirandela	40719	f
Mascarenhas	Bragança	Mirandela	40720	f
Mirandela	Bragança	Mirandela	40721	f
Múrias	Bragança	Mirandela	40722	f
Navalho	Bragança	Mirandela	40723	f
Passos	Bragança	Mirandela	40724	f
Pereira	Bragança	Mirandela	40725	f
Romeu	Bragança	Mirandela	40726	f
São Pedro Velho	Bragança	Mirandela	40727	f
São Salvador	Bragança	Mirandela	40728	f
Suçães	Bragança	Mirandela	40729	f
Torre de Dona Chama	Bragança	Mirandela	40730	f
Vale de Asnes	Bragança	Mirandela	40731	f
Vale de Gouvinhas	Bragança	Mirandela	40732	f
Vale de Salgueiro	Bragança	Mirandela	40733	f
Vale de Telhas	Bragança	Mirandela	40734	f
Valverde	Bragança	Mirandela	40735	f
Vila Boa	Bragança	Mirandela	40736	f
Vila Verde	Bragança	Mirandela	40737	f
Azinhoso	Bragança	Mogadouro	40801	f
Bemposta	Bragança	Mogadouro	40802	f
Bruçó	Bragança	Mogadouro	40803	f
Brunhoso	Bragança	Mogadouro	40804	f
Brunhozinho	Bragança	Mogadouro	40805	f
Castanheira	Bragança	Mogadouro	40806	f
Castelo Branco	Bragança	Mogadouro	40807	f
Castro Vicente	Bragança	Mogadouro	40808	f
Meirinhos	Bragança	Mogadouro	40809	f
Mogadouro	Bragança	Mogadouro	40810	f
Paradela	Bragança	Mogadouro	40811	f
Penas Roias	Bragança	Mogadouro	40812	f
Peredo da Bemposta	Bragança	Mogadouro	40813	f
Remondes	Bragança	Mogadouro	40814	f
Saldanha	Bragança	Mogadouro	40815	f
Sanhoane	Bragança	Mogadouro	40816	f
São Martinho do Peso	Bragança	Mogadouro	40817	f
Soutelo	Bragança	Mogadouro	40818	f
Tó	Bragança	Mogadouro	40819	f
Travanca	Bragança	Mogadouro	40820	f
Urrós	Bragança	Mogadouro	40821	f
Vale da Madre	Bragança	Mogadouro	40822	f
Vale de Porco	Bragança	Mogadouro	40823	f
Valverde	Bragança	Mogadouro	40824	f
Ventozelo	Bragança	Mogadouro	40825	f
Vila de Ala	Bragança	Mogadouro	40826	f
Vilar de Rei	Bragança	Mogadouro	40827	f
Vilarinho dos Galegos	Bragança	Mogadouro	40828	f
Açoreira	Bragança	Torre de Moncorvo	40901	f
Adeganha	Bragança	Torre de Moncorvo	40902	f
Cabeça Boa	Bragança	Torre de Moncorvo	40903	f
Cardanha	Bragança	Torre de Moncorvo	40904	f
Carviçais	Bragança	Torre de Moncorvo	40905	f
Castedo	Bragança	Torre de Moncorvo	40906	f
Felgar	Bragança	Torre de Moncorvo	40907	f
Felgueiras	Bragança	Torre de Moncorvo	40908	f
Horta da Vilariça	Bragança	Torre de Moncorvo	40909	f
Larinho	Bragança	Torre de Moncorvo	40910	f
Lousa	Bragança	Torre de Moncorvo	40911	f
Maçores	Bragança	Torre de Moncorvo	40912	f
Mós	Bragança	Torre de Moncorvo	40913	f
Peredo dos Castelhanos	Bragança	Torre de Moncorvo	40914	f
Souto da Velha	Bragança	Torre de Moncorvo	40915	f
Torre de Moncorvo	Bragança	Torre de Moncorvo	40916	f
Urros	Bragança	Torre de Moncorvo	40917	f
Assares	Bragança	Vila Flor	41001	f
Benlhevai	Bragança	Vila Flor	41002	f
Candoso	Bragança	Vila Flor	41003	f
Carvalho de Egas	Bragança	Vila Flor	41004	f
Freixiel	Bragança	Vila Flor	41005	f
Lodões	Bragança	Vila Flor	41006	f
Mourão	Bragança	Vila Flor	41007	f
Nabo	Bragança	Vila Flor	41008	f
Roios	Bragança	Vila Flor	41009	f
Samões	Bragança	Vila Flor	41010	f
Sampaio	Bragança	Vila Flor	41011	f
Santa Comba de Vilariça	Bragança	Vila Flor	41012	f
Seixo de Manhoses	Bragança	Vila Flor	41013	f
Trindade	Bragança	Vila Flor	41014	f
Vale Frechoso	Bragança	Vila Flor	41015	f
Val de Torno	Bragança	Vila Flor	41016	f
Vila Flor	Bragança	Vila Flor	41017	f
Vilarinho das Azenhas	Bragança	Vila Flor	41018	f
Vilas Boas	Bragança	Vila Flor	41019	f
Algoso	Bragança	Vimioso	41101	f
Angueira	Bragança	Vimioso	41102	f
Argozelo	Bragança	Vimioso	41103	f
Avelanoso	Bragança	Vimioso	41104	f
Caçarelhos	Bragança	Vimioso	41105	f
Campo de Víboras	Bragança	Vimioso	41106	f
Carção	Bragança	Vimioso	41107	f
Matela	Bragança	Vimioso	41108	f
Pinelo	Bragança	Vimioso	41109	f
Santulhão	Bragança	Vimioso	41110	f
Uva	Bragança	Vimioso	41111	f
Vale de Frades	Bragança	Vimioso	41112	f
Vilar Seco	Bragança	Vimioso	41113	f
Vimioso	Bragança	Vimioso	41114	f
Agrochão	Bragança	Vinhais	41201	f
Alvaredos	Bragança	Vinhais	41202	f
Candedo	Bragança	Vinhais	41203	f
Celas	Bragança	Vinhais	41204	f
Curopos	Bragança	Vinhais	41205	f
Edral	Bragança	Vinhais	41206	f
Edrosa	Bragança	Vinhais	41207	f
Ervedosa	Bragança	Vinhais	41208	f
Fresulfe	Bragança	Vinhais	41209	f
Mofreita	Bragança	Vinhais	41210	f
Moimenta	Bragança	Vinhais	41211	f
Montouto	Bragança	Vinhais	41212	f
Nunes	Bragança	Vinhais	41213	f
Ousilhão	Bragança	Vinhais	41214	f
Paçó	Bragança	Vinhais	41215	f
Penhas Juntas	Bragança	Vinhais	41216	f
Pinheiro Novo	Bragança	Vinhais	41217	f
Quirás	Bragança	Vinhais	41218	f
Rebordelo	Bragança	Vinhais	41219	f
Santa Cruz	Bragança	Vinhais	41220	f
Santalha	Bragança	Vinhais	41221	f
São Jomil	Bragança	Vinhais	41222	f
Sobreiro de Baixo	Bragança	Vinhais	41223	f
Soeira	Bragança	Vinhais	41224	f
Travanca	Bragança	Vinhais	41225	f
Tuizelo	Bragança	Vinhais	41226	f
Vale das Fontes	Bragança	Vinhais	41227	f
Vale de Janeiro	Bragança	Vinhais	41228	f
Vila Boa de Ousilhão	Bragança	Vinhais	41229	f
Vila Verde	Bragança	Vinhais	41230	f
Vilar de Lomba	Bragança	Vinhais	41231	f
Vilar de Ossos	Bragança	Vinhais	41232	f
Vilar de Peregrinos	Bragança	Vinhais	41233	f
Vilar Seco de Lomba	Bragança	Vinhais	41234	f
Vinhais	Bragança	Vinhais	41235	f
Belmonte	Castelo Branco	Belmonte	50101	f
Caria	Castelo Branco	Belmonte	50102	f
Colmeal da Torre	Castelo Branco	Belmonte	50103	f
Inguias	Castelo Branco	Belmonte	50104	f
Maçainhas	Castelo Branco	Belmonte	50105	f
Alcains	Castelo Branco	Castelo Branco	50201	f
Almaceda	Castelo Branco	Castelo Branco	50202	f
Benquerenças	Castelo Branco	Castelo Branco	50203	f
Cafede	Castelo Branco	Castelo Branco	50204	f
Castelo Branco	Castelo Branco	Castelo Branco	50205	f
Cebolais de Cima	Castelo Branco	Castelo Branco	50206	f
Escalos de Baixo	Castelo Branco	Castelo Branco	50207	f
Escalos de Cima	Castelo Branco	Castelo Branco	50208	f
Freixial do Campo	Castelo Branco	Castelo Branco	50209	f
Juncal do Campo	Castelo Branco	Castelo Branco	50210	f
Lardosa	Castelo Branco	Castelo Branco	50211	f
Louriçal do Campo	Castelo Branco	Castelo Branco	50212	f
Lousa	Castelo Branco	Castelo Branco	50213	f
Malpica do Tejo	Castelo Branco	Castelo Branco	50214	f
Mata	Castelo Branco	Castelo Branco	50215	f
Monforte da Beira	Castelo Branco	Castelo Branco	50216	f
Ninho do Açor	Castelo Branco	Castelo Branco	50217	f
Póvoa de Rio de Moinhos	Castelo Branco	Castelo Branco	50218	f
Retaxo	Castelo Branco	Castelo Branco	50219	f
Salgueiro do Campo	Castelo Branco	Castelo Branco	50220	f
Santo André das Tojeiras	Castelo Branco	Castelo Branco	50221	f
São Vicente da Beira	Castelo Branco	Castelo Branco	50222	f
Sarzedas	Castelo Branco	Castelo Branco	50223	f
Sobral do Campo	Castelo Branco	Castelo Branco	50224	f
Tinalhas	Castelo Branco	Castelo Branco	50225	f
Vila do Carvalho	Castelo Branco	Covilhã	50301	f
Aldeia de São Francisco de Assis	Castelo Branco	Covilhã	50302	f
Aldeia do Souto	Castelo Branco	Covilhã	50303	f
Barco	Castelo Branco	Covilhã	50304	f
Boidobra	Castelo Branco	Covilhã	50305	f
Casegas	Castelo Branco	Covilhã	50306	f
Covilhã (Conceição)	Castelo Branco	Covilhã	50307	f
Cortes do Meio	Castelo Branco	Covilhã	50308	f
Dominguizo	Castelo Branco	Covilhã	50309	f
Erada	Castelo Branco	Covilhã	50310	f
Ferro	Castelo Branco	Covilhã	50311	f
Orjais	Castelo Branco	Covilhã	50312	f
Ourondo	Castelo Branco	Covilhã	50313	f
Paul	Castelo Branco	Covilhã	50314	f
Peraboa	Castelo Branco	Covilhã	50315	f
Peso	Castelo Branco	Covilhã	50316	f
Covilhã (Santa Maria)	Castelo Branco	Covilhã	50317	f
São Jorge da Beira	Castelo Branco	Covilhã	50318	f
Covilhã (São Martinho)	Castelo Branco	Covilhã	50319	f
Covilhã (São Pedro)	Castelo Branco	Covilhã	50320	f
Sarzedo	Castelo Branco	Covilhã	50321	f
Sobral de São Miguel	Castelo Branco	Covilhã	50322	f
Teixoso	Castelo Branco	Covilhã	50323	f
Tortosendo	Castelo Branco	Covilhã	50324	f
Unhais da Serra	Castelo Branco	Covilhã	50325	f
Vale Formoso	Castelo Branco	Covilhã	50326	f
Verdelhos	Castelo Branco	Covilhã	50327	f
Vales do Rio	Castelo Branco	Covilhã	50328	f
Coutada	Castelo Branco	Covilhã	50329	f
Cantar-Galo	Castelo Branco	Covilhã	50330	f
Canhoso	Castelo Branco	Covilhã	50331	f
Alcaide	Castelo Branco	Fundão	50401	f
Alcaria	Castelo Branco	Fundão	50402	f
Alcongosta	Castelo Branco	Fundão	50403	f
Aldeia de Joanes	Castelo Branco	Fundão	50404	f
Aldeia Nova do Cabo	Castelo Branco	Fundão	50405	f
Alpedrinha	Castelo Branco	Fundão	50406	f
Atalaia do Campo	Castelo Branco	Fundão	50407	f
Barroca	Castelo Branco	Fundão	50408	f
Bogas de Baixo	Castelo Branco	Fundão	50409	f
Bogas de Cima	Castelo Branco	Fundão	50410	f
Capinha	Castelo Branco	Fundão	50411	f
Castelejo	Castelo Branco	Fundão	50412	f
Castelo Novo	Castelo Branco	Fundão	50413	f
Donas	Castelo Branco	Fundão	50414	f
Escarigo	Castelo Branco	Fundão	50415	f
Fatela	Castelo Branco	Fundão	50416	f
Fundão	Castelo Branco	Fundão	50417	f
Janeiro de Cima	Castelo Branco	Fundão	50418	f
Lavacolhos	Castelo Branco	Fundão	50419	f
Orca	Castelo Branco	Fundão	50420	f
Pêro Viseu	Castelo Branco	Fundão	50421	f
Póvoa de Atalaia	Castelo Branco	Fundão	50422	f
Salgueiro	Castelo Branco	Fundão	50423	f
Silvares	Castelo Branco	Fundão	50424	f
Soalheira	Castelo Branco	Fundão	50425	f
Souto da Casa	Castelo Branco	Fundão	50426	f
Telhado	Castelo Branco	Fundão	50427	f
Vale de Prazeres	Castelo Branco	Fundão	50428	f
Valverde	Castelo Branco	Fundão	50429	f
Mata da Rainha	Castelo Branco	Fundão	50430	f
Enxames	Castelo Branco	Fundão	50431	f
Alcafozes	Castelo Branco	Idanha-a-Nova	50501	f
Aldeia de Santa Margarida	Castelo Branco	Idanha-a-Nova	50502	f
Idanha-a-Nova	Castelo Branco	Idanha-a-Nova	50503	f
Idanha-a-Velha	Castelo Branco	Idanha-a-Nova	50504	f
Ladoeiro	Castelo Branco	Idanha-a-Nova	50505	f
Medelim	Castelo Branco	Idanha-a-Nova	50506	f
Monfortinho	Castelo Branco	Idanha-a-Nova	50507	f
Monsanto	Castelo Branco	Idanha-a-Nova	50508	f
Oledo	Castelo Branco	Idanha-a-Nova	50509	f
Penha Garcia	Castelo Branco	Idanha-a-Nova	50510	f
Proença-a-Velha	Castelo Branco	Idanha-a-Nova	50511	f
Rosmaninhal	Castelo Branco	Idanha-a-Nova	50512	f
Salvaterra do Extremo	Castelo Branco	Idanha-a-Nova	50513	f
São Miguel de Acha	Castelo Branco	Idanha-a-Nova	50514	f
Segura	Castelo Branco	Idanha-a-Nova	50515	f
Toulões	Castelo Branco	Idanha-a-Nova	50516	f
Zebreira	Castelo Branco	Idanha-a-Nova	50517	f
Álvaro	Castelo Branco	Oleiros	50601	f
Amieira	Castelo Branco	Oleiros	50602	f
Cambas	Castelo Branco	Oleiros	50603	f
Estreito	Castelo Branco	Oleiros	50604	f
Isna	Castelo Branco	Oleiros	50605	f
Madeirã	Castelo Branco	Oleiros	50606	f
Mosteiro	Castelo Branco	Oleiros	50607	f
Oleiros	Castelo Branco	Oleiros	50608	f
Orvalho	Castelo Branco	Oleiros	50609	f
Sarnadas de São Simão	Castelo Branco	Oleiros	50610	f
Sobral	Castelo Branco	Oleiros	50611	f
Vilar Barroco	Castelo Branco	Oleiros	50612	f
Águas	Castelo Branco	Penamacor	50701	f
Aldeia do Bispo	Castelo Branco	Penamacor	50702	f
Aldeia de João Pires	Castelo Branco	Penamacor	50703	f
Aranhas	Castelo Branco	Penamacor	50704	f
Bemposta	Castelo Branco	Penamacor	50705	f
Benquerença	Castelo Branco	Penamacor	50706	f
Meimão	Castelo Branco	Penamacor	50707	f
Meimoa	Castelo Branco	Penamacor	50708	f
Pedrógão de São Pedro	Castelo Branco	Penamacor	50709	f
Penamacor	Castelo Branco	Penamacor	50710	f
Salvador	Castelo Branco	Penamacor	50711	f
Vale da Senhora da Póvoa	Castelo Branco	Penamacor	50712	f
Alvito da Beira	Castelo Branco	Proença-a-Nova	50801	f
Montes da Senhora	Castelo Branco	Proença-a-Nova	50802	f
Peral	Castelo Branco	Proença-a-Nova	50803	f
Proença-a-Nova	Castelo Branco	Proença-a-Nova	50804	f
São Pedro do Esteval	Castelo Branco	Proença-a-Nova	50805	f
Sobreira Formosa	Castelo Branco	Proença-a-Nova	50806	f
Cabeçudo	Castelo Branco	Sertã	50901	f
Carvalhal	Castelo Branco	Sertã	50902	f
Castelo	Castelo Branco	Sertã	50903	f
Cernache do Bonjardim	Castelo Branco	Sertã	50904	f
Cumeada	Castelo Branco	Sertã	50905	f
Ermida	Castelo Branco	Sertã	50906	f
Figueiredo	Castelo Branco	Sertã	50907	f
Marmeleiro	Castelo Branco	Sertã	50908	f
Nesperal	Castelo Branco	Sertã	50909	f
Palhais	Castelo Branco	Sertã	50910	f
Pedrógão Pequeno	Castelo Branco	Sertã	50911	f
Sertã	Castelo Branco	Sertã	50912	f
Troviscal	Castelo Branco	Sertã	50913	f
Várzea dos Cavaleiros	Castelo Branco	Sertã	50914	f
Fundada	Castelo Branco	Vila de Rei	51001	f
São João do Peso	Castelo Branco	Vila de Rei	51002	f
Vila de Rei	Castelo Branco	Vila de Rei	51003	f
Fratel	Castelo Branco	Vila Velha de Ródão	51101	f
Perais	Castelo Branco	Vila Velha de Ródão	51102	f
Sarnadas de Ródão	Castelo Branco	Vila Velha de Ródão	51103	f
Vila Velha de Ródão	Castelo Branco	Vila Velha de Ródão	51104	f
Anceriz	Coimbra	Arganil	60101	f
Arganil	Coimbra	Arganil	60102	f
Barril de Alva	Coimbra	Arganil	60103	f
Benfeita	Coimbra	Arganil	60104	f
Celavisa	Coimbra	Arganil	60105	f
Cepos	Coimbra	Arganil	60106	f
Cerdeira	Coimbra	Arganil	60107	f
Coja	Coimbra	Arganil	60108	f
Folques	Coimbra	Arganil	60109	f
Moura da Serra	Coimbra	Arganil	60110	f
Piódão	Coimbra	Arganil	60111	f
Pomares	Coimbra	Arganil	60112	f
Pombeiro da Beira	Coimbra	Arganil	60113	f
São Martinho da Cortiça	Coimbra	Arganil	60114	f
Sarzedo	Coimbra	Arganil	60115	f
Secarias	Coimbra	Arganil	60116	f
Teixeira	Coimbra	Arganil	60117	f
Vila Cova de Alva	Coimbra	Arganil	60118	f
Ançã	Coimbra	Cantanhede	60201	f
Bolho	Coimbra	Cantanhede	60202	f
Cadima	Coimbra	Cantanhede	60203	f
Cantanhede	Coimbra	Cantanhede	60204	f
Cordinhã	Coimbra	Cantanhede	60205	f
Covões	Coimbra	Cantanhede	60206	f
Febres	Coimbra	Cantanhede	60207	f
Murtede	Coimbra	Cantanhede	60208	f
Ourentã	Coimbra	Cantanhede	60209	f
Outil	Coimbra	Cantanhede	60210	f
Pocariça	Coimbra	Cantanhede	60211	f
Portunhos	Coimbra	Cantanhede	60212	f
Sepins	Coimbra	Cantanhede	60213	f
Tocha	Coimbra	Cantanhede	60214	f
São Caetano	Coimbra	Cantanhede	60215	f
Corticeiro de Cima	Coimbra	Cantanhede	60216	f
Vilamar	Coimbra	Cantanhede	60217	f
Sanguinheira	Coimbra	Cantanhede	60218	f
Camarneira	Coimbra	Cantanhede	60219	f
Almalaguês	Coimbra	Coimbra	60301	f
Coimbra (Almedina)	Coimbra	Coimbra	60302	f
Ameal	Coimbra	Coimbra	60303	f
Antanhol	Coimbra	Coimbra	60304	f
Antuzede	Coimbra	Coimbra	60305	f
Arzila	Coimbra	Coimbra	60306	f
Assafarge	Coimbra	Coimbra	60307	f
Botão	Coimbra	Coimbra	60308	f
Brasfemes	Coimbra	Coimbra	60309	f
Castelo Viegas	Coimbra	Coimbra	60310	f
Ceira	Coimbra	Coimbra	60311	f
Cernache	Coimbra	Coimbra	60312	f
Eiras	Coimbra	Coimbra	60313	f
Lamarosa	Coimbra	Coimbra	60314	f
Ribeira de Frades	Coimbra	Coimbra	60315	f
Santa Clara	Coimbra	Coimbra	60316	f
Coimbra (Santa Cruz)	Coimbra	Coimbra	60317	f
Santo António dos Olivais	Coimbra	Coimbra	60318	f
Coimbra (São Bartolomeu)	Coimbra	Coimbra	60319	f
São João do Campo	Coimbra	Coimbra	60320	f
São Martinho de Árvore	Coimbra	Coimbra	60321	f
São Martinho do Bispo	Coimbra	Coimbra	60322	f
São Paulo de Frades	Coimbra	Coimbra	60323	f
São Silvestre	Coimbra	Coimbra	60324	f
Coimbra (Sé Nova)	Coimbra	Coimbra	60325	f
Souselas	Coimbra	Coimbra	60326	f
Taveiro	Coimbra	Coimbra	60327	f
Torre de Vilela	Coimbra	Coimbra	60328	f
Torres do Mondego	Coimbra	Coimbra	60329	f
Trouxemil	Coimbra	Coimbra	60330	f
Vil de Matos	Coimbra	Coimbra	60331	f
Anobra	Coimbra	Condeixa-a-Nova	60401	f
Belide	Coimbra	Condeixa-a-Nova	60402	f
Bem da Fé	Coimbra	Condeixa-a-Nova	60403	f
Condeixa-a-Nova	Coimbra	Condeixa-a-Nova	60404	f
Condeixa-a-Velha	Coimbra	Condeixa-a-Nova	60405	f
Ega	Coimbra	Condeixa-a-Nova	60406	f
Furadouro	Coimbra	Condeixa-a-Nova	60407	f
Sebal	Coimbra	Condeixa-a-Nova	60408	f
Vila Seca	Coimbra	Condeixa-a-Nova	60409	f
Zambujal	Coimbra	Condeixa-a-Nova	60410	f
Alhadas	Coimbra	Figueira da Foz	60501	f
Alqueidão	Coimbra	Figueira da Foz	60502	f
Brenha	Coimbra	Figueira da Foz	60503	f
Buarcos	Coimbra	Figueira da Foz	60504	f
Ferreira-a-Nova	Coimbra	Figueira da Foz	60505	f
Lavos	Coimbra	Figueira da Foz	60506	f
Maiorca	Coimbra	Figueira da Foz	60507	f
Marinha das Ondas	Coimbra	Figueira da Foz	60508	f
Paião	Coimbra	Figueira da Foz	60509	f
Quiaios	Coimbra	Figueira da Foz	60510	f
São Julião da Figueira da Foz	Coimbra	Figueira da Foz	60511	f
Tavarede	Coimbra	Figueira da Foz	60512	f
Vila Verde	Coimbra	Figueira da Foz	60513	f
São Pedro	Coimbra	Figueira da Foz	60514	f
Bom Sucesso	Coimbra	Figueira da Foz	60515	f
Santana	Coimbra	Figueira da Foz	60516	f
Borda do Campo	Coimbra	Figueira da Foz	60517	f
Moinhos da Gândara	Coimbra	Figueira da Foz	60518	f
Alvares	Coimbra	Góis	60601	f
Cadafaz	Coimbra	Góis	60602	f
Colmeal	Coimbra	Góis	60603	f
Góis	Coimbra	Góis	60604	f
Vila Nova de Ceira	Coimbra	Góis	60605	f
Casal de Ermio	Coimbra	Lousã	60701	f
Foz de Arouce	Coimbra	Lousã	60702	f
Lousã	Coimbra	Lousã	60703	f
Serpins	Coimbra	Lousã	60704	f
Vilarinho	Coimbra	Lousã	60705	f
Gândaras	Coimbra	Lousã	60706	f
Mira	Coimbra	Mira	60801	f
Seixo	Coimbra	Mira	60802	f
Carapelhos	Coimbra	Mira	60803	f
Praia de Mira	Coimbra	Mira	60804	f
Lamas	Coimbra	Miranda do Corvo	60901	f
Miranda do Corvo	Coimbra	Miranda do Corvo	60902	f
Rio Vide	Coimbra	Miranda do Corvo	60903	f
Semide	Coimbra	Miranda do Corvo	60904	f
Vila Nova	Coimbra	Miranda do Corvo	60905	f
Abrunheira	Coimbra	Montemor-o-Velho	61001	f
Arazede	Coimbra	Montemor-o-Velho	61002	f
Carapinheira	Coimbra	Montemor-o-Velho	61003	f
Gatões	Coimbra	Montemor-o-Velho	61004	f
Liceia	Coimbra	Montemor-o-Velho	61005	f
Meãs do Campo	Coimbra	Montemor-o-Velho	61006	f
Montemor-o-Velho	Coimbra	Montemor-o-Velho	61007	f
Pereira	Coimbra	Montemor-o-Velho	61008	f
Santo Varão	Coimbra	Montemor-o-Velho	61009	f
Seixo de Gatões	Coimbra	Montemor-o-Velho	61010	f
Tentúgal	Coimbra	Montemor-o-Velho	61011	f
Verride	Coimbra	Montemor-o-Velho	61012	f
Vila Nova da Barca	Coimbra	Montemor-o-Velho	61013	f
Ereira	Coimbra	Montemor-o-Velho	61014	f
Aldeia das Dez	Coimbra	Oliveira do Hospital	61101	f
Alvoco das Várzeas	Coimbra	Oliveira do Hospital	61102	f
Avô	Coimbra	Oliveira do Hospital	61103	f
Bobadela	Coimbra	Oliveira do Hospital	61104	f
Ervedal	Coimbra	Oliveira do Hospital	61105	f
Lagares	Coimbra	Oliveira do Hospital	61106	f
Lagos da Beira	Coimbra	Oliveira do Hospital	61107	f
Lajeosa	Coimbra	Oliveira do Hospital	61108	f
Lourosa	Coimbra	Oliveira do Hospital	61109	f
Meruge	Coimbra	Oliveira do Hospital	61110	f
Nogueira do Cravo	Coimbra	Oliveira do Hospital	61111	f
Oliveira do Hospital	Coimbra	Oliveira do Hospital	61112	f
Penalva de Alva	Coimbra	Oliveira do Hospital	61113	f
Santa Ovaia	Coimbra	Oliveira do Hospital	61114	f
São Gião	Coimbra	Oliveira do Hospital	61115	f
São Paio de Gramaços	Coimbra	Oliveira do Hospital	61116	f
São Sebastião da Feira	Coimbra	Oliveira do Hospital	61117	f
Seixo da Beira	Coimbra	Oliveira do Hospital	61118	f
Travanca de Lagos	Coimbra	Oliveira do Hospital	61119	f
Vila Pouca da Beira	Coimbra	Oliveira do Hospital	61120	f
Vila Franca da Beira	Coimbra	Oliveira do Hospital	61121	f
Cabril	Coimbra	Pampilhosa da Serra	61201	f
Dornelas do Zêzere	Coimbra	Pampilhosa da Serra	61202	f
Fajão	Coimbra	Pampilhosa da Serra	61203	f
Janeiro de Baixo	Coimbra	Pampilhosa da Serra	61204	f
Machio	Coimbra	Pampilhosa da Serra	61205	f
Pampilhosa da Serra	Coimbra	Pampilhosa da Serra	61206	f
Pessegueiro	Coimbra	Pampilhosa da Serra	61207	f
Portela do Fojo	Coimbra	Pampilhosa da Serra	61208	f
Unhais-o-Velho	Coimbra	Pampilhosa da Serra	61209	f
Vidual	Coimbra	Pampilhosa da Serra	61210	f
Carvalho	Coimbra	Penacova	61301	f
Figueira de Lorvão	Coimbra	Penacova	61302	f
Friúmes	Coimbra	Penacova	61303	f
Lorvão	Coimbra	Penacova	61304	f
Oliveira do Mondego	Coimbra	Penacova	61305	f
Paradela	Coimbra	Penacova	61306	f
Penacova	Coimbra	Penacova	61307	f
São Paio de Mondego	Coimbra	Penacova	61308	f
São Pedro de Alva	Coimbra	Penacova	61309	f
Sazes do Lorvão	Coimbra	Penacova	61310	f
Travanca do Mondego	Coimbra	Penacova	61311	f
Cumeeira	Coimbra	Penela	61401	f
Espinhal	Coimbra	Penela	61402	f
Podentes	Coimbra	Penela	61403	f
Rabaçal	Coimbra	Penela	61404	f
Penela (Santa Eufémia)	Coimbra	Penela	61405	f
Penela (São Miguel)	Coimbra	Penela	61406	f
Alfarelos	Coimbra	Soure	61501	f
Brunhós	Coimbra	Soure	61502	f
Degracias	Coimbra	Soure	61503	f
Figueiró do Campo	Coimbra	Soure	61504	f
Gesteira	Coimbra	Soure	61505	f
Granja do Ulmeiro	Coimbra	Soure	61506	f
Pombalinho	Coimbra	Soure	61507	f
Samuel	Coimbra	Soure	61508	f
Soure	Coimbra	Soure	61509	f
Tapéus	Coimbra	Soure	61510	f
Vila Nova de Anços	Coimbra	Soure	61511	f
Vinha da Rainha	Coimbra	Soure	61512	f
Ázere	Coimbra	Tábua	61601	f
Candosa	Coimbra	Tábua	61602	f
Carapinha	Coimbra	Tábua	61603	f
Covas	Coimbra	Tábua	61604	f
Covelo	Coimbra	Tábua	61605	f
Espariz	Coimbra	Tábua	61606	f
Meda de Mouros	Coimbra	Tábua	61607	f
Midões	Coimbra	Tábua	61608	f
Mouronho	Coimbra	Tábua	61609	f
Pinheiro de Coja	Coimbra	Tábua	61610	f
Póvoa de Midões	Coimbra	Tábua	61611	f
São João da Boa Vista	Coimbra	Tábua	61612	f
Sinde	Coimbra	Tábua	61613	f
Tábua	Coimbra	Tábua	61614	f
Vila Nova de Oliveirinha	Coimbra	Tábua	61615	f
Arrifana	Coimbra	Vila Nova de Poiares	61701	f
Lavegadas	Coimbra	Vila Nova de Poiares	61702	f
Poiares (Santo André)	Coimbra	Vila Nova de Poiares	61703	f
São Miguel de Poiares	Coimbra	Vila Nova de Poiares	61704	f
Alandroal (Nossa Senhora da Conceição)	Évora	Alandroal	70101	f
Juromenha (Nossa Senhora do Loreto)	Évora	Alandroal	70102	f
Santiago Maior	Évora	Alandroal	70103	f
Capelins (Santo António)	Évora	Alandroal	70104	f
Terena (São Pedro)	Évora	Alandroal	70105	f
São Brás dos Matos (Mina do Bugalho)	Évora	Alandroal	70106	f
Arraiolos	Évora	Arraiolos	70201	f
Igrejinha	Évora	Arraiolos	70202	f
Santa Justa	Évora	Arraiolos	70203	f
São Gregório	Évora	Arraiolos	70204	f
Gafanhoeira (São Pedro)	Évora	Arraiolos	70205	f
Vimieiro	Évora	Arraiolos	70206	f
Sabugueiro	Évora	Arraiolos	70207	f
Borba (Matriz)	Évora	Borba	70301	f
Orada	Évora	Borba	70302	f
Rio de Moinhos	Évora	Borba	70303	f
Borba (São Bartolomeu)	Évora	Borba	70304	f
Arcos	Évora	Estremoz	70401	f
Glória	Évora	Estremoz	70402	f
Estremoz (Santa Maria)	Évora	Estremoz	70403	f
Évora Monte (Santa Maria)	Évora	Estremoz	70404	f
Santa Vitória do Ameixial	Évora	Estremoz	70405	f
Estremoz (Santo André)	Évora	Estremoz	70406	f
Santo Estêvão	Évora	Estremoz	70407	f
São Bento do Ameixial	Évora	Estremoz	70408	f
São Bento de Ana Loura	Évora	Estremoz	70409	f
São Bento do Cortiço	Évora	Estremoz	70410	f
São Domingos de Ana Loura	Évora	Estremoz	70411	f
São Lourenço de Mamporcão	Évora	Estremoz	70412	f
Veiros	Évora	Estremoz	70413	f
Nossa Senhora da Boa Fé	Évora	Évora	70501	f
Nossa Senhora da Graça do Divor	Évora	Évora	70502	f
Nossa Senhora de Machede	Évora	Évora	70503	f
Nossa Senhora da Torega	Évora	Évora	70504	f
Évora (Santo Antão)	Évora	Évora	70505	f
São Bento do Mato	Évora	Évora	70506	f
Évora (São Mamede)	Évora	Évora	70507	f
São Manços	Évora	Évora	70508	f
São Miguel de Machede	Évora	Évora	70509	f
São Vicente do Pigeiro	Évora	Évora	70511	f
Torre de Coelheiros	Évora	Évora	70513	f
São Sebastião da Giesteira	Évora	Évora	70514	f
Canaviais	Évora	Évora	70515	f
Nossa Senhora de Guadalupe	Évora	Évora	70516	f
Bacelo	Évora	Évora	70517	f
Horta das Figueiras	Évora	Évora	70518	f
Malagueira	Évora	Évora	70519	f
Sé e São Pedro	Évora	Évora	70520	f
Senhora da Saúde	Évora	Évora	70521	f
Cabrela	Évora	Montemor-o-Novo	70601	f
Lavre	Évora	Montemor-o-Novo	70602	f
Nossa Senhora do Bispo	Évora	Montemor-o-Novo	70603	f
Nossa Senhora da Vila	Évora	Montemor-o-Novo	70604	f
Santiago do Escoural	Évora	Montemor-o-Novo	70605	f
São Cristovão	Évora	Montemor-o-Novo	70606	f
Ciborro	Évora	Montemor-o-Novo	70607	f
Cortiçadas	Évora	Montemor-o-Novo	70608	f
Silveiras	Évora	Montemor-o-Novo	70609	f
Foros de Vale de Figueira	Évora	Montemor-o-Novo	70610	f
Brotas	Évora	Mora	70701	f
Cabeção	Évora	Mora	70702	f
Mora	Évora	Mora	70703	f
Pavia	Évora	Mora	70704	f
Granja	Évora	Mourão	70801	f
Luz	Évora	Mourão	70802	f
Mourão	Évora	Mourão	70803	f
Alqueva	Évora	Portel	70901	f
Amieira	Évora	Portel	70902	f
Monte do Trigo	Évora	Portel	70903	f
Oriola	Évora	Portel	70904	f
Portel	Évora	Portel	70905	f
Santana	Évora	Portel	70906	f
São Bartolomeu do Outeiro	Évora	Portel	70907	f
Vera Cruz	Évora	Portel	70908	f
Montoito	Évora	Redondo	71001	f
Redondo	Évora	Redondo	71002	f
Campo	Évora	Reguengos de Monsaraz	71101	f
Corval	Évora	Reguengos de Monsaraz	71102	f
Monsaraz	Évora	Reguengos de Monsaraz	71103	f
Reguengos de Monsaraz	Évora	Reguengos de Monsaraz	71104	f
Campinho	Évora	Reguengos de Monsaraz	71105	f
Vendas Novas	Évora	Vendas Novas	71201	f
Landeira	Évora	Vendas Novas	71202	f
Alcáçovas	Évora	Viana do Alentejo	71301	f
Viana do Alentejo	Évora	Viana do Alentejo	71302	f
Aguiar	Évora	Viana do Alentejo	71303	f
Bencatel	Évora	Vila Viçosa	71401	f
Ciladas	Évora	Vila Viçosa	71402	f
Vila Viçosa (Conceição)	Évora	Vila Viçosa	71403	f
Pardais	Évora	Vila Viçosa	71404	f
Vila Viçosa (São Bartolomeu)	Évora	Vila Viçosa	71405	f
Albufeira	Faro	Albufeira	80101	f
Guia	Faro	Albufeira	80102	f
Paderne	Faro	Albufeira	80103	f
Ferreiras	Faro	Albufeira	80104	f
Olhos de Água	Faro	Albufeira	80105	f
Alcoutim	Faro	Alcoutim	80201	f
Giões	Faro	Alcoutim	80202	f
Martim Longo	Faro	Alcoutim	80203	f
Pereiro	Faro	Alcoutim	80204	f
Vaqueiros	Faro	Alcoutim	80205	f
Aljezur	Faro	Aljezur	80301	f
Bordeira	Faro	Aljezur	80302	f
Odeceixe	Faro	Aljezur	80303	f
Rogil	Faro	Aljezur	80304	f
Azinhal	Faro	Castro Marim	80401	f
Castro Marim	Faro	Castro Marim	80402	f
Odeleite	Faro	Castro Marim	80403	f
Altura	Faro	Castro Marim	80404	f
Conceição	Faro	Faro	80501	f
Estói	Faro	Faro	80502	f
Santa Bárbara de Nexe	Faro	Faro	80503	f
Faro (São Pedro)	Faro	Faro	80504	f
Faro (Sé)	Faro	Faro	80505	f
Montenegro	Faro	Faro	80506	f
Estômbar	Faro	Lagoa	80601	f
Ferragudo	Faro	Lagoa	80602	f
Lagoa	Faro	Lagoa	80603	f
Porches	Faro	Lagoa	80604	f
Carvoeiro	Faro	Lagoa	80605	f
Parchal	Faro	Lagoa	80606	f
Barão de São João	Faro	Lagos	80701	f
Bensafrim	Faro	Lagos	80702	f
Luz	Faro	Lagos	80703	f
Odiáxere	Faro	Lagos	80704	f
Lagos (Santa Maria)	Faro	Lagos	80705	f
Lagos (São Sebastião)	Faro	Lagos	80706	f
Almancil	Faro	Loulé	80801	f
Alte	Faro	Loulé	80802	f
Ameixial	Faro	Loulé	80803	f
Boliqueime	Faro	Loulé	80804	f
Quarteira	Faro	Loulé	80805	f
Querença	Faro	Loulé	80806	f
Salir	Faro	Loulé	80807	f
Loulé (São Clemente)	Faro	Loulé	80808	f
Loulé (São Sebastião)	Faro	Loulé	80809	f
Benafim	Faro	Loulé	80810	f
Tôr	Faro	Loulé	80811	f
Alferce	Faro	Monchique	80901	f
Marmelete	Faro	Monchique	80902	f
Monchique	Faro	Monchique	80903	f
Fuseta	Faro	Olhão	81001	f
Moncarapacho	Faro	Olhão	81002	f
Olhão	Faro	Olhão	81003	f
Pechão	Faro	Olhão	81004	f
Quelfes	Faro	Olhão	81005	f
Alvor	Faro	Portimão	81101	f
Mexilhoeira Grande	Faro	Portimão	81102	f
Portimão	Faro	Portimão	81103	f
São Brás de Alportel	Faro	São Brás de Alportel	81201	f
Alcantarilha	Faro	Silves	81301	f
Algoz	Faro	Silves	81302	f
Armação de Pêra	Faro	Silves	81303	f
Pêra	Faro	Silves	81304	f
São Bartolomeu de Messines	Faro	Silves	81305	f
São Marcos da Serra	Faro	Silves	81306	f
Silves	Faro	Silves	81307	f
Tunes	Faro	Silves	81308	f
Cachopo	Faro	Tavira	81401	f
Conceição	Faro	Tavira	81402	f
Luz	Faro	Tavira	81403	f
Santa Catarina da Fonte do Bispo	Faro	Tavira	81404	f
Tavira (Santa Maria)	Faro	Tavira	81405	f
Tavira (Santiago)	Faro	Tavira	81406	f
Santo Estêvão	Faro	Tavira	81407	f
Santa Luzia	Faro	Tavira	81408	f
Cabanas de Tavira	Faro	Tavira	81409	f
Barão de São Miguel	Faro	Vila do Bispo	81501	f
Budens	Faro	Vila do Bispo	81502	f
Raposeira	Faro	Vila do Bispo	81503	f
Sagres	Faro	Vila do Bispo	81504	f
Vila do Bispo	Faro	Vila do Bispo	81505	f
Vila Nova de Cacela	Faro	Vila Real de Santo António	81601	f
Vila Real de Santo António	Faro	Vila Real de Santo António	81602	f
Monte Gordo	Faro	Vila Real de Santo António	81603	f
Aguiar da Beira	Guarda	Aguiar da Beira	90101	f
Carapito	Guarda	Aguiar da Beira	90102	f
Cortiçada	Guarda	Aguiar da Beira	90103	f
Coruche	Guarda	Aguiar da Beira	90104	f
Dornelas	Guarda	Aguiar da Beira	90105	f
Eirado	Guarda	Aguiar da Beira	90106	f
Forninhos	Guarda	Aguiar da Beira	90107	f
Gradiz	Guarda	Aguiar da Beira	90108	f
Pena Verde	Guarda	Aguiar da Beira	90109	f
Pinheiro	Guarda	Aguiar da Beira	90110	f
Sequeiros	Guarda	Aguiar da Beira	90111	f
Souto de Aguiar da Beira	Guarda	Aguiar da Beira	90112	f
Valverde	Guarda	Aguiar da Beira	90113	f
Ade	Guarda	Almeida	90201	f
Aldeia Nova	Guarda	Almeida	90202	f
Almeida	Guarda	Almeida	90203	f
Amoreira	Guarda	Almeida	90204	f
Azinhal	Guarda	Almeida	90205	f
Cabreira	Guarda	Almeida	90206	f
Castelo Bom	Guarda	Almeida	90207	f
Castelo Mendo	Guarda	Almeida	90208	f
Freineda	Guarda	Almeida	90209	f
Freixo	Guarda	Almeida	90210	f
Junça	Guarda	Almeida	90211	f
Leomil	Guarda	Almeida	90212	f
Malhada Sorda	Guarda	Almeida	90213	f
Malpartida	Guarda	Almeida	90214	f
Mesquitela	Guarda	Almeida	90215	f
Mido	Guarda	Almeida	90216	f
Miuzela	Guarda	Almeida	90217	f
Monte Perobolço	Guarda	Almeida	90218	f
Nave de Haver	Guarda	Almeida	90219	f
Naves	Guarda	Almeida	90220	f
Parada	Guarda	Almeida	90221	f
Peva	Guarda	Almeida	90222	f
Porto de Ovelha	Guarda	Almeida	90223	f
São Pedro de Rio Seco	Guarda	Almeida	90224	f
Senouras	Guarda	Almeida	90225	f
Vale de Coelha	Guarda	Almeida	90226	f
Vale da Mula	Guarda	Almeida	90227	f
Vale Verde	Guarda	Almeida	90228	f
Vilar Formoso	Guarda	Almeida	90229	f
Açores	Guarda	Celorico da Beira	90301	f
Baraçal	Guarda	Celorico da Beira	90302	f
Cadafaz	Guarda	Celorico da Beira	90303	f
Carrapichana	Guarda	Celorico da Beira	90304	f
Cortiçô da Serra	Guarda	Celorico da Beira	90305	f
Forno Telheiro	Guarda	Celorico da Beira	90306	f
Lajeosa do Mondego	Guarda	Celorico da Beira	90307	f
Linhares	Guarda	Celorico da Beira	90308	f
Maçal do Chão	Guarda	Celorico da Beira	90309	f
Mesquitela	Guarda	Celorico da Beira	90310	f
Minhocal	Guarda	Celorico da Beira	90311	f
Prados	Guarda	Celorico da Beira	90312	f
Rapa	Guarda	Celorico da Beira	90313	f
Ratoeira	Guarda	Celorico da Beira	90314	f
Salgueirais	Guarda	Celorico da Beira	90315	f
Celorico (Santa Maria)	Guarda	Celorico da Beira	90316	f
Celorico (São Pedro)	Guarda	Celorico da Beira	90317	f
Vale de Azares	Guarda	Celorico da Beira	90318	f
Velosa	Guarda	Celorico da Beira	90319	f
Vide entre Vinhas	Guarda	Celorico da Beira	90320	f
Vila Boa do Mondego	Guarda	Celorico da Beira	90321	f
Casas do Soeiro	Guarda	Celorico da Beira	90322	f
Algodres	Guarda	Figueira de Castelo Rodrigo	90401	f
Almofala	Guarda	Figueira de Castelo Rodrigo	90402	f
Castelo Rodrigo	Guarda	Figueira de Castelo Rodrigo	90403	f
Cinco Vilas	Guarda	Figueira de Castelo Rodrigo	90404	f
Colmeal	Guarda	Figueira de Castelo Rodrigo	90405	f
Escalhão	Guarda	Figueira de Castelo Rodrigo	90406	f
Escarigo	Guarda	Figueira de Castelo Rodrigo	90407	f
Figueira de Castelo Rodrigo	Guarda	Figueira de Castelo Rodrigo	90408	f
Freixeda do Torrão	Guarda	Figueira de Castelo Rodrigo	90409	f
Mata de Lobos	Guarda	Figueira de Castelo Rodrigo	90410	f
Penha de Águia	Guarda	Figueira de Castelo Rodrigo	90411	f
Quintã de Pêro Martins	Guarda	Figueira de Castelo Rodrigo	90412	f
Reigada	Guarda	Figueira de Castelo Rodrigo	90413	f
Vale de Afonsinho	Guarda	Figueira de Castelo Rodrigo	90414	f
Vermiosa	Guarda	Figueira de Castelo Rodrigo	90415	f
Vilar de Amargo	Guarda	Figueira de Castelo Rodrigo	90416	f
Vilar Torpim	Guarda	Figueira de Castelo Rodrigo	90417	f
Algodres	Guarda	Fornos de Algodres	90501	f
Casal Vasco	Guarda	Fornos de Algodres	90502	f
Cortiçô	Guarda	Fornos de Algodres	90503	f
Figueiró da Granja	Guarda	Fornos de Algodres	90504	f
Fornos de Algodres	Guarda	Fornos de Algodres	90505	f
Fuinhas	Guarda	Fornos de Algodres	90506	f
Infias	Guarda	Fornos de Algodres	90507	f
Juncais	Guarda	Fornos de Algodres	90508	f
Maceira	Guarda	Fornos de Algodres	90509	f
Matança	Guarda	Fornos de Algodres	90510	f
Muxagata	Guarda	Fornos de Algodres	90511	f
Queiriz	Guarda	Fornos de Algodres	90512	f
Sobral Pichorro	Guarda	Fornos de Algodres	90513	f
Vila Chã	Guarda	Fornos de Algodres	90514	f
Vila Ruiva	Guarda	Fornos de Algodres	90515	f
Vila Soeiro do Chão	Guarda	Fornos de Algodres	90516	f
Aldeias	Guarda	Gouveia	90601	f
Arcozelo	Guarda	Gouveia	90602	f
Cativelos	Guarda	Gouveia	90603	f
Figueiró da Serra	Guarda	Gouveia	90604	f
Folgosinho	Guarda	Gouveia	90605	f
Freixo da Serra	Guarda	Gouveia	90606	f
Lagarinhos	Guarda	Gouveia	90607	f
Mangualde da Serra	Guarda	Gouveia	90608	f
Melo	Guarda	Gouveia	90609	f
Moimenta da Serra	Guarda	Gouveia	90610	f
Nabais	Guarda	Gouveia	90611	f
Nespereira	Guarda	Gouveia	90612	f
Paços da Serra	Guarda	Gouveia	90613	f
Ribamondego	Guarda	Gouveia	90614	f
Rio Torto	Guarda	Gouveia	90615	f
Gouveia (São Julião)	Guarda	Gouveia	90616	f
São Paio	Guarda	Gouveia	90617	f
Gouveia (São Pedro)	Guarda	Gouveia	90618	f
Vila Cortês da Serra	Guarda	Gouveia	90619	f
Vila Franca da Serra	Guarda	Gouveia	90620	f
Vila Nova de Tazem	Guarda	Gouveia	90621	f
Vinhó	Guarda	Gouveia	90622	f
Adão	Guarda	Guarda	90701	f
Albardo	Guarda	Guarda	90702	f
Aldeia do Bispo	Guarda	Guarda	90703	f
Aldeia Viçosa	Guarda	Guarda	90704	f
Alvendre	Guarda	Guarda	90705	f
Arrifana	Guarda	Guarda	90706	f
Avelãs de Ambom	Guarda	Guarda	90707	f
Avelãs da Ribeira	Guarda	Guarda	90708	f
Benespera	Guarda	Guarda	90709	f
Carvalhal Meão	Guarda	Guarda	90710	f
Casal de Cinza	Guarda	Guarda	90711	f
Castanheira	Guarda	Guarda	90712	f
Cavadoude	Guarda	Guarda	90713	f
Codesseiro	Guarda	Guarda	90714	f
Corujeira	Guarda	Guarda	90715	f
Faia	Guarda	Guarda	90716	f
Famalicão	Guarda	Guarda	90717	f
Fernão Joanes	Guarda	Guarda	90718	f
Gagos	Guarda	Guarda	90719	f
Gonçalo	Guarda	Guarda	90720	f
Gonçalo Bocas	Guarda	Guarda	90721	f
João Antão	Guarda	Guarda	90722	f
Maçainhas de Baixo	Guarda	Guarda	90723	f
Marmeleiro	Guarda	Guarda	90724	f
Meios	Guarda	Guarda	90725	f
Mizarela	Guarda	Guarda	90726	f
Monte Margarida	Guarda	Guarda	90727	f
Panoias de Cima	Guarda	Guarda	90728	f
Pega	Guarda	Guarda	90729	f
Pêra do Moço	Guarda	Guarda	90730	f
Pêro Soares	Guarda	Guarda	90731	f
Porto da Carne	Guarda	Guarda	90732	f
Pousada	Guarda	Guarda	90733	f
Ramela	Guarda	Guarda	90734	f
Ribeira dos Carinhos	Guarda	Guarda	90735	f
Rocamondo	Guarda	Guarda	90736	f
Rochoso	Guarda	Guarda	90737	f
Santana da Azinha	Guarda	Guarda	90738	f
Jarmelo (São Miguel)	Guarda	Guarda	90739	f
Jarmelo (São Pedro)	Guarda	Guarda	90740	f
Guarda (São Vicente)	Guarda	Guarda	90741	f
Guarda (Sé)	Guarda	Guarda	90742	f
Seixo Amarelo	Guarda	Guarda	90743	f
Sobral da Serra	Guarda	Guarda	90744	f
Trinta	Guarda	Guarda	90745	f
Vale de Estrela	Guarda	Guarda	90746	f
Valhelhas	Guarda	Guarda	90747	f
Vela	Guarda	Guarda	90748	f
Videmonte	Guarda	Guarda	90749	f
Vila Cortês do Mondego	Guarda	Guarda	90750	f
Vila Fernando	Guarda	Guarda	90751	f
Vila Franca do Deão	Guarda	Guarda	90752	f
Vila Garcia	Guarda	Guarda	90753	f
Vila Soeiro	Guarda	Guarda	90754	f
São Miguel da Guarda	Guarda	Guarda	90755	f
Sameiro	Guarda	Manteigas	90801	f
Manteigas (Santa Maria)	Guarda	Manteigas	90802	f
Manteigas (São Pedro)	Guarda	Manteigas	90803	f
Vale de Amoreira	Guarda	Manteigas	90804	f
Aveloso	Guarda	Meda	90901	f
Barreira	Guarda	Meda	90902	f
Carvalhal	Guarda	Meda	90903	f
Casteição	Guarda	Meda	90904	f
Coriscada	Guarda	Meda	90905	f
Fonte Longa	Guarda	Meda	90906	f
Longroiva	Guarda	Meda	90907	f
Marialva	Guarda	Meda	90908	f
Meda	Guarda	Meda	90909	f
Outeiro de Gatos	Guarda	Meda	90910	f
Pai Penela	Guarda	Meda	90911	f
Poço do Canto	Guarda	Meda	90912	f
Prova	Guarda	Meda	90913	f
Rabaçal	Guarda	Meda	90914	f
Ranhados	Guarda	Meda	90915	f
Vale Flor	Guarda	Meda	90916	f
Alverca da Beira	Guarda	Pinhel	91001	f
Atalaia	Guarda	Pinhel	91002	f
Azevo	Guarda	Pinhel	91003	f
Bogalhal	Guarda	Pinhel	91004	f
Bouça Cova	Guarda	Pinhel	91005	f
Cerejo	Guarda	Pinhel	91006	f
Cidadelhe	Guarda	Pinhel	91007	f
Ervas Tenras	Guarda	Pinhel	91008	f
Ervedosa	Guarda	Pinhel	91009	f
Freixedas	Guarda	Pinhel	91010	f
Gouveia	Guarda	Pinhel	91011	f
Lamegal	Guarda	Pinhel	91012	f
Lameiras	Guarda	Pinhel	91013	f
Manigoto	Guarda	Pinhel	91014	f
Pala	Guarda	Pinhel	91015	f
Pereiro	Guarda	Pinhel	91016	f
Pinhel	Guarda	Pinhel	91017	f
Pínzio	Guarda	Pinhel	91018	f
Pomares	Guarda	Pinhel	91019	f
Póvoa dEl-Rei	Guarda	Pinhel	91020	f
Safurdão	Guarda	Pinhel	91021	f
Santa Eufémia	Guarda	Pinhel	91022	f
Sorval	Guarda	Pinhel	91023	f
Souro Pires	Guarda	Pinhel	91024	f
Valbom	Guarda	Pinhel	91025	f
Vale de Madeira	Guarda	Pinhel	91026	f
Vascoveiro	Guarda	Pinhel	91027	f
Águas Belas	Guarda	Sabugal	91101	f
Aldeia do Bispo	Guarda	Sabugal	91102	f
Aldeia da Ponte	Guarda	Sabugal	91103	f
Aldeia da Ribeira	Guarda	Sabugal	91104	f
Aldeia de Santo António	Guarda	Sabugal	91105	f
Aldeia Velha	Guarda	Sabugal	91106	f
Alfaiates	Guarda	Sabugal	91107	f
Badamalos	Guarda	Sabugal	91108	f
Baraçal	Guarda	Sabugal	91109	f
Bendada	Guarda	Sabugal	91110	f
Bismula	Guarda	Sabugal	91111	f
Casteleiro	Guarda	Sabugal	91112	f
Cerdeira	Guarda	Sabugal	91113	f
Fóios	Guarda	Sabugal	91114	f
Forcalhos	Guarda	Sabugal	91115	f
Lajeosa	Guarda	Sabugal	91116	f
Lomba	Guarda	Sabugal	91117	f
Malcata	Guarda	Sabugal	91118	f
Moita	Guarda	Sabugal	91119	f
Nave	Guarda	Sabugal	91120	f
Pena Lobo	Guarda	Sabugal	91121	f
Pousafoles do Bispo	Guarda	Sabugal	91122	f
Quadrazais	Guarda	Sabugal	91123	f
Quinta de São Bartolomeu	Guarda	Sabugal	91124	f
Rapoula do Côa	Guarda	Sabugal	91125	f
Rebolosa	Guarda	Sabugal	91126	f
Rendo	Guarda	Sabugal	91127	f
Ruivós	Guarda	Sabugal	91128	f
Ruvina	Guarda	Sabugal	91129	f
Sabugal	Guarda	Sabugal	91130	f
Santo Estêvão	Guarda	Sabugal	91131	f
Seixo do Côa	Guarda	Sabugal	91132	f
Sortelha	Guarda	Sabugal	91133	f
Souto	Guarda	Sabugal	91134	f
Vale das Éguas	Guarda	Sabugal	91135	f
Vale de Espinho	Guarda	Sabugal	91136	f
Vale Longo	Guarda	Sabugal	91137	f
Vila Boa	Guarda	Sabugal	91138	f
Vila do Touro	Guarda	Sabugal	91139	f
Vilar Maior	Guarda	Sabugal	91140	f
Alvoco da Serra	Guarda	Seia	91201	f
Cabeça	Guarda	Seia	91202	f
Carragozela	Guarda	Seia	91203	f
Folhadosa	Guarda	Seia	91204	f
Girabolhos	Guarda	Seia	91205	f
Lajes	Guarda	Seia	91206	f
Loriga	Guarda	Seia	91207	f
Paranhos	Guarda	Seia	91208	f
Pinhanços	Guarda	Seia	91209	f
Sabugueiro	Guarda	Seia	91210	f
Sameice	Guarda	Seia	91211	f
Sandomil	Guarda	Seia	91212	f
Santa Comba	Guarda	Seia	91213	f
Santa Eulália	Guarda	Seia	91214	f
Santa Marinha	Guarda	Seia	91215	f
Santiago	Guarda	Seia	91216	f
São Martinho	Guarda	Seia	91217	f
São Romão	Guarda	Seia	91218	f
Sazes da Beira	Guarda	Seia	91219	f
Seia	Guarda	Seia	91220	f
Teixeira	Guarda	Seia	91221	f
Torrozelo	Guarda	Seia	91222	f
Tourais	Guarda	Seia	91223	f
Travancinha	Guarda	Seia	91224	f
Valezim	Guarda	Seia	91225	f
Várzea de Meruge	Guarda	Seia	91226	f
Vide	Guarda	Seia	91227	f
Vila Cova à Coelheira	Guarda	Seia	91228	f
Lapa dos Dinheiros	Guarda	Seia	91229	f
Aldeia Nova	Guarda	Trancoso	91301	f
Carnicães	Guarda	Trancoso	91302	f
Castanheira	Guarda	Trancoso	91303	f
Cogula	Guarda	Trancoso	91304	f
Cótimos	Guarda	Trancoso	91305	f
Feital	Guarda	Trancoso	91306	f
Fiães	Guarda	Trancoso	91307	f
Freches	Guarda	Trancoso	91308	f
Granja	Guarda	Trancoso	91309	f
Guilheiro	Guarda	Trancoso	91310	f
Moimentinha	Guarda	Trancoso	91311	f
Moreira de Rei	Guarda	Trancoso	91312	f
Palhais	Guarda	Trancoso	91313	f
Póvoa do Concelho	Guarda	Trancoso	91314	f
Reboleiro	Guarda	Trancoso	91315	f
Rio de Mel	Guarda	Trancoso	91316	f
Trancoso (Santa Maria)	Guarda	Trancoso	91317	f
Trancoso (São Pedro)	Guarda	Trancoso	91318	f
Sebadelhe da Serra	Guarda	Trancoso	91319	f
Souto Maior	Guarda	Trancoso	91320	f
Tamanhos	Guarda	Trancoso	91321	f
Terrenho	Guarda	Trancoso	91322	f
Torre do Terrenho	Guarda	Trancoso	91323	f
Torres	Guarda	Trancoso	91324	f
Valdujo	Guarda	Trancoso	91325	f
Vale do Seixo	Guarda	Trancoso	91326	f
Vila Franca das Naves	Guarda	Trancoso	91327	f
Vila Garcia	Guarda	Trancoso	91328	f
Vilares	Guarda	Trancoso	91329	f
Almendra	Guarda	Vila Nova de Foz Côa	91401	f
Castelo Melhor	Guarda	Vila Nova de Foz Côa	91402	f
Cedovim	Guarda	Vila Nova de Foz Côa	91403	f
Chãs	Guarda	Vila Nova de Foz Côa	91404	f
Custóias	Guarda	Vila Nova de Foz Côa	91405	f
Freixo de Numão	Guarda	Vila Nova de Foz Côa	91406	f
Horta	Guarda	Vila Nova de Foz Côa	91407	f
Mós	Guarda	Vila Nova de Foz Côa	91408	f
Murça	Guarda	Vila Nova de Foz Côa	91409	f
Muxagata	Guarda	Vila Nova de Foz Côa	91410	f
Numão	Guarda	Vila Nova de Foz Côa	91411	f
Santa Comba	Guarda	Vila Nova de Foz Côa	91412	f
Santo Amaro	Guarda	Vila Nova de Foz Côa	91413	f
Sebadelhe	Guarda	Vila Nova de Foz Côa	91414	f
Seixas	Guarda	Vila Nova de Foz Côa	91415	f
Touça	Guarda	Vila Nova de Foz Côa	91416	f
Vila Nova de Foz Côa	Guarda	Vila Nova de Foz Côa	91417	f
Alcobaça	Leiria	Alcobaça	100101	f
Alfeizerão	Leiria	Alcobaça	100102	f
Alpedriz	Leiria	Alcobaça	100103	f
Bárrio	Leiria	Alcobaça	100104	f
Benedita	Leiria	Alcobaça	100105	f
Cela	Leiria	Alcobaça	100106	f
Coz	Leiria	Alcobaça	100107	f
Évora de Alcobaça	Leiria	Alcobaça	100108	f
Maiorga	Leiria	Alcobaça	100109	f
Pataias	Leiria	Alcobaça	100110	f
Aljubarrota (Prazeres)	Leiria	Alcobaça	100111	f
São Martinho do Porto	Leiria	Alcobaça	100112	f
Aljubarrota (São Vicente)	Leiria	Alcobaça	100113	f
Turquel	Leiria	Alcobaça	100114	f
Vestiaria	Leiria	Alcobaça	100115	f
Vimeiro	Leiria	Alcobaça	100116	f
Martingança	Leiria	Alcobaça	100118	f
Montes	Leiria	Alcobaça	100119	f
Almoster	Leiria	Alvaiázere	100201	f
Alvaiázere	Leiria	Alvaiázere	100202	f
Maçãs de Caminho	Leiria	Alvaiázere	100203	f
Maçãs de Dona Maria	Leiria	Alvaiázere	100204	f
Pelmá	Leiria	Alvaiázere	100205	f
Pussos	Leiria	Alvaiázere	100206	f
Rego da Murta	Leiria	Alvaiázere	100207	f
Alvorge	Leiria	Ansião	100301	f
Ansião	Leiria	Ansião	100302	f
Avelar	Leiria	Ansião	100303	f
Chão de Couce	Leiria	Ansião	100304	f
Lagarteira	Leiria	Ansião	100305	f
Pousaflores	Leiria	Ansião	100306	f
Santiago da Guarda	Leiria	Ansião	100307	f
Torre de Vale de Todos	Leiria	Ansião	100308	f
Batalha	Leiria	Batalha	100401	f
Reguengo do Fetal	Leiria	Batalha	100402	f
São Mamede	Leiria	Batalha	100403	f
Golpilheira	Leiria	Batalha	100404	f
Bombarral	Leiria	Bombarral	100501	f
Carvalhal	Leiria	Bombarral	100502	f
Roliça	Leiria	Bombarral	100503	f
Vale Covo	Leiria	Bombarral	100504	f
Pó	Leiria	Bombarral	100505	f
A dos Francos	Leiria	Caldas da Rainha	100601	f
Alvorninha	Leiria	Caldas da Rainha	100602	f
Caldas da Rainha (N Senhora do Pópulo)	Leiria	Caldas da Rainha	100603	f
Carvalhal Benfeito	Leiria	Caldas da Rainha	100604	f
Coto	Leiria	Caldas da Rainha	100605	f
Foz do Arelho	Leiria	Caldas da Rainha	100606	f
Landal	Leiria	Caldas da Rainha	100607	f
Nadadouro	Leiria	Caldas da Rainha	100608	f
Salir de Matos	Leiria	Caldas da Rainha	100609	f
Salir do Porto	Leiria	Caldas da Rainha	100610	f
Santa Catarina	Leiria	Caldas da Rainha	100611	f
São Gregório	Leiria	Caldas da Rainha	100612	f
Serra do Bouro	Leiria	Caldas da Rainha	100613	f
Tornada	Leiria	Caldas da Rainha	100614	f
Vidais	Leiria	Caldas da Rainha	100615	f
Caldas da Rainha (Santo Onofre)	Leiria	Caldas da Rainha	100616	f
Castanheira de Pêra	Leiria	Castanheira de Pêra	100701	f
Coentral	Leiria	Castanheira de Pêra	100702	f
Aguda	Leiria	Figueiró dos Vinhos	100801	f
Arega	Leiria	Figueiró dos Vinhos	100802	f
Campelo	Leiria	Figueiró dos Vinhos	100803	f
Figueiró dos Vinhos	Leiria	Figueiró dos Vinhos	100804	f
Bairradas	Leiria	Figueiró dos Vinhos	100805	f
Amor	Leiria	Leiria	100901	f
Arrabal	Leiria	Leiria	100902	f
Azoia	Leiria	Leiria	100903	f
Barosa	Leiria	Leiria	100904	f
Barreira	Leiria	Leiria	100905	f
Boa Vista	Leiria	Leiria	100906	f
Caranguejeira	Leiria	Leiria	100907	f
Carvide	Leiria	Leiria	100908	f
Coimbrão	Leiria	Leiria	100909	f
Colmeias	Leiria	Leiria	100910	f
Cortes	Leiria	Leiria	100911	f
Leiria	Leiria	Leiria	100912	f
Maceira	Leiria	Leiria	100913	f
Marrazes	Leiria	Leiria	100914	f
Milagres	Leiria	Leiria	100915	f
Monte Real	Leiria	Leiria	100916	f
Monte Redondo	Leiria	Leiria	100917	f
Ortigosa	Leiria	Leiria	100918	f
Parceiros	Leiria	Leiria	100919	f
Pousos	Leiria	Leiria	100920	f
Regueira de Pontes	Leiria	Leiria	100921	f
Santa Catarina da Serra	Leiria	Leiria	100922	f
Santa Eufémia	Leiria	Leiria	100923	f
Souto da Carpalhosa	Leiria	Leiria	100924	f
Bajouca	Leiria	Leiria	100925	f
Bidoeira de Cima	Leiria	Leiria	100926	f
Memória	Leiria	Leiria	100927	f
Carreira	Leiria	Leiria	100930	f
Chainça	Leiria	Leiria	100931	f
Marinha Grande	Leiria	Marinha Grande	101001	f
Vieira de Leiria	Leiria	Marinha Grande	101002	f
Moita	Leiria	Marinha Grande	101003	f
Famalicão	Leiria	Nazaré	101101	f
Nazaré	Leiria	Nazaré	101102	f
Valado dos Frades	Leiria	Nazaré	101103	f
A dos Negros	Leiria	Óbidos	101201	f
Amoreira	Leiria	Óbidos	101202	f
Olho Marinho	Leiria	Óbidos	101203	f
Óbidos (Santa Maria)	Leiria	Óbidos	101204	f
Óbidos (São Pedro)	Leiria	Óbidos	101205	f
Sobral da Lagoa	Leiria	Óbidos	101206	f
Vau	Leiria	Óbidos	101207	f
Gaeiras	Leiria	Óbidos	101208	f
Usseira	Leiria	Óbidos	101209	f
Graça	Leiria	Pedrógão Grande	101301	f
Pedrógão Grande	Leiria	Pedrógão Grande	101302	f
Vila Facaia	Leiria	Pedrógão Grande	101303	f
Peniche (Ajuda)	Leiria	Peniche	101401	f
Atouguia da Baleia	Leiria	Peniche	101402	f
Peniche (Conceição)	Leiria	Peniche	101403	f
Peniche (São Pedro)	Leiria	Peniche	101404	f
Serra dEl-Rei	Leiria	Peniche	101405	f
Ferrel	Leiria	Peniche	101406	f
Abiul	Leiria	Pombal	101501	f
Albergaria dos Doze	Leiria	Pombal	101502	f
Almagreira	Leiria	Pombal	101503	f
Carnide	Leiria	Pombal	101504	f
Carriço	Leiria	Pombal	101505	f
Louriçal	Leiria	Pombal	101506	f
Mata Mourisca	Leiria	Pombal	101507	f
Pelariga	Leiria	Pombal	101508	f
Pombal	Leiria	Pombal	101509	f
Redinha	Leiria	Pombal	101510	f
Santiago de Litém	Leiria	Pombal	101511	f
São Simão de Litém	Leiria	Pombal	101512	f
Vermoil	Leiria	Pombal	101513	f
Vila Chã	Leiria	Pombal	101514	f
Meirinhas	Leiria	Pombal	101515	f
Guia	Leiria	Pombal	101516	f
Ilha	Leiria	Pombal	101517	f
Alcaria	Leiria	Porto de Mós	101601	f
Alqueidão da Serra	Leiria	Porto de Mós	101602	f
Alvados	Leiria	Porto de Mós	101603	f
Arrimal	Leiria	Porto de Mós	101604	f
Calvaria de Cima	Leiria	Porto de Mós	101605	f
Juncal	Leiria	Porto de Mós	101606	f
Mendiga	Leiria	Porto de Mós	101607	f
Mira de Aire	Leiria	Porto de Mós	101608	f
Pedreiras	Leiria	Porto de Mós	101609	f
São Bento	Leiria	Porto de Mós	101610	f
Porto de Mós (São João Baptista)	Leiria	Porto de Mós	101611	f
Porto de Mós (São Pedro)	Leiria	Porto de Mós	101612	f
Serro Ventoso	Leiria	Porto de Mós	101613	f
Abrigada	Lisboa	Alenquer	110101	f
Aldeia Galega da Merceana	Lisboa	Alenquer	110102	f
Aldeia Gavinha	Lisboa	Alenquer	110103	f
Cabanas de Torres	Lisboa	Alenquer	110104	f
Cadafais	Lisboa	Alenquer	110105	f
Carnota	Lisboa	Alenquer	110106	f
Meca	Lisboa	Alenquer	110107	f
Olhalvo	Lisboa	Alenquer	110108	f
Ota	Lisboa	Alenquer	110109	f
Pereiro de Palhacana	Lisboa	Alenquer	110110	f
Alenquer (Santo Estêvão)	Lisboa	Alenquer	110111	f
Alenquer (Triana)	Lisboa	Alenquer	110112	f
Ventosa	Lisboa	Alenquer	110113	f
Vila Verde dos Francos	Lisboa	Alenquer	110114	f
Carregado	Lisboa	Alenquer	110115	f
Ribafria	Lisboa	Alenquer	110116	f
Arranhó	Lisboa	Arruda dos Vinhos	110201	f
Arruda dos Vinhos	Lisboa	Arruda dos Vinhos	110202	f
Cardosas	Lisboa	Arruda dos Vinhos	110203	f
Santiago dos Velhos	Lisboa	Arruda dos Vinhos	110204	f
Alcoentre	Lisboa	Azambuja	110301	f
Aveiras de Baixo	Lisboa	Azambuja	110302	f
Aveiras de Cima	Lisboa	Azambuja	110303	f
Azambuja	Lisboa	Azambuja	110304	f
Manique do Intendente	Lisboa	Azambuja	110305	f
Vale do Paraíso	Lisboa	Azambuja	110306	f
Vila Nova da Rainha	Lisboa	Azambuja	110307	f
Vila Nova de São Pedro	Lisboa	Azambuja	110308	f
Maçussa	Lisboa	Azambuja	110309	f
Alguber	Lisboa	Cadaval	110401	f
Cadaval	Lisboa	Cadaval	110402	f
Cercal	Lisboa	Cadaval	110403	f
Figueiros	Lisboa	Cadaval	110404	f
Lamas	Lisboa	Cadaval	110405	f
Painho	Lisboa	Cadaval	110406	f
Peral	Lisboa	Cadaval	110407	f
Pêro Moniz	Lisboa	Cadaval	110408	f
Vermelha	Lisboa	Cadaval	110409	f
Vilar	Lisboa	Cadaval	110410	f
Alcabideche	Lisboa	Cascais	110501	f
Carcavelos	Lisboa	Cascais	110502	f
Cascais	Lisboa	Cascais	110503	f
Estoril	Lisboa	Cascais	110504	f
Parede	Lisboa	Cascais	110505	f
São Domingos de Rana	Lisboa	Cascais	110506	f
Ajuda	Lisboa	Lisboa	110601	f
Alcântara	Lisboa	Lisboa	110602	f
Alto do Pina	Lisboa	Lisboa	110603	f
Alvalade	Lisboa	Lisboa	110604	f
Ameixoeira	Lisboa	Lisboa	110605	f
Anjos	Lisboa	Lisboa	110606	f
Beato	Lisboa	Lisboa	110607	f
Benfica	Lisboa	Lisboa	110608	f
Campo Grande	Lisboa	Lisboa	110609	f
Campolide	Lisboa	Lisboa	110610	f
Carnide	Lisboa	Lisboa	110611	f
Castelo	Lisboa	Lisboa	110612	f
Charneca	Lisboa	Lisboa	110613	f
Coração de Jesus	Lisboa	Lisboa	110614	f
Encarnação	Lisboa	Lisboa	110615	f
Graça	Lisboa	Lisboa	110616	f
Lapa	Lisboa	Lisboa	110617	f
Lumiar	Lisboa	Lisboa	110618	f
Madalena	Lisboa	Lisboa	110619	f
Mártires	Lisboa	Lisboa	110620	f
Marvila	Lisboa	Lisboa	110621	f
Mercês	Lisboa	Lisboa	110622	f
Nossa Senhora de Fátima	Lisboa	Lisboa	110623	f
Pena	Lisboa	Lisboa	110624	f
Penha de França	Lisboa	Lisboa	110625	f
Prazeres	Lisboa	Lisboa	110626	f
Sacramento	Lisboa	Lisboa	110627	f
Santa Catarina	Lisboa	Lisboa	110628	f
Santa Engrácia	Lisboa	Lisboa	110629	f
Santa Isabel	Lisboa	Lisboa	110630	f
Santa Justa	Lisboa	Lisboa	110631	f
Santa Maria de Belém	Lisboa	Lisboa	110632	f
Santa Maria dos Olivais	Lisboa	Lisboa	110633	f
Santiago	Lisboa	Lisboa	110634	f
Santo Condestável	Lisboa	Lisboa	110635	f
Santo Estêvão	Lisboa	Lisboa	110636	f
Santos-o-Velho	Lisboa	Lisboa	110637	f
São Cristóvão e São Lourenço	Lisboa	Lisboa	110638	f
São Domingos de Benfica	Lisboa	Lisboa	110639	f
São Francisco Xavier	Lisboa	Lisboa	110640	f
São João	Lisboa	Lisboa	110641	f
São João de Brito	Lisboa	Lisboa	110642	f
São João de Deus	Lisboa	Lisboa	110643	f
São Jorge de Arroios	Lisboa	Lisboa	110644	f
São José	Lisboa	Lisboa	110645	f
São Mamede	Lisboa	Lisboa	110646	f
São Miguel	Lisboa	Lisboa	110647	f
São Nicolau	Lisboa	Lisboa	110648	f
São Paulo	Lisboa	Lisboa	110649	f
São Sebastião da Pedreira	Lisboa	Lisboa	110650	f
São Vicente de Fora	Lisboa	Lisboa	110651	f
Sé	Lisboa	Lisboa	110652	f
Socorro	Lisboa	Lisboa	110653	f
Apelação	Lisboa	Loures	110701	f
Bucelas	Lisboa	Loures	110702	f
Camarate	Lisboa	Loures	110703	f
Fanhões	Lisboa	Loures	110705	f
Frielas	Lisboa	Loures	110706	f
Loures	Lisboa	Loures	110707	f
Lousa	Lisboa	Loures	110708	f
Moscavide	Lisboa	Loures	110709	f
Sacavém	Lisboa	Loures	110712	f
Santa Iria de Azoia	Lisboa	Loures	110713	f
Santo Antão do Tojal	Lisboa	Loures	110714	f
São João da Talha	Lisboa	Loures	110715	f
São Julião do Tojal	Lisboa	Loures	110716	f
Unhos	Lisboa	Loures	110717	f
Portela	Lisboa	Loures	110719	f
Bobadela	Lisboa	Loures	110722	f
Prior Velho	Lisboa	Loures	110723	f
Santo António dos Cavaleiros	Lisboa	Loures	110724	f
Lourinhã	Lisboa	Lourinhã	110801	f
Miragaia	Lisboa	Lourinhã	110802	f
Moita dos Ferreiros	Lisboa	Lourinhã	110803	f
Moledo	Lisboa	Lourinhã	110804	f
Reguengo Grande	Lisboa	Lourinhã	110805	f
Santa Bárbara	Lisboa	Lourinhã	110806	f
São Bartolomeu dos Galegos	Lisboa	Lourinhã	110807	f
Vimeiro	Lisboa	Lourinhã	110808	f
Marteleira	Lisboa	Lourinhã	110809	f
Ribamar	Lisboa	Lourinhã	110810	f
Atalaia	Lisboa	Lourinhã	110811	f
Azueira	Lisboa	Mafra	110901	f
Carvoeira	Lisboa	Mafra	110902	f
Cheleiros	Lisboa	Mafra	110903	f
Encarnação	Lisboa	Mafra	110904	f
Enxara do Bispo	Lisboa	Mafra	110905	f
Ericeira	Lisboa	Mafra	110906	f
Gradil	Lisboa	Mafra	110907	f
Igreja Nova	Lisboa	Mafra	110908	f
Mafra	Lisboa	Mafra	110909	f
Malveira	Lisboa	Mafra	110910	f
Milharado	Lisboa	Mafra	110911	f
Santo Estêvão das Galés	Lisboa	Mafra	110912	f
Santo Isidoro	Lisboa	Mafra	110913	f
Sobral da Abelheira	Lisboa	Mafra	110914	f
Vila Franca do Rosário	Lisboa	Mafra	110915	f
Venda do Pinheiro	Lisboa	Mafra	110916	f
São Miguel de Alcainça	Lisboa	Mafra	110917	f
Barcarena	Lisboa	Oeiras	111002	f
Carnaxide	Lisboa	Oeiras	111003	f
Oeiras e São Julião da Barra	Lisboa	Oeiras	111004	f
Paço de Arcos	Lisboa	Oeiras	111005	f
Algés	Lisboa	Oeiras	111006	f
Cruz Quebrada-Dafundo	Lisboa	Oeiras	111007	f
Linda-a-Velha	Lisboa	Oeiras	111008	f
Porto Salvo	Lisboa	Oeiras	111009	f
Queijas	Lisboa	Oeiras	111010	f
Caxias	Lisboa	Oeiras	111011	f
Algueirão-Mem Martins	Lisboa	Sintra	111102	f
Almargem do Bispo	Lisboa	Sintra	111103	f
Belas	Lisboa	Sintra	111104	f
Colares	Lisboa	Sintra	111105	f
Montelavar	Lisboa	Sintra	111106	f
Queluz	Lisboa	Sintra	111107	f
Rio de Mouro	Lisboa	Sintra	111108	f
Sintra (Santa Maria e São Miguel)	Lisboa	Sintra	111109	f
São João das Lampas	Lisboa	Sintra	111110	f
Sintra (São Martinho)	Lisboa	Sintra	111111	f
Sintra (São Pedro de Penaferrim)	Lisboa	Sintra	111112	f
Terrugem	Lisboa	Sintra	111113	f
Pêro Pinheiro	Lisboa	Sintra	111114	f
Casal de Cambra	Lisboa	Sintra	111115	f
Massamá	Lisboa	Sintra	111116	f
Monte Abraão	Lisboa	Sintra	111117	f
Agualva	Lisboa	Sintra	111118	f
Cacém	Lisboa	Sintra	111119	f
Mira-Sintra	Lisboa	Sintra	111120	f
São Marcos	Lisboa	Sintra	111121	f
Santo Quintino	Lisboa	Sobral de Monte Agraço	111201	f
Sapataria	Lisboa	Sobral de Monte Agraço	111202	f
Sobral de Monte Agraço	Lisboa	Sobral de Monte Agraço	111203	f
A dos Cunhados	Lisboa	Torres Vedras	111301	f
Campelos	Lisboa	Torres Vedras	111302	f
Carmões	Lisboa	Torres Vedras	111303	f
Carvoeira	Lisboa	Torres Vedras	111304	f
Dois Portos	Lisboa	Torres Vedras	111305	f
Freiria	Lisboa	Torres Vedras	111306	f
Matacães	Lisboa	Torres Vedras	111307	f
Maxial	Lisboa	Torres Vedras	111308	f
Monte Redondo	Lisboa	Torres Vedras	111309	f
Ponte do Rol	Lisboa	Torres Vedras	111310	f
Ramalhal	Lisboa	Torres Vedras	111311	f
Runa	Lisboa	Torres Vedras	111312	f
Torres V (Sta Maria do Castelo S Miguel	Lisboa	Torres Vedras	111313	f
São Pedro da Cadeira	Lisboa	Torres Vedras	111314	f
Torres Vedras (São Pedro e Santiago)	Lisboa	Torres Vedras	111315	f
Silveira	Lisboa	Torres Vedras	111316	f
Turcifal	Lisboa	Torres Vedras	111317	f
Ventosa	Lisboa	Torres Vedras	111318	f
Outeiro da Cabeça	Lisboa	Torres Vedras	111319	f
Maceira	Lisboa	Torres Vedras	111320	f
Alhandra	Lisboa	Vila Franca de Xira	111401	f
Alverca do Ribatejo	Lisboa	Vila Franca de Xira	111402	f
Cachoeiras	Lisboa	Vila Franca de Xira	111403	f
Calhandriz	Lisboa	Vila Franca de Xira	111404	f
Castanheira do Ribatejo	Lisboa	Vila Franca de Xira	111405	f
Póvoa de Santa Iria	Lisboa	Vila Franca de Xira	111406	f
São João dos Montes	Lisboa	Vila Franca de Xira	111407	f
Vialonga	Lisboa	Vila Franca de Xira	111408	f
Vila Franca de Xira	Lisboa	Vila Franca de Xira	111409	f
Sobralinho	Lisboa	Vila Franca de Xira	111410	f
Forte da Casa	Lisboa	Vila Franca de Xira	111411	f
Alfragide	Lisboa	Amadora	111501	f
Brandoa	Lisboa	Amadora	111502	f
Buraca	Lisboa	Amadora	111503	f
Damaia	Lisboa	Amadora	111504	f
Falagueira	Lisboa	Amadora	111505	f
Mina	Lisboa	Amadora	111506	f
Reboleira	Lisboa	Amadora	111507	f
Venteira	Lisboa	Amadora	111508	f
Alfornelos	Lisboa	Amadora	111509	f
São Brás	Lisboa	Amadora	111510	f
Venda Nova	Lisboa	Amadora	111511	f
Caneças	Lisboa	Odivelas	111601	f
Famões	Lisboa	Odivelas	111602	f
Odivelas	Lisboa	Odivelas	111603	f
Olival Basto	Lisboa	Odivelas	111604	f
Pontinha	Lisboa	Odivelas	111605	f
Póvoa de Santo Adrião	Lisboa	Odivelas	111606	f
Ramada	Lisboa	Odivelas	111607	f
Alter do Chão	Portalegre	Alter do Chão	120101	f
Chancelaria	Portalegre	Alter do Chão	120102	f
Seda	Portalegre	Alter do Chão	120103	f
Cunheira	Portalegre	Alter do Chão	120104	f
Assunção	Portalegre	Arronches	120201	f
Esperança	Portalegre	Arronches	120202	f
Mosteiros	Portalegre	Arronches	120203	f
Alcôrrego	Portalegre	Avis	120301	f
Aldeia Velha	Portalegre	Avis	120302	f
Avis	Portalegre	Avis	120303	f
Benavila	Portalegre	Avis	120304	f
Ervedal	Portalegre	Avis	120305	f
Figueira e Barros	Portalegre	Avis	120306	f
Maranhão	Portalegre	Avis	120307	f
Valongo	Portalegre	Avis	120308	f
Nossa Senhora da Expectação	Portalegre	Campo Maior	120401	f
Nossa Senhora da Graça dos Degolados	Portalegre	Campo Maior	120402	f
São João Baptista	Portalegre	Campo Maior	120403	f
Nossa Senhora da Graça de Póvoa e Meada	Portalegre	Castelo de Vide	120501	f
Santa Maria da Devesa	Portalegre	Castelo de Vide	120502	f
Santiago Maior	Portalegre	Castelo de Vide	120503	f
São João Baptista	Portalegre	Castelo de Vide	120504	f
Aldeia da Mata	Portalegre	Crato	120601	f
Crato e Mártires	Portalegre	Crato	120602	f
Flor da Rosa	Portalegre	Crato	120603	f
Gáfete	Portalegre	Crato	120604	f
Monte da Pedra	Portalegre	Crato	120605	f
Vale do Peso	Portalegre	Crato	120606	f
Ajuda, Salvador e Santo Ildefonso	Portalegre	Elvas	120701	f
Alcáçova	Portalegre	Elvas	120702	f
Assunção	Portalegre	Elvas	120703	f
Barbacena	Portalegre	Elvas	120704	f
Caia e São Pedro	Portalegre	Elvas	120705	f
Santa Eulália	Portalegre	Elvas	120706	f
São Brás e São Lourenço	Portalegre	Elvas	120707	f
São Vicente e Ventosa	Portalegre	Elvas	120708	f
Terrugem	Portalegre	Elvas	120709	f
Vila Boim	Portalegre	Elvas	120710	f
Vila Fernando	Portalegre	Elvas	120711	f
Cabeço de Vide	Portalegre	Fronteira	120801	f
Fronteira	Portalegre	Fronteira	120802	f
São Saturnino	Portalegre	Fronteira	120803	f
Atalaia	Portalegre	Gavião	120901	f
Belver	Portalegre	Gavião	120902	f
Comenda	Portalegre	Gavião	120903	f
Gavião	Portalegre	Gavião	120904	f
Margem	Portalegre	Gavião	120905	f
Beirã	Portalegre	Marvão	121001	f
Santa Maria de Marvão	Portalegre	Marvão	121002	f
Santo António das Areias	Portalegre	Marvão	121003	f
São Salvador da Aramenha	Portalegre	Marvão	121004	f
Assumar	Portalegre	Monforte	121101	f
Monforte	Portalegre	Monforte	121102	f
Santo Aleixo	Portalegre	Monforte	121103	f
Vaiamonte	Portalegre	Monforte	121104	f
Alpalhão	Portalegre	Nisa	121201	f
Amieira do Tejo	Portalegre	Nisa	121202	f
Arez	Portalegre	Nisa	121203	f
Espírito Santo	Portalegre	Nisa	121204	f
Montalvão	Portalegre	Nisa	121205	f
Nossa Senhora da Graça	Portalegre	Nisa	121206	f
Santana	Portalegre	Nisa	121207	f
São Matias	Portalegre	Nisa	121208	f
São Simão	Portalegre	Nisa	121209	f
Tolosa	Portalegre	Nisa	121210	f
Galveias	Portalegre	Ponte de Sor	121301	f
Montargil	Portalegre	Ponte de Sor	121302	f
Ponte de Sor	Portalegre	Ponte de Sor	121303	f
Foros de Arrão	Portalegre	Ponte de Sor	121304	f
Longomel	Portalegre	Ponte de Sor	121305	f
Vale de Açor	Portalegre	Ponte de Sor	121306	f
Tramaga	Portalegre	Ponte de Sor	121307	f
Alagoa	Portalegre	Portalegre	121401	f
Alegrete	Portalegre	Portalegre	121402	f
Carreiras	Portalegre	Portalegre	121403	f
Fortios	Portalegre	Portalegre	121404	f
Reguengo	Portalegre	Portalegre	121405	f
Ribeira de Nisa	Portalegre	Portalegre	121406	f
São Julião	Portalegre	Portalegre	121407	f
São Lourenço	Portalegre	Portalegre	121408	f
Sé	Portalegre	Portalegre	121409	f
Urra	Portalegre	Portalegre	121410	f
Cano	Portalegre	Sousel	121501	f
Casa Branca	Portalegre	Sousel	121502	f
Santo Amaro	Portalegre	Sousel	121503	f
Sousel	Portalegre	Sousel	121504	f
Aboadela	Porto	Amarante	130101	f
Aboim	Porto	Amarante	130102	f
Ansiães	Porto	Amarante	130103	f
Ataíde	Porto	Amarante	130104	f
Bustelo	Porto	Amarante	130105	f
Canadelo	Porto	Amarante	130106	f
Candemil	Porto	Amarante	130107	f
Carneiro	Porto	Amarante	130108	f
Carvalho de Rei	Porto	Amarante	130109	f
Cepelos	Porto	Amarante	130110	f
Chapa	Porto	Amarante	130111	f
Fregim	Porto	Amarante	130112	f
Freixo de Baixo	Porto	Amarante	130113	f
Freixo de Cima	Porto	Amarante	130114	f
Fridão	Porto	Amarante	130115	f
Gatão	Porto	Amarante	130116	f
Gondar	Porto	Amarante	130117	f
Jazente	Porto	Amarante	130118	f
Lomba	Porto	Amarante	130119	f
Louredo	Porto	Amarante	130120	f
Lufrei	Porto	Amarante	130121	f
Madalena	Porto	Amarante	130122	f
Mancelos	Porto	Amarante	130123	f
Oliveira	Porto	Amarante	130124	f
Olo	Porto	Amarante	130125	f
Padronelo	Porto	Amarante	130126	f
Real	Porto	Amarante	130127	f
Rebordelo	Porto	Amarante	130128	f
Salvador do Monte	Porto	Amarante	130129	f
Sanche	Porto	Amarante	130130	f
Figueiró (Santa Cristina)	Porto	Amarante	130131	f
Figueiró (Santiago)	Porto	Amarante	130132	f
Amarante (São Gonçalo)	Porto	Amarante	130133	f
Gouveia (São Simão)	Porto	Amarante	130134	f
Telões	Porto	Amarante	130135	f
Travanca	Porto	Amarante	130136	f
Várzea	Porto	Amarante	130137	f
Vila Caiz	Porto	Amarante	130138	f
Vila Chã do Marão	Porto	Amarante	130139	f
Vila Garcia	Porto	Amarante	130140	f
Ancede	Porto	Baião	130201	f
Campelo	Porto	Baião	130202	f
São Tomé de Covelas	Porto	Baião	130203	f
Frende	Porto	Baião	130204	f
Gestaçô	Porto	Baião	130205	f
Gove	Porto	Baião	130206	f
Grilo	Porto	Baião	130207	f
Loivos do Monte	Porto	Baião	130208	f
Loivos da Ribeira	Porto	Baião	130209	f
Mesquinhata	Porto	Baião	130210	f
Ovil	Porto	Baião	130211	f
Ribadouro	Porto	Baião	130212	f
Santa Cruz do Douro	Porto	Baião	130213	f
Baião (Santa Leocádia)	Porto	Baião	130214	f
Santa Marinha do Zêzere	Porto	Baião	130215	f
Teixeira	Porto	Baião	130216	f
Teixeiró	Porto	Baião	130217	f
Tresouras	Porto	Baião	130218	f
Valadares	Porto	Baião	130219	f
Viariz	Porto	Baião	130220	f
Aião	Porto	Felgueiras	130301	f
Airães	Porto	Felgueiras	130302	f
Borba de Godim	Porto	Felgueiras	130303	f
Caramos	Porto	Felgueiras	130304	f
Friande	Porto	Felgueiras	130305	f
Idães	Porto	Felgueiras	130306	f
Jugueiros	Porto	Felgueiras	130307	f
Lagares	Porto	Felgueiras	130308	f
Lordelo	Porto	Felgueiras	130309	f
Macieira da Lixa	Porto	Felgueiras	130310	f
Moure	Porto	Felgueiras	130311	f
Pedreira	Porto	Felgueiras	130312	f
Penacova	Porto	Felgueiras	130313	f
Pinheiro	Porto	Felgueiras	130314	f
Pombeiro de Ribavizela	Porto	Felgueiras	130315	f
Rande	Porto	Felgueiras	130316	f
Refontoura	Porto	Felgueiras	130317	f
Regilde	Porto	Felgueiras	130318	f
Revinhade	Porto	Felgueiras	130319	f
Margaride (Santa Eulália)	Porto	Felgueiras	130320	f
Santão	Porto	Felgueiras	130321	f
Vizela (São Jorge)	Porto	Felgueiras	130323	f
Sendim	Porto	Felgueiras	130324	f
Sernande	Porto	Felgueiras	130325	f
Sousa	Porto	Felgueiras	130326	f
Torrados	Porto	Felgueiras	130327	f
Unhão	Porto	Felgueiras	130328	f
Várzea	Porto	Felgueiras	130329	f
Varziela	Porto	Felgueiras	130330	f
Vila Cova da Lixa	Porto	Felgueiras	130331	f
Vila Fria	Porto	Felgueiras	130332	f
Vila Verde	Porto	Felgueiras	130333	f
Covelo	Porto	Gondomar	130401	f
Fânzeres	Porto	Gondomar	130402	f
Foz do Sousa	Porto	Gondomar	130403	f
Jovim	Porto	Gondomar	130404	f
Lomba	Porto	Gondomar	130405	f
Medas	Porto	Gondomar	130406	f
Melres	Porto	Gondomar	130407	f
Rio Tinto	Porto	Gondomar	130408	f
Gondomar (São Cosme)	Porto	Gondomar	130409	f
São Pedro da Cova	Porto	Gondomar	130410	f
Valbom	Porto	Gondomar	130411	f
Baguim do Monte (Rio Tinto)	Porto	Gondomar	130412	f
Alvarenga	Porto	Lousada	130501	f
Aveleda	Porto	Lousada	130502	f
Boim	Porto	Lousada	130503	f
Caíde de Rei	Porto	Lousada	130504	f
Casais	Porto	Lousada	130505	f
Cernadelo	Porto	Lousada	130506	f
Covas	Porto	Lousada	130507	f
Cristelos	Porto	Lousada	130508	f
Figueiras	Porto	Lousada	130509	f
Lodares	Porto	Lousada	130510	f
Lustosa	Porto	Lousada	130511	f
Macieira	Porto	Lousada	130512	f
Meinedo	Porto	Lousada	130513	f
Nespereira	Porto	Lousada	130514	f
Nevogilde	Porto	Lousada	130515	f
Nogueira	Porto	Lousada	130516	f
Ordem	Porto	Lousada	130517	f
Pias	Porto	Lousada	130518	f
Lousada (Santa Margarida)	Porto	Lousada	130520	f
Barrosas (Santo Estêvão)	Porto	Lousada	130521	f
Lousada (São Miguel)	Porto	Lousada	130522	f
Silvares	Porto	Lousada	130523	f
Sousela	Porto	Lousada	130524	f
Torno	Porto	Lousada	130525	f
Vilar do Torno e Alentém	Porto	Lousada	130526	f
Águas Santas	Porto	Maia	130601	f
Barca	Porto	Maia	130602	f
Folgosa	Porto	Maia	130603	f
Gemunde	Porto	Maia	130604	f
Gondim	Porto	Maia	130605	f
Gueifães	Porto	Maia	130606	f
Maia	Porto	Maia	130607	f
Milheirós	Porto	Maia	130608	f
Moreira	Porto	Maia	130609	f
Nogueira	Porto	Maia	130610	f
Avioso (Santa Maria)	Porto	Maia	130611	f
Avioso (São Pedro)	Porto	Maia	130612	f
São Pedro Fins	Porto	Maia	130613	f
Silva Escura	Porto	Maia	130614	f
Vermoim	Porto	Maia	130615	f
Vila Nova da Telha	Porto	Maia	130616	f
Pedrouços	Porto	Maia	130617	f
Alpendurada e Matos	Porto	Marco de Canaveses	130701	f
Ariz	Porto	Marco de Canaveses	130702	f
Avessadas	Porto	Marco de Canaveses	130703	f
Banho e Carvalhosa	Porto	Marco de Canaveses	130704	f
Constance	Porto	Marco de Canaveses	130705	f
Favões	Porto	Marco de Canaveses	130706	f
Folhada	Porto	Marco de Canaveses	130707	f
Fornos	Porto	Marco de Canaveses	130708	f
Freixo	Porto	Marco de Canaveses	130709	f
Magrelos	Porto	Marco de Canaveses	130710	f
Manhuncelos	Porto	Marco de Canaveses	130711	f
Maureles	Porto	Marco de Canaveses	130712	f
Paços de Gaiolo	Porto	Marco de Canaveses	130713	f
Paredes de Viadores	Porto	Marco de Canaveses	130714	f
Penha Longa	Porto	Marco de Canaveses	130715	f
Rio de Galinhas	Porto	Marco de Canaveses	130716	f
Rosem	Porto	Marco de Canaveses	130717	f
Sande	Porto	Marco de Canaveses	130718	f
Santo Isidoro	Porto	Marco de Canaveses	130719	f
São Lourenço do Douro	Porto	Marco de Canaveses	130720	f
São Nicolau	Porto	Marco de Canaveses	130721	f
Soalhães	Porto	Marco de Canaveses	130722	f
Sobretâmega	Porto	Marco de Canaveses	130723	f
Tabuado	Porto	Marco de Canaveses	130724	f
Torrão	Porto	Marco de Canaveses	130725	f
Toutosa	Porto	Marco de Canaveses	130726	f
Tuias	Porto	Marco de Canaveses	130727	f
Várzea do Douro	Porto	Marco de Canaveses	130728	f
Várzea da Ovelha e Aliviada	Porto	Marco de Canaveses	130729	f
Vila Boa do Bispo	Porto	Marco de Canaveses	130730	f
Vila Boa de Quires	Porto	Marco de Canaveses	130731	f
Custóias	Porto	Matosinhos	130801	f
Guifões	Porto	Matosinhos	130802	f
Lavra	Porto	Matosinhos	130803	f
Leça do Balio	Porto	Matosinhos	130804	f
Leça da Palmeira	Porto	Matosinhos	130805	f
Matosinhos	Porto	Matosinhos	130806	f
Perafita	Porto	Matosinhos	130807	f
Santa Cruz do Bispo	Porto	Matosinhos	130808	f
São Mamede de Infesta	Porto	Matosinhos	130809	f
Senhora da Hora	Porto	Matosinhos	130810	f
Arreigada	Porto	Paços de Ferreira	130901	f
Carvalhosa	Porto	Paços de Ferreira	130902	f
Codessos	Porto	Paços de Ferreira	130903	f
Eiriz	Porto	Paços de Ferreira	130904	f
Ferreira	Porto	Paços de Ferreira	130905	f
Figueiró	Porto	Paços de Ferreira	130906	f
Frazão	Porto	Paços de Ferreira	130907	f
Freamunde	Porto	Paços de Ferreira	130908	f
Lamoso	Porto	Paços de Ferreira	130909	f
Meixomil	Porto	Paços de Ferreira	130910	f
Modelos	Porto	Paços de Ferreira	130911	f
Paços de Ferreira	Porto	Paços de Ferreira	130912	f
Penamaior	Porto	Paços de Ferreira	130913	f
Raimonda	Porto	Paços de Ferreira	130914	f
Sanfins de Ferreira	Porto	Paços de Ferreira	130915	f
Seroa	Porto	Paços de Ferreira	130916	f
Aguiar de Sousa	Porto	Paredes	131001	f
Astromil	Porto	Paredes	131002	f
Baltar	Porto	Paredes	131003	f
Beire	Porto	Paredes	131004	f
Besteiros	Porto	Paredes	131005	f
Bitarães	Porto	Paredes	131006	f
Castelões de Cepeda	Porto	Paredes	131007	f
Cete	Porto	Paredes	131008	f
Cristelo	Porto	Paredes	131009	f
Duas Igrejas	Porto	Paredes	131010	f
Gandra	Porto	Paredes	131011	f
Gondalães	Porto	Paredes	131012	f
Lordelo	Porto	Paredes	131013	f
Louredo	Porto	Paredes	131014	f
Madalena	Porto	Paredes	131015	f
Mouriz	Porto	Paredes	131016	f
Parada de Todeia	Porto	Paredes	131017	f
Rebordosa	Porto	Paredes	131018	f
Recarei	Porto	Paredes	131019	f
Sobreira	Porto	Paredes	131020	f
Sobrosa	Porto	Paredes	131021	f
Vandoma	Porto	Paredes	131022	f
Vila Cova de Carros	Porto	Paredes	131023	f
Vilela	Porto	Paredes	131024	f
Abragão	Porto	Penafiel	131101	f
Boelhe	Porto	Penafiel	131102	f
Bustelo	Porto	Penafiel	131103	f
Cabeça Santa	Porto	Penafiel	131104	f
Canelas	Porto	Penafiel	131105	f
Capela	Porto	Penafiel	131106	f
Castelões	Porto	Penafiel	131107	f
Croca	Porto	Penafiel	131108	f
Duas Igrejas	Porto	Penafiel	131109	f
Eja	Porto	Penafiel	131110	f
Figueira	Porto	Penafiel	131111	f
Fonte Arcada	Porto	Penafiel	131112	f
Galegos	Porto	Penafiel	131113	f
Guilhufe	Porto	Penafiel	131114	f
Irivo	Porto	Penafiel	131115	f
Lagares	Porto	Penafiel	131116	f
Luzim	Porto	Penafiel	131117	f
Marecos	Porto	Penafiel	131118	f
Milhundos	Porto	Penafiel	131119	f
Novelas	Porto	Penafiel	131120	f
Oldrões	Porto	Penafiel	131121	f
Paço de Sousa	Porto	Penafiel	131122	f
Paredes	Porto	Penafiel	131123	f
Penafiel	Porto	Penafiel	131124	f
Perozelo	Porto	Penafiel	131125	f
Pinheiro	Porto	Penafiel	131126	f
Portela	Porto	Penafiel	131127	f
Rans	Porto	Penafiel	131128	f
Rio de Moinhos	Porto	Penafiel	131129	f
Santa Marta	Porto	Penafiel	131130	f
Santiago de Subarrifana	Porto	Penafiel	131131	f
Recezinhos (São Mamede)	Porto	Penafiel	131132	f
Recezinhos (São Martinho)	Porto	Penafiel	131133	f
Sebolido	Porto	Penafiel	131134	f
Urrô	Porto	Penafiel	131135	f
Valpedre	Porto	Penafiel	131136	f
Vila Cova	Porto	Penafiel	131137	f
Rio Mau	Porto	Penafiel	131138	f
Aldoar	Porto	Porto	131201	f
Bonfim	Porto	Porto	131202	f
Campanhã	Porto	Porto	131203	f
Cedofeita	Porto	Porto	131204	f
Foz do Douro	Porto	Porto	131205	f
Lordelo do Ouro	Porto	Porto	131206	f
Massarelos	Porto	Porto	131207	f
Miragaia	Porto	Porto	131208	f
Nevogilde	Porto	Porto	131209	f
Paranhos	Porto	Porto	131210	f
Ramalde	Porto	Porto	131211	f
Santo Ildefonso	Porto	Porto	131212	f
São Nicolau	Porto	Porto	131213	f
Sé	Porto	Porto	131214	f
Vitória	Porto	Porto	131215	f
A Ver-o-Mar	Porto	Póvoa de Varzim	131301	f
Aguçadoura	Porto	Póvoa de Varzim	131302	f
Amorim	Porto	Póvoa de Varzim	131303	f
Argivai	Porto	Póvoa de Varzim	131304	f
Balazar	Porto	Póvoa de Varzim	131305	f
Beiriz	Porto	Póvoa de Varzim	131306	f
Estela	Porto	Póvoa de Varzim	131307	f
Laundos	Porto	Póvoa de Varzim	131308	f
Navais	Porto	Póvoa de Varzim	131309	f
Póvoa de Varzim	Porto	Póvoa de Varzim	131310	f
Rates	Porto	Póvoa de Varzim	131311	f
Terroso	Porto	Póvoa de Varzim	131312	f
Agrela	Porto	Santo Tirso	131401	f
Água Longa	Porto	Santo Tirso	131402	f
Areias	Porto	Santo Tirso	131404	f
Aves	Porto	Santo Tirso	131405	f
Burgães	Porto	Santo Tirso	131406	f
Carreira	Porto	Santo Tirso	131407	f
Guimarei	Porto	Santo Tirso	131410	f
Lama	Porto	Santo Tirso	131411	f
Lamelas	Porto	Santo Tirso	131412	f
Monte Córdova	Porto	Santo Tirso	131413	f
Palmeira	Porto	Santo Tirso	131415	f
Rebordões	Porto	Santo Tirso	131416	f
Refojos de Riba de Ave	Porto	Santo Tirso	131417	f
Reguenga	Porto	Santo Tirso	131418	f
Roriz	Porto	Santo Tirso	131419	f
Couto (Santa Cristina)	Porto	Santo Tirso	131420	f
Santo Tirso	Porto	Santo Tirso	131422	f
Negrelos (São Mamede)	Porto	Santo Tirso	131424	f
Campo (São Martinho)	Porto	Santo Tirso	131426	f
Couto (São Miguel)	Porto	Santo Tirso	131427	f
São Salvador do Campo	Porto	Santo Tirso	131429	f
Negrelos (São Tomé)	Porto	Santo Tirso	131430	f
Sequeiró	Porto	Santo Tirso	131431	f
Vilarinho	Porto	Santo Tirso	131432	f
Alfena	Porto	Valongo	131501	f
Campo	Porto	Valongo	131502	f
Ermesinde	Porto	Valongo	131503	f
Sobrado	Porto	Valongo	131504	f
Valongo	Porto	Valongo	131505	f
Arcos	Porto	Vila do Conde	131601	f
Árvore	Porto	Vila do Conde	131602	f
Aveleda	Porto	Vila do Conde	131603	f
Azurara	Porto	Vila do Conde	131604	f
Bagunte	Porto	Vila do Conde	131605	f
Canidelo	Porto	Vila do Conde	131606	f
Fajozes	Porto	Vila do Conde	131607	f
Ferreiró	Porto	Vila do Conde	131608	f
Fornelo	Porto	Vila do Conde	131609	f
Gião	Porto	Vila do Conde	131610	f
Guilhabreu	Porto	Vila do Conde	131611	f
Junqueira	Porto	Vila do Conde	131612	f
Labruge	Porto	Vila do Conde	131613	f
Macieira da Maia	Porto	Vila do Conde	131614	f
Malta	Porto	Vila do Conde	131615	f
Mindelo	Porto	Vila do Conde	131616	f
Modivas	Porto	Vila do Conde	131617	f
Mosteiró	Porto	Vila do Conde	131618	f
Outeiro Maior	Porto	Vila do Conde	131619	f
Parada	Porto	Vila do Conde	131620	f
Retorta	Porto	Vila do Conde	131621	f
Rio Mau	Porto	Vila do Conde	131622	f
Tougues	Porto	Vila do Conde	131623	f
Touguinha	Porto	Vila do Conde	131624	f
Touguinhó	Porto	Vila do Conde	131625	f
Vairão	Porto	Vila do Conde	131626	f
Vila Chã	Porto	Vila do Conde	131627	f
Vila do Conde	Porto	Vila do Conde	131628	f
Vilar	Porto	Vila do Conde	131629	f
Vilar de Pinheiro	Porto	Vila do Conde	131630	f
Arcozelo	Porto	Vila Nova de Gaia	131701	f
Avintes	Porto	Vila Nova de Gaia	131702	f
Canelas	Porto	Vila Nova de Gaia	131703	f
Canidelo	Porto	Vila Nova de Gaia	131704	f
Crestuma	Porto	Vila Nova de Gaia	131705	f
Grijó	Porto	Vila Nova de Gaia	131706	f
Gulpilhares	Porto	Vila Nova de Gaia	131707	f
Lever	Porto	Vila Nova de Gaia	131708	f
Madalena	Porto	Vila Nova de Gaia	131709	f
Mafamude	Porto	Vila Nova de Gaia	131710	f
Olival	Porto	Vila Nova de Gaia	131711	f
Oliveira do Douro	Porto	Vila Nova de Gaia	131712	f
Pedroso	Porto	Vila Nova de Gaia	131713	f
Perozinho	Porto	Vila Nova de Gaia	131714	f
Sandim	Porto	Vila Nova de Gaia	131715	f
Vila Nova de Gaia (Santa Marinha)	Porto	Vila Nova de Gaia	131716	f
São Félix da Marinha	Porto	Vila Nova de Gaia	131717	f
São Pedro da Afurada	Porto	Vila Nova de Gaia	131718	f
Seixezelo	Porto	Vila Nova de Gaia	131719	f
Sermonde	Porto	Vila Nova de Gaia	131720	f
Serzedo	Porto	Vila Nova de Gaia	131721	f
Valadares	Porto	Vila Nova de Gaia	131722	f
Vilar de Andorinho	Porto	Vila Nova de Gaia	131723	f
Vilar do Paraíso	Porto	Vila Nova de Gaia	131724	f
Alvarelhos	Porto	Trofa	131801	f
Bougado (Santiago)	Porto	Trofa	131802	f
Bougado (São Martinho)	Porto	Trofa	131803	f
Coronado (São Mamede)	Porto	Trofa	131804	f
Coronado (São Romão)	Porto	Trofa	131805	f
Covelas	Porto	Trofa	131806	f
Guidões	Porto	Trofa	131807	f
Muro	Porto	Trofa	131808	f
Aldeia do Mato	Santarém	Abrantes	140101	f
Alferrarede	Santarém	Abrantes	140102	f
Alvega	Santarém	Abrantes	140103	f
Bemposta	Santarém	Abrantes	140104	f
Martinchel	Santarém	Abrantes	140105	f
Mouriscas	Santarém	Abrantes	140106	f
Pego	Santarém	Abrantes	140107	f
Rio de Moinhos	Santarém	Abrantes	140108	f
Rossio ao Sul do Tejo	Santarém	Abrantes	140109	f
São Facundo	Santarém	Abrantes	140110	f
Abrantes (São João)	Santarém	Abrantes	140111	f
São Miguel do Rio Torto	Santarém	Abrantes	140112	f
Abrantes (São Vicente)	Santarém	Abrantes	140113	f
Souto	Santarém	Abrantes	140114	f
Tramagal	Santarém	Abrantes	140115	f
Vale das Mós	Santarém	Abrantes	140116	f
Concavada	Santarém	Abrantes	140117	f
Fontes	Santarém	Abrantes	140118	f
Carvalhal	Santarém	Abrantes	140119	f
Alcanena	Santarém	Alcanena	140201	f
Bugalhos	Santarém	Alcanena	140202	f
Espinheiro	Santarém	Alcanena	140203	f
Louriceira	Santarém	Alcanena	140204	f
Malhou	Santarém	Alcanena	140205	f
Minde	Santarém	Alcanena	140206	f
Moitas Venda	Santarém	Alcanena	140207	f
Monsanto	Santarém	Alcanena	140208	f
Serra de Santo António	Santarém	Alcanena	140209	f
Vila Moreira	Santarém	Alcanena	140210	f
Almeirim	Santarém	Almeirim	140301	f
Benfica do Ribatejo	Santarém	Almeirim	140302	f
Fazendas de Almeirim	Santarém	Almeirim	140303	f
Raposa	Santarém	Almeirim	140304	f
Alpiarça	Santarém	Alpiarça	140401	f
Benavente	Santarém	Benavente	140501	f
Samora Correia	Santarém	Benavente	140502	f
Santo Estêvão	Santarém	Benavente	140503	f
Barrosa	Santarém	Benavente	140504	f
Cartaxo	Santarém	Cartaxo	140601	f
Ereira	Santarém	Cartaxo	140602	f
Lapa	Santarém	Cartaxo	140603	f
Pontével	Santarém	Cartaxo	140604	f
Valada	Santarém	Cartaxo	140605	f
Vale da Pinta	Santarém	Cartaxo	140606	f
Vila Chã de Ourique	Santarém	Cartaxo	140607	f
Vale da Pedra	Santarém	Cartaxo	140608	f
Chamusca	Santarém	Chamusca	140701	f
Chouto	Santarém	Chamusca	140702	f
Pinheiro Grande	Santarém	Chamusca	140703	f
Ulme	Santarém	Chamusca	140704	f
Vale de Cavalos	Santarém	Chamusca	140705	f
Parreira	Santarém	Chamusca	140706	f
Carregueira	Santarém	Chamusca	140707	f
Constância	Santarém	Constância	140801	f
Montalvo	Santarém	Constância	140802	f
Santa Margarida da Coutada	Santarém	Constância	140803	f
Coruche	Santarém	Coruche	140901	f
Couço	Santarém	Coruche	140902	f
São José da Lamarosa	Santarém	Coruche	140903	f
Fajarda	Santarém	Coruche	140904	f
Branca	Santarém	Coruche	140905	f
Erra	Santarém	Coruche	140906	f
Biscainho	Santarém	Coruche	140907	f
Santana do Mato	Santarém	Coruche	140908	f
Entroncamento	Santarém	Entroncamento	141001	f
Águas Belas	Santarém	Ferreira do Zêzere	141101	f
Areias	Santarém	Ferreira do Zêzere	141102	f
Beco	Santarém	Ferreira do Zêzere	141103	f
Chãos	Santarém	Ferreira do Zêzere	141104	f
Dornes	Santarém	Ferreira do Zêzere	141105	f
Ferreira do Zêzere	Santarém	Ferreira do Zêzere	141106	f
Igreja Nova do Sobral	Santarém	Ferreira do Zêzere	141107	f
Paio Mendes	Santarém	Ferreira do Zêzere	141108	f
Pias	Santarém	Ferreira do Zêzere	141109	f
Azinhaga	Santarém	Golegã	141201	f
Golegã	Santarém	Golegã	141202	f
Aboboreira	Santarém	Mação	141301	f
Amêndoa	Santarém	Mação	141302	f
Cardigos	Santarém	Mação	141303	f
Carvoeiro	Santarém	Mação	141304	f
Envendos	Santarém	Mação	141305	f
Mação	Santarém	Mação	141306	f
Ortiga	Santarém	Mação	141307	f
Penhascoso	Santarém	Mação	141308	f
Alcobertas	Santarém	Rio Maior	141401	f
Arrouquelas	Santarém	Rio Maior	141402	f
Arruda dos Pisões	Santarém	Rio Maior	141403	f
Azambujeira	Santarém	Rio Maior	141404	f
Fráguas	Santarém	Rio Maior	141405	f
Marmeleira	Santarém	Rio Maior	141406	f
Outeiro da Cortiçada	Santarém	Rio Maior	141407	f
Rio Maior	Santarém	Rio Maior	141408	f
São João da Ribeira	Santarém	Rio Maior	141409	f
Asseiceira	Santarém	Rio Maior	141410	f
São Sebastião	Santarém	Rio Maior	141411	f
Ribeira de São João	Santarém	Rio Maior	141412	f
Malaqueijo	Santarém	Rio Maior	141413	f
Assentiz	Santarém	Rio Maior	141414	f
Glória do Ribatejo	Santarém	Salvaterra de Magos	141501	f
Marinhais	Santarém	Salvaterra de Magos	141502	f
Muge	Santarém	Salvaterra de Magos	141503	f
Salvaterra de Magos	Santarém	Salvaterra de Magos	141504	f
Foros de Salvaterra	Santarém	Salvaterra de Magos	141505	f
Granho	Santarém	Salvaterra de Magos	141506	f
Abitureiras	Santarém	Santarém	141601	f
Abrã	Santarém	Santarém	141602	f
Achete	Santarém	Santarém	141603	f
Alcanede	Santarém	Santarém	141604	f
Alcanhões	Santarém	Santarém	141605	f
Almoster	Santarém	Santarém	141606	f
Amiais de Baixo	Santarém	Santarém	141607	f
Arneiro das Milhariças	Santarém	Santarém	141608	f
Azoia de Baixo	Santarém	Santarém	141609	f
Azoia de Cima	Santarém	Santarém	141610	f
Casével	Santarém	Santarém	141611	f
Santarém (Marvila)	Santarém	Santarém	141612	f
Moçarria	Santarém	Santarém	141613	f
Pernes	Santarém	Santarém	141614	f
Pombalinho	Santarém	Santarém	141615	f
Póvoa da Isenta	Santarém	Santarém	141616	f
Póvoa de Santarém	Santarém	Santarém	141617	f
Romeira	Santarém	Santarém	141618	f
Santa Iria da Ribeira de Santarém	Santarém	Santarém	141619	f
Santarém (São Nicolau)	Santarém	Santarém	141620	f
Santarém (São Salvador)	Santarém	Santarém	141621	f
São Vicente do Paul	Santarém	Santarém	141622	f
Tremês	Santarém	Santarém	141623	f
Vale de Figueira	Santarém	Santarém	141624	f
Vale de Santarém	Santarém	Santarém	141625	f
Vaqueiros	Santarém	Santarém	141626	f
Várzea	Santarém	Santarém	141627	f
Gançaria	Santarém	Santarém	141628	f
Alcaravela	Santarém	Sardoal	141701	f
Santiago de Montalegre	Santarém	Sardoal	141702	f
Sardoal	Santarém	Sardoal	141703	f
Valhascos	Santarém	Sardoal	141704	f
Alviobeira	Santarém	Tomar	141801	f
Asseiceira	Santarém	Tomar	141802	f
Beselga	Santarém	Tomar	141803	f
Carregueiros	Santarém	Tomar	141804	f
Casais	Santarém	Tomar	141805	f
Junceira	Santarém	Tomar	141806	f
Madalena	Santarém	Tomar	141807	f
Olalhas	Santarém	Tomar	141808	f
Paialvo	Santarém	Tomar	141809	f
Pedreira	Santarém	Tomar	141810	f
Santa Maria dos Olivais	Santarém	Tomar	141811	f
Tomar (São João Baptista)	Santarém	Tomar	141812	f
São Pedro de Tomar	Santarém	Tomar	141813	f
Sabacheira	Santarém	Tomar	141814	f
Serra	Santarém	Tomar	141815	f
Além da Ribeira	Santarém	Tomar	141816	f
Alcorochel	Santarém	Torres Novas	141901	f
Assentiz	Santarém	Torres Novas	141902	f
Brogueira	Santarém	Torres Novas	141903	f
Chancelaria	Santarém	Torres Novas	141904	f
Lapas	Santarém	Torres Novas	141905	f
Olaia	Santarém	Torres Novas	141906	f
Paço	Santarém	Torres Novas	141907	f
Parceiros de Igreja	Santarém	Torres Novas	141908	f
Pedrógão	Santarém	Torres Novas	141909	f
Riachos	Santarém	Torres Novas	141910	f
Ribeira Branca	Santarém	Torres Novas	141911	f
Torres Novas (Salvador)	Santarém	Torres Novas	141912	f
Torres Novas (Santa Maria)	Santarém	Torres Novas	141913	f
Torres Novas (Santiago)	Santarém	Torres Novas	141914	f
Torres Novas (São Pedro)	Santarém	Torres Novas	141915	f
Zibreira	Santarém	Torres Novas	141916	f
Meia Via	Santarém	Torres Novas	141917	f
Atalaia	Santarém	Vila Nova da Barquinha	142001	f
Praia do Ribatejo	Santarém	Vila Nova da Barquinha	142002	f
Tancos	Santarém	Vila Nova da Barquinha	142003	f
Vila Nova da Barquinha	Santarém	Vila Nova da Barquinha	142004	f
Moita do Norte	Santarém	Vila Nova da Barquinha	142005	f
Alburitel	Santarém	Ourém	142101	f
Atouguia	Santarém	Ourém	142102	f
Casal dos Bernardos	Santarém	Ourém	142103	f
Caxarias	Santarém	Ourém	142104	f
Espite	Santarém	Ourém	142105	f
Fátima	Santarém	Ourém	142106	f
Formigais	Santarém	Ourém	142107	f
Freixianda	Santarém	Ourém	142108	f
Gondemaria	Santarém	Ourém	142109	f
Olival	Santarém	Ourém	142110	f
Nossa Senhora das Misericórdias	Santarém	Ourém	142111	f
Rio de Couros	Santarém	Ourém	142112	f
Seiça	Santarém	Ourém	142113	f
Urqueira	Santarém	Ourém	142114	f
Nossa Senhora da Piedade	Santarém	Ourém	142115	f
Matas	Santarém	Ourém	142116	f
Cercal	Santarém	Ourém	142117	f
Ribeira do Fárrio	Santarém	Ourém	142118	f
Alcácer do Sal (Santa Maria do Castelo)	Setúbal	Alcácer do Sal	150101	f
Santa Susana	Setúbal	Alcácer do Sal	150102	f
Alcácer do Sal (Santiago)	Setúbal	Alcácer do Sal	150103	f
Torrão	Setúbal	Alcácer do Sal	150104	f
São Martinho	Setúbal	Alcácer do Sal	150105	f
Comporta	Setúbal	Alcácer do Sal	150106	f
Alcochete	Setúbal	Alcochete	150201	f
Samouco	Setúbal	Alcochete	150202	f
São Francisco	Setúbal	Alcochete	150203	f
Almada	Setúbal	Almada	150301	f
Caparica	Setúbal	Almada	150302	f
Costa da Caparica	Setúbal	Almada	150303	f
Cova da Piedade	Setúbal	Almada	150304	f
Trafaria	Setúbal	Almada	150305	f
Cacilhas	Setúbal	Almada	150306	f
Pragal	Setúbal	Almada	150307	f
Sobreda	Setúbal	Almada	150308	f
Charneca de Caparica	Setúbal	Almada	150309	f
Laranjeiro	Setúbal	Almada	150310	f
Feijó	Setúbal	Almada	150311	f
Barreiro	Setúbal	Barreiro	150401	f
Lavradio	Setúbal	Barreiro	150402	f
Palhais	Setúbal	Barreiro	150403	f
Santo André	Setúbal	Barreiro	150404	f
Verderena	Setúbal	Barreiro	150405	f
Alto do Seixalinho	Setúbal	Barreiro	150406	f
Santo António da Charneca	Setúbal	Barreiro	150407	f
Coina	Setúbal	Barreiro	150408	f
Azinheira Barros e São Mamede do Sádão	Setúbal	Grândola	150501	f
Grândola	Setúbal	Grândola	150502	f
Melides	Setúbal	Grândola	150503	f
Santa Margarida da Serra	Setúbal	Grândola	150504	f
Carvalhal	Setúbal	Grândola	150505	f
Alhos Vedros	Setúbal	Moita	150601	f
Baixa da Banheira	Setúbal	Moita	150602	f
Moita	Setúbal	Moita	150603	f
Gaio-Rosário	Setúbal	Moita	150604	f
Sarilhos Pequenos	Setúbal	Moita	150605	f
Vale da Amoreira	Setúbal	Moita	150606	f
Canha	Setúbal	Montijo	150701	f
Montijo	Setúbal	Montijo	150702	f
Santo Isidro de Pegões	Setúbal	Montijo	150703	f
Sarilhos Grandes	Setúbal	Montijo	150704	f
Alto-Estanqueiro-Jardia	Setúbal	Montijo	150705	f
Pegões	Setúbal	Montijo	150706	f
Atalaia	Setúbal	Montijo	150707	f
Afonsoeiro	Setúbal	Montijo	150708	f
Marateca	Setúbal	Palmela	150801	f
Palmela	Setúbal	Palmela	150802	f
Pinhal Novo	Setúbal	Palmela	150803	f
Quinta do Anjo	Setúbal	Palmela	150804	f
Poceirão	Setúbal	Palmela	150805	f
Abela	Setúbal	Santiago do Cacém	150901	f
Alvalade	Setúbal	Santiago do Cacém	150902	f
Cercal	Setúbal	Santiago do Cacém	150903	f
Ermidas-Sado	Setúbal	Santiago do Cacém	150904	f
Santa Cruz	Setúbal	Santiago do Cacém	150905	f
Santiago do Cacém	Setúbal	Santiago do Cacém	150906	f
Santo André	Setúbal	Santiago do Cacém	150907	f
São Bartolomeu da Serra	Setúbal	Santiago do Cacém	150908	f
São Domingos	Setúbal	Santiago do Cacém	150909	f
São Francisco da Serra	Setúbal	Santiago do Cacém	150910	f
Vale de Água	Setúbal	Santiago do Cacém	150911	f
Aldeia de Paio Pires	Setúbal	Seixal	151001	f
Amora	Setúbal	Seixal	151002	f
Arrentela	Setúbal	Seixal	151003	f
Seixal	Setúbal	Seixal	151004	f
Corroios	Setúbal	Seixal	151005	f
Fernão Ferro	Setúbal	Seixal	151006	f
Sesimbra (Castelo)	Setúbal	Sesimbra	151101	f
Sesimbra (Santiago)	Setúbal	Sesimbra	151102	f
Quinta do Conde	Setúbal	Sesimbra	151103	f
Setúbal (Nossa Senhora da Anunciada)	Setúbal	Setúbal	151201	f
Setúbal (Santa Maria da Graça)	Setúbal	Setúbal	151202	f
Setúbal (São Julião)	Setúbal	Setúbal	151203	f
São Lourenço	Setúbal	Setúbal	151204	f
Setúbal (São Sebastião)	Setúbal	Setúbal	151205	f
São Simão	Setúbal	Setúbal	151206	f
Gâmbia-Pontes-Alto da Guerra	Setúbal	Setúbal	151207	f
Sado	Setúbal	Setúbal	151208	f
Sines	Setúbal	Sines	151301	f
Porto Covo	Setúbal	Sines	151302	f
Aboim das Choças	Viana do Castelo	Arcos de Valdevez	160101	f
Aguiã	Viana do Castelo	Arcos de Valdevez	160102	f
Alvora	Viana do Castelo	Arcos de Valdevez	160103	f
Vila Chã	Vila Real	Alijó	170116	f
Ázere	Viana do Castelo	Arcos de Valdevez	160104	f
Cabana Maior	Viana do Castelo	Arcos de Valdevez	160105	f
Cabreiro	Viana do Castelo	Arcos de Valdevez	160106	f
Carralcova	Viana do Castelo	Arcos de Valdevez	160107	f
Cendufe	Viana do Castelo	Arcos de Valdevez	160108	f
Couto	Viana do Castelo	Arcos de Valdevez	160109	f
Eiras	Viana do Castelo	Arcos de Valdevez	160110	f
Ermelo	Viana do Castelo	Arcos de Valdevez	160111	f
Extremo	Viana do Castelo	Arcos de Valdevez	160112	f
Gavieira	Viana do Castelo	Arcos de Valdevez	160113	f
Giela	Viana do Castelo	Arcos de Valdevez	160114	f
Gondoriz	Viana do Castelo	Arcos de Valdevez	160115	f
Grade	Viana do Castelo	Arcos de Valdevez	160116	f
Guilhadeses	Viana do Castelo	Arcos de Valdevez	160117	f
Loureda	Viana do Castelo	Arcos de Valdevez	160118	f
Jolda (Madalena)	Viana do Castelo	Arcos de Valdevez	160119	f
Mei	Viana do Castelo	Arcos de Valdevez	160120	f
Miranda	Viana do Castelo	Arcos de Valdevez	160121	f
Monte Redondo	Viana do Castelo	Arcos de Valdevez	160122	f
Oliveira	Viana do Castelo	Arcos de Valdevez	160123	f
Paçô	Viana do Castelo	Arcos de Valdevez	160124	f
Padroso	Viana do Castelo	Arcos de Valdevez	160125	f
Parada	Viana do Castelo	Arcos de Valdevez	160126	f
Portela	Viana do Castelo	Arcos de Valdevez	160127	f
Prozelo	Viana do Castelo	Arcos de Valdevez	160128	f
Rio Cabrão	Viana do Castelo	Arcos de Valdevez	160129	f
Rio Frio	Viana do Castelo	Arcos de Valdevez	160130	f
Rio de Moinhos	Viana do Castelo	Arcos de Valdevez	160131	f
Sá	Viana do Castelo	Arcos de Valdevez	160132	f
Sabadim	Viana do Castelo	Arcos de Valdevez	160133	f
Arcos de Valdevez (Salvador)	Viana do Castelo	Arcos de Valdevez	160134	f
Padreiro (Salvador)	Viana do Castelo	Arcos de Valdevez	160135	f
Padreiro (Santa Cristina)	Viana do Castelo	Arcos de Valdevez	160136	f
Távora (Santa Maria)	Viana do Castelo	Arcos de Valdevez	160137	f
Santar	Viana do Castelo	Arcos de Valdevez	160138	f
São Cosme e São Damião	Viana do Castelo	Arcos de Valdevez	160139	f
São Jorge	Viana do Castelo	Arcos de Valdevez	160140	f
Arcos de Valdevez (São Paio)	Viana do Castelo	Arcos de Valdevez	160141	f
Jolda (São Paio)	Viana do Castelo	Arcos de Valdevez	160142	f
Távora (São Vicente)	Viana do Castelo	Arcos de Valdevez	160143	f
Senharei	Viana do Castelo	Arcos de Valdevez	160144	f
Sistelo	Viana do Castelo	Arcos de Valdevez	160145	f
Soajo	Viana do Castelo	Arcos de Valdevez	160146	f
Souto	Viana do Castelo	Arcos de Valdevez	160147	f
Tabaçô	Viana do Castelo	Arcos de Valdevez	160148	f
Vale	Viana do Castelo	Arcos de Valdevez	160149	f
Vila Fonche	Viana do Castelo	Arcos de Valdevez	160150	f
Vilela	Viana do Castelo	Arcos de Valdevez	160151	f
Âncora	Viana do Castelo	Caminha	160201	f
Arga de Baixo	Viana do Castelo	Caminha	160202	f
Arga de Cima	Viana do Castelo	Caminha	160203	f
Arga de São João	Viana do Castelo	Caminha	160204	f
Argela	Viana do Castelo	Caminha	160205	f
Azevedo	Viana do Castelo	Caminha	160206	f
Caminha (Matriz)	Viana do Castelo	Caminha	160207	f
Cristelo	Viana do Castelo	Caminha	160208	f
Dem	Viana do Castelo	Caminha	160209	f
Gondar	Viana do Castelo	Caminha	160210	f
Lanhelas	Viana do Castelo	Caminha	160211	f
Moledo	Viana do Castelo	Caminha	160212	f
Orbacém	Viana do Castelo	Caminha	160213	f
Riba de Âncora	Viana do Castelo	Caminha	160214	f
Seixas	Viana do Castelo	Caminha	160215	f
Venade	Viana do Castelo	Caminha	160216	f
Vila Praia de Âncora	Viana do Castelo	Caminha	160217	f
Vilar de Mouros	Viana do Castelo	Caminha	160218	f
Vilarelho	Viana do Castelo	Caminha	160219	f
Vile	Viana do Castelo	Caminha	160220	f
Alvaredo	Viana do Castelo	Melgaço	160301	f
Castro Laboreiro	Viana do Castelo	Melgaço	160302	f
Chaviães	Viana do Castelo	Melgaço	160303	f
Cousso	Viana do Castelo	Melgaço	160304	f
Cristoval	Viana do Castelo	Melgaço	160305	f
Cubalhão	Viana do Castelo	Melgaço	160306	f
Fiães	Viana do Castelo	Melgaço	160307	f
Gave	Viana do Castelo	Melgaço	160308	f
Lamas de Mouro	Viana do Castelo	Melgaço	160309	f
Paços	Viana do Castelo	Melgaço	160310	f
Paderne	Viana do Castelo	Melgaço	160311	f
Parada do Monte	Viana do Castelo	Melgaço	160312	f
Penso	Viana do Castelo	Melgaço	160313	f
Prado	Viana do Castelo	Melgaço	160314	f
Remoães	Viana do Castelo	Melgaço	160315	f
Roussas	Viana do Castelo	Melgaço	160316	f
São Paio	Viana do Castelo	Melgaço	160317	f
Vila	Viana do Castelo	Melgaço	160318	f
Abedim	Viana do Castelo	Monção	160401	f
Anhões	Viana do Castelo	Monção	160402	f
Badim	Viana do Castelo	Monção	160403	f
Barbeita	Viana do Castelo	Monção	160404	f
Barroças e Taias	Viana do Castelo	Monção	160405	f
Bela	Viana do Castelo	Monção	160406	f
Cambeses	Viana do Castelo	Monção	160407	f
Ceivães	Viana do Castelo	Monção	160408	f
Lapela	Viana do Castelo	Monção	160409	f
Lara	Viana do Castelo	Monção	160410	f
Longos Vales	Viana do Castelo	Monção	160411	f
Lordelo	Viana do Castelo	Monção	160412	f
Luzio	Viana do Castelo	Monção	160413	f
Mazedo	Viana do Castelo	Monção	160414	f
Merufe	Viana do Castelo	Monção	160415	f
Messegães	Viana do Castelo	Monção	160416	f
Monção	Viana do Castelo	Monção	160417	f
Moreira	Viana do Castelo	Monção	160418	f
Parada	Viana do Castelo	Monção	160419	f
Pias	Viana do Castelo	Monção	160420	f
Pinheiros	Viana do Castelo	Monção	160421	f
Podame	Viana do Castelo	Monção	160422	f
Portela	Viana do Castelo	Monção	160423	f
Riba de Mouro	Viana do Castelo	Monção	160424	f
Sá	Viana do Castelo	Monção	160425	f
Sago	Viana do Castelo	Monção	160426	f
Segude	Viana do Castelo	Monção	160427	f
Tangil	Viana do Castelo	Monção	160428	f
Troporiz	Viana do Castelo	Monção	160429	f
Troviscoso	Viana do Castelo	Monção	160430	f
Trute	Viana do Castelo	Monção	160431	f
Valadares	Viana do Castelo	Monção	160432	f
Cortes	Viana do Castelo	Monção	160433	f
Agualonga	Viana do Castelo	Paredes de Coura	160501	f
Bico	Viana do Castelo	Paredes de Coura	160502	f
Castanheira	Viana do Castelo	Paredes de Coura	160503	f
Cossourado	Viana do Castelo	Paredes de Coura	160504	f
Coura	Viana do Castelo	Paredes de Coura	160505	f
Cristelo	Viana do Castelo	Paredes de Coura	160506	f
Cunha	Viana do Castelo	Paredes de Coura	160507	f
Ferreira	Viana do Castelo	Paredes de Coura	160508	f
Formariz	Viana do Castelo	Paredes de Coura	160509	f
Infesta	Viana do Castelo	Paredes de Coura	160510	f
Insalde	Viana do Castelo	Paredes de Coura	160511	f
Linhares	Viana do Castelo	Paredes de Coura	160512	f
Mozelos	Viana do Castelo	Paredes de Coura	160513	f
Padornelo	Viana do Castelo	Paredes de Coura	160514	f
Parada	Viana do Castelo	Paredes de Coura	160515	f
Paredes de Coura	Viana do Castelo	Paredes de Coura	160516	f
Porreiras	Viana do Castelo	Paredes de Coura	160517	f
Resende	Viana do Castelo	Paredes de Coura	160518	f
Romarigães	Viana do Castelo	Paredes de Coura	160519	f
Rubiães	Viana do Castelo	Paredes de Coura	160520	f
Vascões	Viana do Castelo	Paredes de Coura	160521	f
Azias	Viana do Castelo	Ponte da Barca	160601	f
Boivães	Viana do Castelo	Ponte da Barca	160602	f
Bravães	Viana do Castelo	Ponte da Barca	160603	f
Britelo	Viana do Castelo	Ponte da Barca	160604	f
Crasto	Viana do Castelo	Ponte da Barca	160605	f
Cuide de Vila Verde	Viana do Castelo	Ponte da Barca	160606	f
Entre Ambos-os-Rios	Viana do Castelo	Ponte da Barca	160607	f
Ermida	Viana do Castelo	Ponte da Barca	160608	f
Germil	Viana do Castelo	Ponte da Barca	160609	f
Grovelas	Viana do Castelo	Ponte da Barca	160610	f
Lavradas	Viana do Castelo	Ponte da Barca	160611	f
Lindoso	Viana do Castelo	Ponte da Barca	160612	f
Nogueira	Viana do Castelo	Ponte da Barca	160613	f
Oleiros	Viana do Castelo	Ponte da Barca	160614	f
Paço Vedro de Magalhães	Viana do Castelo	Ponte da Barca	160615	f
Ponte da Barca	Viana do Castelo	Ponte da Barca	160616	f
Ruivos	Viana do Castelo	Ponte da Barca	160617	f
Touvedo (Salvador)	Viana do Castelo	Ponte da Barca	160618	f
Sampriz	Viana do Castelo	Ponte da Barca	160619	f
Vila Chã (Santiago)	Viana do Castelo	Ponte da Barca	160620	f
Vila Chã (São João Baptista)	Viana do Castelo	Ponte da Barca	160621	f
Touvedo (São Lourenço)	Viana do Castelo	Ponte da Barca	160622	f
Vade (São Pedro)	Viana do Castelo	Ponte da Barca	160623	f
Vade (São Tomé)	Viana do Castelo	Ponte da Barca	160624	f
Vila Nova de Muía	Viana do Castelo	Ponte da Barca	160625	f
Anais	Viana do Castelo	Ponte de Lima	160701	f
Arca	Viana do Castelo	Ponte de Lima	160702	f
Arcos	Viana do Castelo	Ponte de Lima	160703	f
Arcozelo	Viana do Castelo	Ponte de Lima	160704	f
Ardegão	Viana do Castelo	Ponte de Lima	160705	f
Bárrio	Viana do Castelo	Ponte de Lima	160706	f
Beiral do Lima	Viana do Castelo	Ponte de Lima	160707	f
Bertiandos	Viana do Castelo	Ponte de Lima	160708	f
Boalhosa	Viana do Castelo	Ponte de Lima	160709	f
Brandara	Viana do Castelo	Ponte de Lima	160710	f
Cabaços	Viana do Castelo	Ponte de Lima	160711	f
Cabração	Viana do Castelo	Ponte de Lima	160712	f
Calheiros	Viana do Castelo	Ponte de Lima	160713	f
Calvelo	Viana do Castelo	Ponte de Lima	160714	f
Cepões	Viana do Castelo	Ponte de Lima	160715	f
Correlhã	Viana do Castelo	Ponte de Lima	160716	f
Estorãos	Viana do Castelo	Ponte de Lima	160717	f
Facha	Viana do Castelo	Ponte de Lima	160718	f
Feitosa	Viana do Castelo	Ponte de Lima	160719	f
Fojo Lobal	Viana do Castelo	Ponte de Lima	160720	f
Fontão	Viana do Castelo	Ponte de Lima	160721	f
Fornelos	Viana do Castelo	Ponte de Lima	160722	f
Freixo	Viana do Castelo	Ponte de Lima	160723	f
Friastelas	Viana do Castelo	Ponte de Lima	160724	f
Gaifar	Viana do Castelo	Ponte de Lima	160725	f
Gandra	Viana do Castelo	Ponte de Lima	160726	f
Gemieira	Viana do Castelo	Ponte de Lima	160727	f
Gondufe	Viana do Castelo	Ponte de Lima	160728	f
Labruja	Viana do Castelo	Ponte de Lima	160729	f
Labrujó	Viana do Castelo	Ponte de Lima	160730	f
Mato	Viana do Castelo	Ponte de Lima	160731	f
Moreira do Lima	Viana do Castelo	Ponte de Lima	160732	f
Navió	Viana do Castelo	Ponte de Lima	160733	f
Poiares	Viana do Castelo	Ponte de Lima	160734	f
Ponte de Lima	Viana do Castelo	Ponte de Lima	160735	f
Queijada	Viana do Castelo	Ponte de Lima	160736	f
Refóios do Lima	Viana do Castelo	Ponte de Lima	160737	f
Rendufe	Viana do Castelo	Ponte de Lima	160738	f
Ribeira	Viana do Castelo	Ponte de Lima	160739	f
Sá	Viana do Castelo	Ponte de Lima	160740	f
Sandiães	Viana do Castelo	Ponte de Lima	160741	f
Santa Comba	Viana do Castelo	Ponte de Lima	160742	f
Santa Cruz do Lima	Viana do Castelo	Ponte de Lima	160743	f
Rebordões (Santa Maria)	Viana do Castelo	Ponte de Lima	160744	f
Seara	Viana do Castelo	Ponte de Lima	160745	f
Serdedelo	Viana do Castelo	Ponte de Lima	160746	f
Rebordões (Souto)	Viana do Castelo	Ponte de Lima	160747	f
Vilar das Almas	Viana do Castelo	Ponte de Lima	160748	f
Vilar do Monte	Viana do Castelo	Ponte de Lima	160749	f
Vitorino das Donas	Viana do Castelo	Ponte de Lima	160750	f
Vitorino dos Piães	Viana do Castelo	Ponte de Lima	160751	f
Arão	Viana do Castelo	Valença	160801	f
Boivão	Viana do Castelo	Valença	160802	f
Cerdal	Viana do Castelo	Valença	160803	f
Cristelo Covo	Viana do Castelo	Valença	160804	f
Fontoura	Viana do Castelo	Valença	160805	f
Friestas	Viana do Castelo	Valença	160806	f
Gandra	Viana do Castelo	Valença	160807	f
Ganfei	Viana do Castelo	Valença	160808	f
Gondomil	Viana do Castelo	Valença	160809	f
Sanfins	Viana do Castelo	Valença	160810	f
São Julião	Viana do Castelo	Valença	160811	f
São Pedro da Torre	Viana do Castelo	Valença	160812	f
Silva	Viana do Castelo	Valença	160813	f
Taião	Viana do Castelo	Valença	160814	f
Valença	Viana do Castelo	Valença	160815	f
Verdoejo	Viana do Castelo	Valença	160816	f
Afife	Viana do Castelo	Viana do Castelo	160901	f
Alvarães	Viana do Castelo	Viana do Castelo	160902	f
Amonde	Viana do Castelo	Viana do Castelo	160903	f
Anha	Viana do Castelo	Viana do Castelo	160904	f
Areosa	Viana do Castelo	Viana do Castelo	160905	f
Barroselas	Viana do Castelo	Viana do Castelo	160906	f
Cardielos	Viana do Castelo	Viana do Castelo	160907	f
Carreço	Viana do Castelo	Viana do Castelo	160908	f
Carvoeiro	Viana do Castelo	Viana do Castelo	160909	f
Castelo do Neiva	Viana do Castelo	Viana do Castelo	160910	f
Darque	Viana do Castelo	Viana do Castelo	160911	f
Deão	Viana do Castelo	Viana do Castelo	160912	f
Deocriste	Viana do Castelo	Viana do Castelo	160913	f
Freixieiro de Soutelo	Viana do Castelo	Viana do Castelo	160914	f
Lanheses	Viana do Castelo	Viana do Castelo	160915	f
Mazarefes	Viana do Castelo	Viana do Castelo	160916	f
Meadela	Viana do Castelo	Viana do Castelo	160917	f
Meixedo	Viana do Castelo	Viana do Castelo	160918	f
Viana do Castelo (Monserrate)	Viana do Castelo	Viana do Castelo	160919	f
Montaria	Viana do Castelo	Viana do Castelo	160920	f
Moreira de Geraz do Lima	Viana do Castelo	Viana do Castelo	160921	f
Mujães	Viana do Castelo	Viana do Castelo	160922	f
Neiva	Viana do Castelo	Viana do Castelo	160923	f
Nogueira	Viana do Castelo	Viana do Castelo	160924	f
Outeiro	Viana do Castelo	Viana do Castelo	160925	f
Perre	Viana do Castelo	Viana do Castelo	160926	f
Portela Susã	Viana do Castelo	Viana do Castelo	160927	f
Portuzelo	Viana do Castelo	Viana do Castelo	160928	f
Geraz do Lima (Santa Leocádia)	Viana do Castelo	Viana do Castelo	160929	f
Geraz do Lima (Santa Maria)	Viana do Castelo	Viana do Castelo	160930	f
Viana do Castelo (Santa Maria Maior)	Viana do Castelo	Viana do Castelo	160931	f
Serreleis	Viana do Castelo	Viana do Castelo	160932	f
Subportela	Viana do Castelo	Viana do Castelo	160933	f
Torre	Viana do Castelo	Viana do Castelo	160934	f
Vila Franca	Viana do Castelo	Viana do Castelo	160935	f
Vila Fria	Viana do Castelo	Viana do Castelo	160936	f
Vila Mou	Viana do Castelo	Viana do Castelo	160937	f
Vila de Punhe	Viana do Castelo	Viana do Castelo	160938	f
Vilar de Murteda	Viana do Castelo	Viana do Castelo	160939	f
Chafé	Viana do Castelo	Viana do Castelo	160940	f
Campos	Viana do Castelo	Vila Nova de Cerveira	161001	f
Candemil	Viana do Castelo	Vila Nova de Cerveira	161002	f
Cornes	Viana do Castelo	Vila Nova de Cerveira	161003	f
Covas	Viana do Castelo	Vila Nova de Cerveira	161004	f
Gondar	Viana do Castelo	Vila Nova de Cerveira	161005	f
Gondarém	Viana do Castelo	Vila Nova de Cerveira	161006	f
Loivo	Viana do Castelo	Vila Nova de Cerveira	161007	f
Lovelhe	Viana do Castelo	Vila Nova de Cerveira	161008	f
Mentrestido	Viana do Castelo	Vila Nova de Cerveira	161009	f
Nogueira	Viana do Castelo	Vila Nova de Cerveira	161010	f
Reboreda	Viana do Castelo	Vila Nova de Cerveira	161011	f
Sapardos	Viana do Castelo	Vila Nova de Cerveira	161012	f
Sopo	Viana do Castelo	Vila Nova de Cerveira	161013	f
Vila Meã	Viana do Castelo	Vila Nova de Cerveira	161014	f
Vila Nova de Cerveira	Viana do Castelo	Vila Nova de Cerveira	161015	f
Alijó	Vila Real	Alijó	170101	f
Amieiro	Vila Real	Alijó	170102	f
Carlão	Vila Real	Alijó	170103	f
Casal de Loivos	Vila Real	Alijó	170104	f
Castedo	Vila Real	Alijó	170105	f
Cotas	Vila Real	Alijó	170106	f
Favaios	Vila Real	Alijó	170107	f
Pegarinhos	Vila Real	Alijó	170108	f
Pinhão	Vila Real	Alijó	170109	f
Pópulo	Vila Real	Alijó	170110	f
Ribalonga	Vila Real	Alijó	170111	f
Sanfins do Douro	Vila Real	Alijó	170112	f
Santa Eugénia	Vila Real	Alijó	170113	f
São Mamede de Ribatua	Vila Real	Alijó	170114	f
Vale de Mendiz	Vila Real	Alijó	170115	f
Vila Verde	Vila Real	Alijó	170117	f
Vilar de Maçada	Vila Real	Alijó	170118	f
Vilarinho de Cotas	Vila Real	Alijó	170119	f
Alturas do Barroso	Vila Real	Boticas	170201	f
Ardãos	Vila Real	Boticas	170202	f
Beça	Vila Real	Boticas	170203	f
Bobadela	Vila Real	Boticas	170204	f
Boticas	Vila Real	Boticas	170205	f
Cerdedo	Vila Real	Boticas	170206	f
Codessoso	Vila Real	Boticas	170207	f
Covas do Barroso	Vila Real	Boticas	170208	f
Curros	Vila Real	Boticas	170209	f
Dornelas	Vila Real	Boticas	170210	f
Fiães do Tâmega	Vila Real	Boticas	170211	f
Granja	Vila Real	Boticas	170212	f
Pinho	Vila Real	Boticas	170213	f
São Salvador de Viveiro	Vila Real	Boticas	170214	f
Sapiãos	Vila Real	Boticas	170215	f
Vilar	Vila Real	Boticas	170216	f
Águas Frias	Vila Real	Chaves	170301	f
Anelhe	Vila Real	Chaves	170302	f
Arcossó	Vila Real	Chaves	170303	f
Bobadela	Vila Real	Chaves	170304	f
Bustelo	Vila Real	Chaves	170305	f
Calvão	Vila Real	Chaves	170306	f
Cela	Vila Real	Chaves	170307	f
Cimo de Vila da Castanheira	Vila Real	Chaves	170309	f
Curalha	Vila Real	Chaves	170310	f
Eiras	Vila Real	Chaves	170311	f
Ervededo	Vila Real	Chaves	170312	f
Faiões	Vila Real	Chaves	170313	f
Lama de Arcos	Vila Real	Chaves	170314	f
Loivos	Vila Real	Chaves	170315	f
Mairos	Vila Real	Chaves	170316	f
Moreiras	Vila Real	Chaves	170317	f
Nogueira da Montanha	Vila Real	Chaves	170318	f
Oucidres	Vila Real	Chaves	170319	f
Oura	Vila Real	Chaves	170320	f
Outeiro Seco	Vila Real	Chaves	170321	f
Paradela	Vila Real	Chaves	170322	f
Póvoa de Agrações	Vila Real	Chaves	170323	f
Redondelo	Vila Real	Chaves	170324	f
Roriz	Vila Real	Chaves	170325	f
Samaiões	Vila Real	Chaves	170326	f
Sanfins	Vila Real	Chaves	170327	f
Sanjurge	Vila Real	Chaves	170328	f
Santa Leocádia	Vila Real	Chaves	170329	f
Santo António de Monforte	Vila Real	Chaves	170330	f
Santo Estêvão	Vila Real	Chaves	170331	f
São Julião de Montenegro	Vila Real	Chaves	170332	f
São Pedro de Agostém	Vila Real	Chaves	170333	f
São Vicente	Vila Real	Chaves	170334	f
Seara Velha	Vila Real	Chaves	170335	f
Selhariz	Vila Real	Chaves	170336	f
Soutelinho da Raia	Vila Real	Chaves	170337	f
Soutelo	Vila Real	Chaves	170338	f
Travancas	Vila Real	Chaves	170339	f
Tronco	Vila Real	Chaves	170340	f
Vale de Anta	Vila Real	Chaves	170341	f
Vidago	Vila Real	Chaves	170342	f
Vila Verde da Raia	Vila Real	Chaves	170343	f
Vilar de Nantes	Vila Real	Chaves	170344	f
Vilarelho da Raia	Vila Real	Chaves	170345	f
Vilarinho das Paranheiras	Vila Real	Chaves	170346	f
Vilas Boas	Vila Real	Chaves	170347	f
Vilela Seca	Vila Real	Chaves	170348	f
Vilela do Tâmega	Vila Real	Chaves	170349	f
Santa Maria Maior	Vila Real	Chaves	170350	f
Madalena	Vila Real	Chaves	170351	f
Santa Cruz/Trindade	Vila Real	Chaves	170352	f
Barqueiros	Vila Real	Mesão Frio	170401	f
Cidadelhe	Vila Real	Mesão Frio	170402	f
Oliveira	Vila Real	Mesão Frio	170403	f
Mesão Frio (Santa Cristina)	Vila Real	Mesão Frio	170404	f
Mesão Frio (São Nicolau)	Vila Real	Mesão Frio	170405	f
Vila Jusã	Vila Real	Mesão Frio	170406	f
Vila Marim	Vila Real	Mesão Frio	170407	f
Atei	Vila Real	Mondim de Basto	170501	f
Bilhó	Vila Real	Mondim de Basto	170502	f
Campanhó	Vila Real	Mondim de Basto	170503	f
Ermelo	Vila Real	Mondim de Basto	170504	f
Mondim de Basto	Vila Real	Mondim de Basto	170505	f
Paradança	Vila Real	Mondim de Basto	170506	f
Pardelhas	Vila Real	Mondim de Basto	170507	f
Vilar de Ferreiros	Vila Real	Mondim de Basto	170508	f
Cabril	Vila Real	Montalegre	170601	f
Cambeses do Rio	Vila Real	Montalegre	170602	f
Cervos	Vila Real	Montalegre	170603	f
Chã	Vila Real	Montalegre	170604	f
Contim	Vila Real	Montalegre	170605	f
Covelães	Vila Real	Montalegre	170606	f
Covelo do Gerês	Vila Real	Montalegre	170607	f
Donões	Vila Real	Montalegre	170608	f
Ferral	Vila Real	Montalegre	170609	f
Fervidelas	Vila Real	Montalegre	170610	f
Fiães do Rio	Vila Real	Montalegre	170611	f
Gralhas	Vila Real	Montalegre	170612	f
Meixedo	Vila Real	Montalegre	170613	f
Meixide	Vila Real	Montalegre	170614	f
Montalegre	Vila Real	Montalegre	170615	f
Morgade	Vila Real	Montalegre	170616	f
Mourilhe	Vila Real	Montalegre	170617	f
Negrões	Vila Real	Montalegre	170618	f
Outeiro	Vila Real	Montalegre	170619	f
Padornelos	Vila Real	Montalegre	170620	f
Padroso	Vila Real	Montalegre	170621	f
Paradela	Vila Real	Montalegre	170622	f
Pitões das Junias	Vila Real	Montalegre	170623	f
Pondras	Vila Real	Montalegre	170624	f
Reigoso	Vila Real	Montalegre	170625	f
Salto	Vila Real	Montalegre	170626	f
Santo André	Vila Real	Montalegre	170627	f
Vilar de Perdizes (São Miguel)	Vila Real	Montalegre	170628	f
Sarraquinhos	Vila Real	Montalegre	170629	f
Sezelhe	Vila Real	Montalegre	170630	f
Solveira	Vila Real	Montalegre	170631	f
Tourém	Vila Real	Montalegre	170632	f
Venda Nova	Vila Real	Montalegre	170633	f
Viade de Baixo	Vila Real	Montalegre	170634	f
Vila da Ponte	Vila Real	Montalegre	170635	f
Candedo	Vila Real	Murça	170701	f
Carva	Vila Real	Murça	170702	f
Fiolhoso	Vila Real	Murça	170703	f
Jou	Vila Real	Murça	170704	f
Murça	Vila Real	Murça	170705	f
Noura	Vila Real	Murça	170706	f
Palheiros	Vila Real	Murça	170707	f
Valongo de Milhais	Vila Real	Murça	170708	f
Vilares	Vila Real	Murça	170709	f
Covelinhas	Vila Real	Peso da Régua	170801	f
Fontelas	Vila Real	Peso da Régua	170802	f
Galafura	Vila Real	Peso da Régua	170803	f
Godim	Vila Real	Peso da Régua	170804	f
Loureiro	Vila Real	Peso da Régua	170805	f
Moura Morta	Vila Real	Peso da Régua	170806	f
Peso da Régua	Vila Real	Peso da Régua	170807	f
Poiares	Vila Real	Peso da Régua	170808	f
Sedielos	Vila Real	Peso da Régua	170809	f
Vilarinho dos Freires	Vila Real	Peso da Régua	170810	f
Vinhós	Vila Real	Peso da Régua	170811	f
Canelas	Vila Real	Peso da Régua	170812	f
Alvadia	Vila Real	Ribeira de Pena	170901	f
Canedo	Vila Real	Ribeira de Pena	170902	f
Cerva	Vila Real	Ribeira de Pena	170903	f
Limões	Vila Real	Ribeira de Pena	170904	f
Ribeira de Pena (Salvador)	Vila Real	Ribeira de Pena	170905	f
Santa Marinha	Vila Real	Ribeira de Pena	170906	f
Santo Aleixo de Além-Tâmega	Vila Real	Ribeira de Pena	170907	f
Celeirós	Vila Real	Sabrosa	171001	f
Covas do Douro	Vila Real	Sabrosa	171002	f
Gouvães do Douro	Vila Real	Sabrosa	171003	f
Gouvinhas	Vila Real	Sabrosa	171004	f
Parada de Pinhão	Vila Real	Sabrosa	171005	f
Paradela de Guiães	Vila Real	Sabrosa	171006	f
Paços	Vila Real	Sabrosa	171007	f
Provesende	Vila Real	Sabrosa	171008	f
Sabrosa	Vila Real	Sabrosa	171009	f
São Cristovão do Douro	Vila Real	Sabrosa	171010	f
São Lourenço de Ribapinhão	Vila Real	Sabrosa	171011	f
São Martinho de Antas	Vila Real	Sabrosa	171012	f
Souto Maior	Vila Real	Sabrosa	171013	f
Torre do Pinhão	Vila Real	Sabrosa	171014	f
Vilarinho de São Romão	Vila Real	Sabrosa	171015	f
Alvações do Corgo	Vila Real	Santa Marta de Penaguião	171101	f
Cumeeira	Vila Real	Santa Marta de Penaguião	171102	f
Fontes	Vila Real	Santa Marta de Penaguião	171103	f
Fornelos	Vila Real	Santa Marta de Penaguião	171104	f
Louredo	Vila Real	Santa Marta de Penaguião	171105	f
Medrões	Vila Real	Santa Marta de Penaguião	171106	f
Sanhoane	Vila Real	Santa Marta de Penaguião	171107	f
Lobrigos (São João Baptista)	Vila Real	Santa Marta de Penaguião	171108	f
Lobrigos (São Miguel)	Vila Real	Santa Marta de Penaguião	171109	f
Sever	Vila Real	Santa Marta de Penaguião	171110	f
Água Revés e Crasto	Vila Real	Valpaços	171201	f
Alvarelhos	Vila Real	Valpaços	171202	f
Algeriz	Vila Real	Valpaços	171203	f
Barreiros	Vila Real	Valpaços	171204	f
Bouçoães	Vila Real	Valpaços	171205	f
Canaveses	Vila Real	Valpaços	171206	f
Carrezedo de Montenegro	Vila Real	Valpaços	171207	f
Curros	Vila Real	Valpaços	171208	f
Ervões	Vila Real	Valpaços	171209	f
Fiães	Vila Real	Valpaços	171210	f
Fornos do Pinhal	Vila Real	Valpaços	171211	f
Friões	Vila Real	Valpaços	171212	f
Lebução	Vila Real	Valpaços	171213	f
Nozelos	Vila Real	Valpaços	171214	f
Padrela e Tazem	Vila Real	Valpaços	171215	f
Possacos	Vila Real	Valpaços	171216	f
Rio Torto	Vila Real	Valpaços	171217	f
Sanfins	Vila Real	Valpaços	171218	f
Santa Maria de Emeres	Vila Real	Valpaços	171219	f
Santa Valha	Vila Real	Valpaços	171220	f
Santiago da Ribeira de Alhariz	Vila Real	Valpaços	171221	f
São João da Corveira	Vila Real	Valpaços	171222	f
São Pedro de Veiga de Lila	Vila Real	Valpaços	171223	f
Serapicos	Vila Real	Valpaços	171224	f
Sonim	Vila Real	Valpaços	171225	f
Tinhela	Vila Real	Valpaços	171226	f
Vales	Vila Real	Valpaços	171227	f
Valpaços	Vila Real	Valpaços	171228	f
Vassal	Vila Real	Valpaços	171229	f
Veiga de Lila	Vila Real	Valpaços	171230	f
Vilarandelo	Vila Real	Valpaços	171231	f
Afonsim	Vila Real	Vila Pouca de Aguiar	171301	f
Alfarela de Jales	Vila Real	Vila Pouca de Aguiar	171302	f
Bornes de Aguiar	Vila Real	Vila Pouca de Aguiar	171303	f
Bragado	Vila Real	Vila Pouca de Aguiar	171304	f
Capeludos	Vila Real	Vila Pouca de Aguiar	171305	f
Gouvães da Serra	Vila Real	Vila Pouca de Aguiar	171306	f
Parada de Monteiros	Vila Real	Vila Pouca de Aguiar	171307	f
Pensalvos	Vila Real	Vila Pouca de Aguiar	171308	f
Santa Marta da Montanha	Vila Real	Vila Pouca de Aguiar	171309	f
Soutelo de Aguiar	Vila Real	Vila Pouca de Aguiar	171310	f
Telões	Vila Real	Vila Pouca de Aguiar	171311	f
Tresminas	Vila Real	Vila Pouca de Aguiar	171312	f
Valoura	Vila Real	Vila Pouca de Aguiar	171313	f
Vila Pouca de Aguiar	Vila Real	Vila Pouca de Aguiar	171314	f
Vreia de Bornes	Vila Real	Vila Pouca de Aguiar	171315	f
Vreia de Jales	Vila Real	Vila Pouca de Aguiar	171316	f
Sabroso de Aguiar	Vila Real	Vila Pouca de Aguiar	171317	f
Abaças	Vila Real	Vila Real	171401	f
Adoufe	Vila Real	Vila Real	171402	f
Andrães	Vila Real	Vila Real	171403	f
Arroios	Vila Real	Vila Real	171404	f
Borbela	Vila Real	Vila Real	171405	f
Campeã	Vila Real	Vila Real	171406	f
Constantim	Vila Real	Vila Real	171407	f
Ermida	Vila Real	Vila Real	171408	f
Folhadela	Vila Real	Vila Real	171409	f
Guiães	Vila Real	Vila Real	171410	f
Justes	Vila Real	Vila Real	171411	f
Lamares	Vila Real	Vila Real	171412	f
Lamas de Olo	Vila Real	Vila Real	171413	f
Lordelo	Vila Real	Vila Real	171414	f
Mateus	Vila Real	Vila Real	171415	f
Mondrões	Vila Real	Vila Real	171416	f
Mouçós	Vila Real	Vila Real	171417	f
Nogueira	Vila Real	Vila Real	171418	f
Vila Real (Nossa Senhora da Conceição)	Vila Real	Vila Real	171419	f
Parada de Cunhos	Vila Real	Vila Real	171420	f
Pena	Vila Real	Vila Real	171421	f
Quinta	Vila Real	Vila Real	171422	f
Vila Real (São Dinis)	Vila Real	Vila Real	171423	f
Vila Real (São Pedro)	Vila Real	Vila Real	171424	f
São Tomé do Castelo	Vila Real	Vila Real	171425	f
Torgueda	Vila Real	Vila Real	171426	f
Vale de Nogueiras	Vila Real	Vila Real	171427	f
Vila Cova	Vila Real	Vila Real	171428	f
Vila Marim	Vila Real	Vila Real	171429	f
Vilarinho de Samardã	Vila Real	Vila Real	171430	f
Aldeias	Viseu	Armamar	180101	f
Aricera	Viseu	Armamar	180102	f
Armamar	Viseu	Armamar	180103	f
Cimbres	Viseu	Armamar	180104	f
Coura	Viseu	Armamar	180105	f
Folgosa	Viseu	Armamar	180106	f
Fontelo	Viseu	Armamar	180107	f
Goujoim	Viseu	Armamar	180108	f
Queimada	Viseu	Armamar	180109	f
Queimadela	Viseu	Armamar	180110	f
Santa Cruz	Viseu	Armamar	180111	f
Santiago	Viseu	Armamar	180112	f
Santo Adrião	Viseu	Armamar	180113	f
São Cosmado	Viseu	Armamar	180114	f
São Martinho das Chãs	Viseu	Armamar	180115	f
São Romão	Viseu	Armamar	180116	f
Tões	Viseu	Armamar	180117	f
Vacalar	Viseu	Armamar	180118	f
Vila Seca	Viseu	Armamar	180119	f
Beijós	Viseu	Carregal do Sal	180201	f
Cabanas de Viriato	Viseu	Carregal do Sal	180202	f
Currelos	Viseu	Carregal do Sal	180203	f
Oliveira do Conde	Viseu	Carregal do Sal	180204	f
Papízios	Viseu	Carregal do Sal	180205	f
Parada	Viseu	Carregal do Sal	180206	f
Sobral	Viseu	Carregal do Sal	180207	f
Almofala	Viseu	Castro Daire	180301	f
Alva	Viseu	Castro Daire	180302	f
Cabril	Viseu	Castro Daire	180303	f
Castro Daire	Viseu	Castro Daire	180304	f
Cujó	Viseu	Castro Daire	180305	f
Ermida	Viseu	Castro Daire	180306	f
Ester	Viseu	Castro Daire	180307	f
Gafanhão	Viseu	Castro Daire	180308	f
Gosende	Viseu	Castro Daire	180309	f
Mamouros	Viseu	Castro Daire	180310	f
Mezio	Viseu	Castro Daire	180311	f
Mões	Viseu	Castro Daire	180312	f
Moledo	Viseu	Castro Daire	180313	f
Monteiras	Viseu	Castro Daire	180314	f
Moura Morta	Viseu	Castro Daire	180315	f
Parada de Ester	Viseu	Castro Daire	180316	f
Pepim	Viseu	Castro Daire	180317	f
Picão	Viseu	Castro Daire	180318	f
Pinheiro	Viseu	Castro Daire	180319	f
Reriz	Viseu	Castro Daire	180320	f
Ribolhos	Viseu	Castro Daire	180321	f
São Joaninho	Viseu	Castro Daire	180322	f
Alhões	Viseu	Cinfães	180401	f
Bustelo	Viseu	Cinfães	180402	f
Cinfães	Viseu	Cinfães	180403	f
Espadanedo	Viseu	Cinfães	180404	f
Ferreiros de Tendais	Viseu	Cinfães	180405	f
Fornelos	Viseu	Cinfães	180406	f
Gralheira	Viseu	Cinfães	180407	f
Moimenta	Viseu	Cinfães	180408	f
Nespereira	Viseu	Cinfães	180409	f
Oliveira do Douro	Viseu	Cinfães	180410	f
Ramires	Viseu	Cinfães	180411	f
Santiago de Piães	Viseu	Cinfães	180412	f
São Cristóvão de Nogueira	Viseu	Cinfães	180413	f
Souselo	Viseu	Cinfães	180414	f
Tarouquela	Viseu	Cinfães	180415	f
Tendais	Viseu	Cinfães	180416	f
Travanca	Viseu	Cinfães	180417	f
Lamego (Almacave)	Viseu	Lamego	180501	f
Avões	Viseu	Lamego	180502	f
Bigorne	Viseu	Lamego	180503	f
Britiande	Viseu	Lamego	180504	f
Cambres	Viseu	Lamego	180505	f
Cepões	Viseu	Lamego	180506	f
Ferreirim	Viseu	Lamego	180507	f
Ferreiros de Avões	Viseu	Lamego	180508	f
Figueira	Viseu	Lamego	180509	f
Lalim	Viseu	Lamego	180510	f
Lazarim	Viseu	Lamego	180511	f
Magueija	Viseu	Lamego	180512	f
Meijinhos	Viseu	Lamego	180513	f
Melcões	Viseu	Lamego	180514	f
Parada do Bispo	Viseu	Lamego	180515	f
Penajóia	Viseu	Lamego	180516	f
Penude	Viseu	Lamego	180517	f
Pretarouca	Viseu	Lamego	180518	f
Samodães	Viseu	Lamego	180519	f
Sande	Viseu	Lamego	180520	f
Lamego (Sé)	Viseu	Lamego	180521	f
Valdigem	Viseu	Lamego	180522	f
Várzea de Abrunhais	Viseu	Lamego	180523	f
Vila Nova de Souto dEl-Rei	Viseu	Lamego	180524	f
Abrunhosa-a-Velha	Viseu	Mangualde	180601	f
Alcafache	Viseu	Mangualde	180602	f
Chãs de Tavares	Viseu	Mangualde	180603	f
Cunha Alta	Viseu	Mangualde	180604	f
Cunha Baixa	Viseu	Mangualde	180605	f
Espinho	Viseu	Mangualde	180606	f
Fornos de Maceira Dão	Viseu	Mangualde	180607	f
Freixiosa	Viseu	Mangualde	180608	f
Lobelhe do Mato	Viseu	Mangualde	180609	f
Mangualde	Viseu	Mangualde	180610	f
Mesquitela	Viseu	Mangualde	180611	f
Moimenta de Maceira Dão	Viseu	Mangualde	180612	f
Póvoa de Cervães	Viseu	Mangualde	180613	f
Quintela de Azurara	Viseu	Mangualde	180614	f
Santiago de Cassurrães	Viseu	Mangualde	180615	f
São João da Fresta	Viseu	Mangualde	180616	f
Travanca de Tavares	Viseu	Mangualde	180617	f
Várzea de Tavares	Viseu	Mangualde	180618	f
Aldeia de Nacomba	Viseu	Moimenta da Beira	180701	f
Alvite	Viseu	Moimenta da Beira	180702	f
Arcozelos	Viseu	Moimenta da Beira	180703	f
Ariz	Viseu	Moimenta da Beira	180704	f
Baldos	Viseu	Moimenta da Beira	180705	f
Cabaços	Viseu	Moimenta da Beira	180706	f
Caria	Viseu	Moimenta da Beira	180707	f
Castelo	Viseu	Moimenta da Beira	180708	f
Leomil	Viseu	Moimenta da Beira	180709	f
Moimenta da Beira	Viseu	Moimenta da Beira	180710	f
Nagosa	Viseu	Moimenta da Beira	180711	f
Paradinha	Viseu	Moimenta da Beira	180712	f
Passô	Viseu	Moimenta da Beira	180713	f
Pêra Velha	Viseu	Moimenta da Beira	180714	f
Peva	Viseu	Moimenta da Beira	180715	f
Rua	Viseu	Moimenta da Beira	180716	f
Sarzedo	Viseu	Moimenta da Beira	180717	f
Segões	Viseu	Moimenta da Beira	180718	f
Sever	Viseu	Moimenta da Beira	180719	f
Vilar	Viseu	Moimenta da Beira	180720	f
Almaça	Viseu	Mortágua	180801	f
Cercosa	Viseu	Mortágua	180802	f
Cortegaça	Viseu	Mortágua	180803	f
Espinho	Viseu	Mortágua	180804	f
Marmeleira	Viseu	Mortágua	180805	f
Mortágua	Viseu	Mortágua	180806	f
Pala	Viseu	Mortágua	180807	f
Sobral	Viseu	Mortágua	180808	f
Trezói	Viseu	Mortágua	180809	f
Vale de Remígio	Viseu	Mortágua	180810	f
Canas de Senhorim	Viseu	Nelas	180901	f
Carvalhal Redondo	Viseu	Nelas	180902	f
Nelas	Viseu	Nelas	180903	f
Santar	Viseu	Nelas	180904	f
Senhorim	Viseu	Nelas	180905	f
Vilar Seco	Viseu	Nelas	180906	f
Aguieira	Viseu	Nelas	180907	f
Lapa do Lobo	Viseu	Nelas	180908	f
Moreira	Viseu	Nelas	180909	f
Arca	Viseu	Oliveira de Frades	181001	f
Arcozelo das Maias	Viseu	Oliveira de Frades	181002	f
Destriz	Viseu	Oliveira de Frades	181003	f
Oliveira de Frades	Viseu	Oliveira de Frades	181004	f
Pinheiro	Viseu	Oliveira de Frades	181005	f
Reigoso	Viseu	Oliveira de Frades	181006	f
Ribeiradio	Viseu	Oliveira de Frades	181007	f
São João da Serra	Viseu	Oliveira de Frades	181008	f
São Vicente de Lafões	Viseu	Oliveira de Frades	181009	f
Sejães	Viseu	Oliveira de Frades	181010	f
Souto de Lafões	Viseu	Oliveira de Frades	181011	f
Varzielas	Viseu	Oliveira de Frades	181012	f
Antas	Viseu	Penalva do Castelo	181101	f
Castelo de Penalva	Viseu	Penalva do Castelo	181102	f
Esmolfe	Viseu	Penalva do Castelo	181103	f
Germil	Viseu	Penalva do Castelo	181104	f
Ínsua	Viseu	Penalva do Castelo	181105	f
Lusinde	Viseu	Penalva do Castelo	181106	f
Mareco	Viseu	Penalva do Castelo	181107	f
Matela	Viseu	Penalva do Castelo	181108	f
Pindo	Viseu	Penalva do Castelo	181109	f
Real	Viseu	Penalva do Castelo	181110	f
Sezures	Viseu	Penalva do Castelo	181111	f
Trancozelos	Viseu	Penalva do Castelo	181112	f
Vila Cova do Covelo	Viseu	Penalva do Castelo	181113	f
Antas	Viseu	Penedono	181201	f
Beselga	Viseu	Penedono	181202	f
Castainço	Viseu	Penedono	181203	f
Granja	Viseu	Penedono	181204	f
Ourozinho	Viseu	Penedono	181205	f
Penedono	Viseu	Penedono	181206	f
Penela da Beira	Viseu	Penedono	181207	f
Póvoa de Penela	Viseu	Penedono	181208	f
Souto	Viseu	Penedono	181209	f
Anreade	Viseu	Resende	181301	f
Barrô	Viseu	Resende	181302	f
Cárquere	Viseu	Resende	181303	f
Feirão	Viseu	Resende	181304	f
Felgueiras	Viseu	Resende	181305	f
Freigil	Viseu	Resende	181306	f
Miomães	Viseu	Resende	181307	f
Ovadas	Viseu	Resende	181308	f
Panchorra	Viseu	Resende	181309	f
Paus	Viseu	Resende	181310	f
Resende	Viseu	Resende	181311	f
São Cipriano	Viseu	Resende	181312	f
São João de Fontoura	Viseu	Resende	181313	f
São Martinho de Mouros	Viseu	Resende	181314	f
São Romão de Aregos	Viseu	Resende	181315	f
Couto do Mosteiro	Viseu	Santa Comba Dão	181401	f
Ovoa	Viseu	Santa Comba Dão	181402	f
Pinheiro de Ázere	Viseu	Santa Comba Dão	181403	f
Santa Comba Dão	Viseu	Santa Comba Dão	181404	f
São Joaninho	Viseu	Santa Comba Dão	181405	f
São João de Areias	Viseu	Santa Comba Dão	181406	f
Treixedo	Viseu	Santa Comba Dão	181407	f
Vimieiro	Viseu	Santa Comba Dão	181408	f
Nagozela	Viseu	Santa Comba Dão	181409	f
Castanheiro do Sul	Viseu	São João da Pesqueira	181501	f
Ervedosa do Douro	Viseu	São João da Pesqueira	181502	f
Espinhosa	Viseu	São João da Pesqueira	181503	f
Nagozelo do Douro	Viseu	São João da Pesqueira	181504	f
Paredes da Beira	Viseu	São João da Pesqueira	181505	f
Pereiros	Viseu	São João da Pesqueira	181506	f
Riodades	Viseu	São João da Pesqueira	181507	f
São João da Pesqueira	Viseu	São João da Pesqueira	181508	f
Soutelo do Douro	Viseu	São João da Pesqueira	181509	f
Trevões	Viseu	São João da Pesqueira	181510	f
Vale de Figueira	Viseu	São João da Pesqueira	181511	f
Valongo dos Azeites	Viseu	São João da Pesqueira	181512	f
Várzea de Trevões	Viseu	São João da Pesqueira	181513	f
Vilarouco	Viseu	São João da Pesqueira	181514	f
Baiões	Viseu	São Pedro do Sul	181601	f
Bordonhos	Viseu	São Pedro do Sul	181602	f
Candal	Viseu	São Pedro do Sul	181603	f
Carvalhais	Viseu	São Pedro do Sul	181604	f
Covas do Rio	Viseu	São Pedro do Sul	181605	f
Figueiredo de Alva	Viseu	São Pedro do Sul	181606	f
Manhouce	Viseu	São Pedro do Sul	181607	f
Pindelo dos Milagres	Viseu	São Pedro do Sul	181608	f
Pinho	Viseu	São Pedro do Sul	181609	f
Santa Cruz da Trapa	Viseu	São Pedro do Sul	181610	f
São Cristóvão de Lafões	Viseu	São Pedro do Sul	181611	f
São Félix	Viseu	São Pedro do Sul	181612	f
São Martinho das Moitas	Viseu	São Pedro do Sul	181613	f
São Pedro do Sul	Viseu	São Pedro do Sul	181614	f
Serrazes	Viseu	São Pedro do Sul	181615	f
Sul	Viseu	São Pedro do Sul	181616	f
Valadares	Viseu	São Pedro do Sul	181617	f
Várzea	Viseu	São Pedro do Sul	181618	f
Vila Maior	Viseu	São Pedro do Sul	181619	f
Águas Boas	Viseu	Sátão	181701	f
Avelal	Viseu	Sátão	181702	f
Decermilo	Viseu	Sátão	181703	f
Ferreira de Aves	Viseu	Sátão	181704	f
Forles	Viseu	Sátão	181705	f
Mioma	Viseu	Sátão	181706	f
Rio de Moinhos	Viseu	Sátão	181707	f
Romãs	Viseu	Sátão	181708	f
São Miguel de Vila Boa	Viseu	Sátão	181709	f
Sátão	Viseu	Sátão	181710	f
Silvã de Cima	Viseu	Sátão	181711	f
Vila Longa	Viseu	Sátão	181712	f
Arnas	Viseu	Sernancelhe	181801	f
Carregal	Viseu	Sernancelhe	181802	f
Chosendo	Viseu	Sernancelhe	181803	f
Cunha	Viseu	Sernancelhe	181804	f
Escurquela	Viseu	Sernancelhe	181805	f
Faia	Viseu	Sernancelhe	181806	f
Ferreirim	Viseu	Sernancelhe	181807	f
Fonte Arcada	Viseu	Sernancelhe	181808	f
Freixinho	Viseu	Sernancelhe	181809	f
Granjal	Viseu	Sernancelhe	181810	f
Lamosa	Viseu	Sernancelhe	181811	f
Macieira	Viseu	Sernancelhe	181812	f
Penso	Viseu	Sernancelhe	181813	f
Quintela	Viseu	Sernancelhe	181814	f
Sarzeda	Viseu	Sernancelhe	181815	f
Sernancelhe	Viseu	Sernancelhe	181816	f
Vila da Ponte	Viseu	Sernancelhe	181817	f
Adorigo	Viseu	Tabuaço	181901	f
Arcos	Viseu	Tabuaço	181902	f
Barcos	Viseu	Tabuaço	181903	f
Chavães	Viseu	Tabuaço	181904	f
Desejosa	Viseu	Tabuaço	181905	f
Granja do Tedo	Viseu	Tabuaço	181906	f
Granjinha	Viseu	Tabuaço	181907	f
Longra	Viseu	Tabuaço	181908	f
Paradela	Viseu	Tabuaço	181909	f
Pereiro	Viseu	Tabuaço	181910	f
Pinheiros	Viseu	Tabuaço	181911	f
Santa Leocádia	Viseu	Tabuaço	181912	f
Sendim	Viseu	Tabuaço	181913	f
Tabuaço	Viseu	Tabuaço	181914	f
Távora	Viseu	Tabuaço	181915	f
Vale de Figueira	Viseu	Tabuaço	181916	f
Valença do Douro	Viseu	Tabuaço	181917	f
Dálvares	Viseu	Tarouca	182001	f
Gouviães	Viseu	Tarouca	182002	f
Granja Nova	Viseu	Tarouca	182003	f
Mondim da Beira	Viseu	Tarouca	182004	f
Salzedas	Viseu	Tarouca	182005	f
São João de Tarouca	Viseu	Tarouca	182006	f
Tarouca	Viseu	Tarouca	182007	f
Ucanha	Viseu	Tarouca	182008	f
Várzea da Serra	Viseu	Tarouca	182009	f
Vila Chã da Beira	Viseu	Tarouca	182010	f
Barreiro de Besteiros	Viseu	Tondela	182101	f
Campo de Besteiros	Viseu	Tondela	182102	f
Canas de Santa Maria	Viseu	Tondela	182103	f
Caparrosa	Viseu	Tondela	182104	f
Castelões	Viseu	Tondela	182105	f
Dardavaz	Viseu	Tondela	182106	f
Ferreirós do Dão	Viseu	Tondela	182107	f
Guardão	Viseu	Tondela	182108	f
Lajeosa	Viseu	Tondela	182109	f
Lobão da Beira	Viseu	Tondela	182110	f
Molelos	Viseu	Tondela	182111	f
Mosteirinho	Viseu	Tondela	182112	f
Mosteiro de Fráguas	Viseu	Tondela	182113	f
Mouraz	Viseu	Tondela	182114	f
Nandufe	Viseu	Tondela	182115	f
Parada de Gonta	Viseu	Tondela	182116	f
Sabugosa	Viseu	Tondela	182117	f
Santiago de Besteiros	Viseu	Tondela	182118	f
São João do Monte	Viseu	Tondela	182119	f
São Miguel do Outeiro	Viseu	Tondela	182120	f
Silvares	Viseu	Tondela	182121	f
Tonda	Viseu	Tondela	182122	f
Tondela	Viseu	Tondela	182123	f
Vila Nova da Rainha	Viseu	Tondela	182124	f
Vilar de Besteiros	Viseu	Tondela	182125	f
Tourigo	Viseu	Tondela	182126	f
Alhais	Viseu	Vila Nova de Paiva	182201	f
Fráguas	Viseu	Vila Nova de Paiva	182202	f
Pendilhe	Viseu	Vila Nova de Paiva	182203	f
Queiriga	Viseu	Vila Nova de Paiva	182204	f
Touro	Viseu	Vila Nova de Paiva	182205	f
Vila Cova à Coelheira	Viseu	Vila Nova de Paiva	182206	f
Vila Nova de Paiva	Viseu	Vila Nova de Paiva	182207	f
Abraveses	Viseu	Viseu	182301	f
Barreiros	Viseu	Viseu	182302	f
Boa Aldeia	Viseu	Viseu	182303	f
Bodiosa	Viseu	Viseu	182304	f
Calde	Viseu	Viseu	182305	f
Campo	Viseu	Viseu	182306	f
Cavernães	Viseu	Viseu	182307	f
Cepões	Viseu	Viseu	182308	f
Viseu (Coração de Jesus)	Viseu	Viseu	182309	f
Cota	Viseu	Viseu	182310	f
Couto de Baixo	Viseu	Viseu	182311	f
Couto de Cima	Viseu	Viseu	182312	f
Fail	Viseu	Viseu	182313	f
Farminhão	Viseu	Viseu	182314	f
Fragosela	Viseu	Viseu	182315	f
Lordosa	Viseu	Viseu	182316	f
Silgueiros	Viseu	Viseu	182317	f
Mundão	Viseu	Viseu	182318	f
Orgens	Viseu	Viseu	182319	f
Povolide	Viseu	Viseu	182320	f
Ranhados	Viseu	Viseu	182321	f
Ribafeita	Viseu	Viseu	182322	f
Rio de Loba	Viseu	Viseu	182323	f
Viseu (Santa Maria de Viseu)	Viseu	Viseu	182324	f
Santos Evos	Viseu	Viseu	182325	f
São Cipriano	Viseu	Viseu	182326	f
São João de Lourosa	Viseu	Viseu	182327	f
Viseu (São José)	Viseu	Viseu	182328	f
São Pedro de France	Viseu	Viseu	182329	f
São Salvador	Viseu	Viseu	182330	f
Torredeita	Viseu	Viseu	182331	f
Vil de Souto	Viseu	Viseu	182332	f
Vila Chã de Sá	Viseu	Viseu	182333	f
Repeses	Viseu	Viseu	182334	f
Alcofra	Viseu	Vouzela	182401	f
Cambra	Viseu	Vouzela	182402	f
Campia	Viseu	Vouzela	182403	f
Carvalhal de Vermilhas	Viseu	Vouzela	182404	f
Fataunços	Viseu	Vouzela	182405	f
Figueiredo das Donas	Viseu	Vouzela	182406	f
Fornelo do Monte	Viseu	Vouzela	182407	f
Paços de Vilharigues	Viseu	Vouzela	182408	f
Queirã	Viseu	Vouzela	182409	f
São Miguel do Mato	Viseu	Vouzela	182410	f
Ventosa	Viseu	Vouzela	182411	f
Vouzela	Viseu	Vouzela	182412	f
Arco da Calheta	Ilha da Madeira	Calheta (R.A.M.)	310101	f
Calheta (R.A.Madeira)	Ilha da Madeira	Calheta (R.A.M.)	310102	f
Estreito da Calheta	Ilha da Madeira	Calheta (R.A.M.)	310103	f
Fajã da Ovelha	Ilha da Madeira	Calheta (R.A.M.)	310104	f
Jardim do Mar	Ilha da Madeira	Calheta (R.A.M.)	310105	f
Paul do Mar	Ilha da Madeira	Calheta (R.A.M.)	310106	f
Ponta do Pargo	Ilha da Madeira	Calheta (R.A.M.)	310107	f
Prazeres	Ilha da Madeira	Calheta (R.A.M.)	310108	f
Câmara de Lobos	Ilha da Madeira	Câmara de Lobos	310201	f
Curral das Freiras	Ilha da Madeira	Câmara de Lobos	310202	f
Estreito de Câmara de Lobos	Ilha da Madeira	Câmara de Lobos	310203	f
Quinta Grande	Ilha da Madeira	Câmara de Lobos	310204	f
Jardim da Serra	Ilha da Madeira	Câmara de Lobos	310205	f
Imaculado Coração de Maria	Ilha da Madeira	Funchal	310301	f
Monte	Ilha da Madeira	Funchal	310302	f
Funchal (Santa Luzia)	Ilha da Madeira	Funchal	310303	f
Funchal (Santa Maria Maior)	Ilha da Madeira	Funchal	310304	f
Santo António	Ilha da Madeira	Funchal	310305	f
São Gonçalo	Ilha da Madeira	Funchal	310306	f
São Martinho	Ilha da Madeira	Funchal	310307	f
Funchal (São Pedro)	Ilha da Madeira	Funchal	310308	f
São Roque	Ilha da Madeira	Funchal	310309	f
Funchal (Sé)	Ilha da Madeira	Funchal	310310	f
Água de Pena	Ilha da Madeira	Machico	310401	f
Caniçal	Ilha da Madeira	Machico	310402	f
Machico	Ilha da Madeira	Machico	310403	f
Porto da Cruz	Ilha da Madeira	Machico	310404	f
Santo António da Serra	Ilha da Madeira	Machico	310405	f
Canhas	Ilha da Madeira	Ponta do Sol	310501	f
Madalena do Mar	Ilha da Madeira	Ponta do Sol	310502	f
Ponta do Sol	Ilha da Madeira	Ponta do Sol	310503	f
Achadas da Cruz	Ilha da Madeira	Porto Moniz	310601	f
Porto Moniz	Ilha da Madeira	Porto Moniz	310602	f
Ribeira da Janela	Ilha da Madeira	Porto Moniz	310603	f
Seixal	Ilha da Madeira	Porto Moniz	310604	f
Campanário	Ilha da Madeira	Ribeira Brava	310701	f
Ribeira Brava	Ilha da Madeira	Ribeira Brava	310702	f
Serra de Água	Ilha da Madeira	Ribeira Brava	310703	f
Tábua	Ilha da Madeira	Ribeira Brava	310704	f
Camacha	Ilha da Madeira	Santa Cruz	310802	f
Caniço	Ilha da Madeira	Santa Cruz	310803	f
Gaula	Ilha da Madeira	Santa Cruz	310804	f
Santa Cruz	Ilha da Madeira	Santa Cruz	310805	f
Santo António da Serra	Ilha da Madeira	Santa Cruz	310806	f
Arco de São Jorge	Ilha da Madeira	Santana	310901	f
Faial	Ilha da Madeira	Santana	310902	f
Santana	Ilha da Madeira	Santana	310903	f
São Jorge	Ilha da Madeira	Santana	310904	f
São Roque do Faial	Ilha da Madeira	Santana	310905	f
Ilha	Ilha da Madeira	Santana	310906	f
Boa Ventura	Ilha da Madeira	São Vicente	311001	f
Ponta Delgada	Ilha da Madeira	São Vicente	311002	f
São Vicente	Ilha da Madeira	São Vicente	311003	f
Porto Santo	Ilha de Porto Santo	Porto Santo	320101	f
Almagreira	Ilha de Santa Maria	Vila do Porto	410101	f
Santa Bárbara	Ilha de Santa Maria	Vila do Porto	410102	f
Santo Espírito	Ilha de Santa Maria	Vila do Porto	410103	f
São Pedro	Ilha de Santa Maria	Vila do Porto	410104	f
Vila do Porto	Ilha de Santa Maria	Vila do Porto	410105	f
Água de Pau	Ilha de São Miguel	Lagoa (R.A.A)	420101	f
Cabouco	Ilha de São Miguel	Lagoa (R.A.A)	420102	f
Lagoa (Nossa Senhora do Rosário)	Ilha de São Miguel	Lagoa (R.A.A)	420103	f
Lagoa (Santa Cruz)	Ilha de São Miguel	Lagoa (R.A.A)	420104	f
Ribeira Chã	Ilha de São Miguel	Lagoa (R.A.A)	420105	f
Achada	Ilha de São Miguel	Nordeste	420201	f
Achadinha	Ilha de São Miguel	Nordeste	420202	f
Lomba da Fazenda	Ilha de São Miguel	Nordeste	420203	f
Nordeste	Ilha de São Miguel	Nordeste	420204	f
Salga	Ilha de São Miguel	Nordeste	420206	f
Santana	Ilha de São Miguel	Nordeste	420207	f
Algarvia	Ilha de São Miguel	Nordeste	420208	f
Santo António de Nordestinho	Ilha de São Miguel	Nordeste	420209	f
São Pedro de Nordestinho	Ilha de São Miguel	Nordeste	420210	f
Arrifes	Ilha de São Miguel	Ponta Delgada	420301	f
Candelária	Ilha de São Miguel	Ponta Delgada	420303	f
Capelas	Ilha de São Miguel	Ponta Delgada	420304	f
Covoada	Ilha de São Miguel	Ponta Delgada	420305	f
Fajã de Baixo	Ilha de São Miguel	Ponta Delgada	420306	f
Fajã de Cima	Ilha de São Miguel	Ponta Delgada	420307	f
Fenais da Luz	Ilha de São Miguel	Ponta Delgada	420308	f
Feteiras	Ilha de São Miguel	Ponta Delgada	420309	f
Ginetes	Ilha de São Miguel	Ponta Delgada	420310	f
Mosteiros	Ilha de São Miguel	Ponta Delgada	420311	f
Ponta Delgada (Matriz)	Ilha de São Miguel	Ponta Delgada	420312	f
Ponta Delgada (São José)	Ilha de São Miguel	Ponta Delgada	420313	f
Ponta Delgada (São Pedro)	Ilha de São Miguel	Ponta Delgada	420314	f
Relva	Ilha de São Miguel	Ponta Delgada	420315	f
Remédios	Ilha de São Miguel	Ponta Delgada	420316	f
Rosto do Cão (Livramento)	Ilha de São Miguel	Ponta Delgada	420317	f
Rosto do Cão (São Roque)	Ilha de São Miguel	Ponta Delgada	420318	f
Santa Bárbara	Ilha de São Miguel	Ponta Delgada	420319	f
Santo António	Ilha de São Miguel	Ponta Delgada	420320	f
São Vicente Ferreira	Ilha de São Miguel	Ponta Delgada	420321	f
Sete Cidades	Ilha de São Miguel	Ponta Delgada	420322	f
Ajuda da Bretanha	Ilha de São Miguel	Ponta Delgada	420323	f
Pilar da Bretanha	Ilha de São Miguel	Ponta Delgada	420324	f
Santa Clara	Ilha de São Miguel	Ponta Delgada	420325	f
Água Retorta	Ilha de São Miguel	Povoação	420401	f
Faial da Terra	Ilha de São Miguel	Povoação	420402	f
Furnas	Ilha de São Miguel	Povoação	420403	f
Nossa Senhora dos Remédios	Ilha de São Miguel	Povoação	420404	f
Povoação	Ilha de São Miguel	Povoação	420405	f
Ribeira Quente	Ilha de São Miguel	Povoação	420406	f
Calhetas	Ilha de São Miguel	Ribeira Grande	420501	f
Fenais da Ajuda	Ilha de São Miguel	Ribeira Grande	420502	f
Lomba da Maia	Ilha de São Miguel	Ribeira Grande	420503	f
Lomba de São Pedro	Ilha de São Miguel	Ribeira Grande	420504	f
Maia	Ilha de São Miguel	Ribeira Grande	420505	f
Pico da Pedra	Ilha de São Miguel	Ribeira Grande	420506	f
Porto Formoso	Ilha de São Miguel	Ribeira Grande	420507	f
Rabo de Peixe	Ilha de São Miguel	Ribeira Grande	420508	f
Ribeira Grande (Conceição)	Ilha de São Miguel	Ribeira Grande	420509	f
Ribeira Grande (Matriz)	Ilha de São Miguel	Ribeira Grande	420510	f
Ribeira Seca	Ilha de São Miguel	Ribeira Grande	420511	f
Ribeirinha	Ilha de São Miguel	Ribeira Grande	420512	f
Santa Bárbara	Ilha de São Miguel	Ribeira Grande	420513	f
São Brás	Ilha de São Miguel	Ribeira Grande	420514	f
Água de Alto	Ilha de São Miguel	Vila Franca do Campo	420601	f
Ponta Garça	Ilha de São Miguel	Vila Franca do Campo	420602	f
Ribeira das Tainhas	Ilha de São Miguel	Vila Franca do Campo	420603	f
Vila Franca do Campo (São Miguel)	Ilha de São Miguel	Vila Franca do Campo	420604	f
Vila Franca do Campo (São Pedro)	Ilha de São Miguel	Vila Franca do Campo	420605	f
Ribeira Seca	Ilha de São Miguel	Vila Franca do Campo	420606	f
Altares	Ilha Terceira	Angra do Heroísmo	430101	f
Angra (Nossa Senhora da Conceição)	Ilha Terceira	Angra do Heroísmo	430102	f
Angra (Santa Luzia)	Ilha Terceira	Angra do Heroísmo	430103	f
Angra (São Pedro)	Ilha Terceira	Angra do Heroísmo	430104	f
Angra (Sé)	Ilha Terceira	Angra do Heroísmo	430105	f
Cinco Ribeiras	Ilha Terceira	Angra do Heroísmo	430106	f
Doze Ribeiras	Ilha Terceira	Angra do Heroísmo	430107	f
Feteira	Ilha Terceira	Angra do Heroísmo	430108	f
Porto Judeu	Ilha Terceira	Angra do Heroísmo	430109	f
Posto Santo	Ilha Terceira	Angra do Heroísmo	430110	f
Raminho	Ilha Terceira	Angra do Heroísmo	430111	f
Ribeirinha	Ilha Terceira	Angra do Heroísmo	430112	f
Santa Bárbara	Ilha Terceira	Angra do Heroísmo	430113	f
São Bartolomeu de Regatos	Ilha Terceira	Angra do Heroísmo	430114	f
São Bento	Ilha Terceira	Angra do Heroísmo	430115	f
São Mateus da Calheta	Ilha Terceira	Angra do Heroísmo	430116	f
Serreta	Ilha Terceira	Angra do Heroísmo	430117	f
Terra Chã	Ilha Terceira	Angra do Heroísmo	430118	f
Vila de São Sebastião	Ilha Terceira	Angra do Heroísmo	430119	f
Agualva	Ilha Terceira	Vila da Praia da Vitória	430201	f
Biscoitos	Ilha Terceira	Vila da Praia da Vitória	430202	f
Cabo da Praia	Ilha Terceira	Vila da Praia da Vitória	430203	f
Fonte do Bastardo	Ilha Terceira	Vila da Praia da Vitória	430204	f
Fontinhas	Ilha Terceira	Vila da Praia da Vitória	430205	f
Lajes	Ilha Terceira	Vila da Praia da Vitória	430206	f
Praia da Vitória (Santa Cruz)	Ilha Terceira	Vila da Praia da Vitória	430207	f
Quatro Ribeiras	Ilha Terceira	Vila da Praia da Vitória	430208	f
São Brás	Ilha Terceira	Vila da Praia da Vitória	430209	f
Vila Nova	Ilha Terceira	Vila da Praia da Vitória	430210	f
Porto Martins	Ilha Terceira	Vila da Praia da Vitória	430211	f
Guadalupe (R.A.Açores)	Ilha da Graciosa	Santa Cruz da Graciosa	440101	f
Luz (R.A.Açores)	Ilha da Graciosa	Santa Cruz da Graciosa	440102	f
Praia (São Mateus) (R.A.Açores)	Ilha da Graciosa	Santa Cruz da Graciosa	440103	f
Santa Cruz da Graciosa (R.A.Açores)	Ilha da Graciosa	Santa Cruz da Graciosa	440104	f
Calheta (R.A.Açores)	Ilha de São Jorge	Calheta (R.A.A.)	450101	f
Norte Pequeno (R.A.Açores)	Ilha de São Jorge	Calheta (R.A.A.)	450102	f
Ribeira Seca (R.A.Açores)	Ilha de São Jorge	Calheta (R.A.A.)	450103	f
Santo Antão (R.A.Açores)	Ilha de São Jorge	Calheta (R.A.A.)	450104	f
Topo(Nossa Senhora do Rosário)(R.A.Açor	Ilha de São Jorge	Calheta (R.A.A.)	450105	f
Manadas (Santa Bárbara)(R.A.Açores)	Ilha de São Jorge	Velas	450201	f
Norte Grande (Neves) (R.A.Açores)	Ilha de São Jorge	Velas	450202	f
Rosais (R.A.Açores)	Ilha de São Jorge	Velas	450203	f
Santo Amaro (R.A.Açores)	Ilha de São Jorge	Velas	450204	f
Urzelina (São Mateus) (R.A.Açores)	Ilha de São Jorge	Velas	450205	f
Velas (São Jorge) (R.A.Açores)	Ilha de São Jorge	Velas	450206	f
Calheta de Nesquim	Ilha do Pico	Lajes do Pico	460101	f
Lajes do Pico	Ilha do Pico	Lajes do Pico	460102	f
Piedade	Ilha do Pico	Lajes do Pico	460103	f
Ribeiras	Ilha do Pico	Lajes do Pico	460104	f
Ribeirinha	Ilha do Pico	Lajes do Pico	460105	f
São João	Ilha do Pico	Lajes do Pico	460106	f
Bandeiras	Ilha do Pico	Madalena	460201	f
Candelária	Ilha do Pico	Madalena	460202	f
Criação Velha	Ilha do Pico	Madalena	460203	f
Madalena	Ilha do Pico	Madalena	460204	f
São Caetano	Ilha do Pico	Madalena	460205	f
São Mateus	Ilha do Pico	Madalena	460206	f
Prainha	Ilha do Pico	São Roque do Pico	460301	f
Santa Luzia	Ilha do Pico	São Roque do Pico	460302	f
Santo Amaro	Ilha do Pico	São Roque do Pico	460303	f
Santo António	Ilha do Pico	São Roque do Pico	460304	f
São Roque do Pico	Ilha do Pico	São Roque do Pico	460305	f
Capelo	Ilha do Faial	Horta	470101	f
Castelo Branco	Ilha do Faial	Horta	470102	f
Cedros	Ilha do Faial	Horta	470103	f
Feteira	Ilha do Faial	Horta	470104	f
Flamengos	Ilha do Faial	Horta	470105	f
Horta (Angústias)	Ilha do Faial	Horta	470106	f
Horta (Conceição)	Ilha do Faial	Horta	470107	f
Horta (Matriz)	Ilha do Faial	Horta	470108	f
Pedro Miguel	Ilha do Faial	Horta	470109	f
Praia do Almoxarife	Ilha do Faial	Horta	470110	f
Praia do Norte	Ilha do Faial	Horta	470111	f
Ribeirinha	Ilha do Faial	Horta	470112	f
Salão	Ilha do Faial	Horta	470113	f
Fajã Grande	Ilha das Flores	Lajes das Flores	480101	f
Fajãzinha	Ilha das Flores	Lajes das Flores	480102	f
Fazenda	Ilha das Flores	Lajes das Flores	480103	f
Lajedo	Ilha das Flores	Lajes das Flores	480104	f
Lajes das Flores	Ilha das Flores	Lajes das Flores	480105	f
Lomba	Ilha das Flores	Lajes das Flores	480106	f
Mosteiro	Ilha das Flores	Lajes das Flores	480107	f
Caveira	Ilha das Flores	Santa Cruz das Flores	480201	f
Cedros	Ilha das Flores	Santa Cruz das Flores	480202	f
Ponta Delgada	Ilha das Flores	Santa Cruz das Flores	480203	f
Santa Cruz das Flores	Ilha das Flores	Santa Cruz das Flores	480204	f
Corvo	Ilha do Corvo	Corvo	490101	f
Desconhecida	Aveiro	Águeda	490102	f
Desconhecida	Aveiro	Albergaria-a-Velha	490103	f
Desconhecida	Aveiro	Anadia	490104	f
Desconhecida	Aveiro	Arouca	490105	f
Desconhecida	Aveiro	Aveiro	490106	f
Desconhecida	Aveiro	Castelo de Paiva	490107	f
Desconhecida	Aveiro	Espinho	490108	f
Desconhecida	Aveiro	Estarreja	490109	f
Desconhecida	Aveiro	Santa Maria da Feira	490110	f
Desconhecida	Aveiro	Ílhavo	490111	f
Desconhecida	Aveiro	Mealhada	490112	f
Desconhecida	Aveiro	Murtosa	490113	f
Desconhecida	Aveiro	Oliveira de Azeméis	490114	f
Desconhecida	Aveiro	Oliveira do Bairro	490115	f
Desconhecida	Aveiro	Ovar	490116	f
Desconhecida	Aveiro	São João da Madeira	490117	f
Desconhecida	Aveiro	Sever do Vouga	490118	f
Desconhecida	Aveiro	Vagos	490119	f
Desconhecida	Aveiro	Vale de Cambra	490120	f
Desconhecida	Beja	Aljustrel	490121	f
Desconhecida	Beja	Almodôvar	490122	f
Desconhecida	Beja	Alvito	490123	f
Desconhecida	Beja	Barrancos	490124	f
Desconhecida	Beja	Beja	490125	f
Desconhecida	Beja	Castro Verde	490126	f
Desconhecida	Beja	Cuba	490127	f
Desconhecida	Beja	Ferreira do Alentejo	490128	f
Desconhecida	Beja	Mértola	490129	f
Desconhecida	Beja	Moura	490130	f
Desconhecida	Beja	Odemira	490131	f
Desconhecida	Beja	Ourique	490132	f
Desconhecida	Beja	Serpa	490133	f
Desconhecida	Beja	Vidigueira	490134	f
Desconhecida	Braga	Amares	490135	f
Desconhecida	Braga	Barcelos	490136	f
Desconhecida	Braga	Braga	490137	f
Desconhecida	Braga	Cabeceiras de Basto	490138	f
Desconhecida	Braga	Celorico de Basto	490139	f
Desconhecida	Braga	Esposende	490140	f
Desconhecida	Braga	Fafe	490141	f
Desconhecida	Braga	Guimarães	490142	f
Desconhecida	Braga	Póvoa de Lanhoso	490143	f
Desconhecida	Braga	Terras de Bouro	490144	f
Desconhecida	Braga	Vieira do Minho	490145	f
Desconhecida	Braga	Vila Nova de Famalicão	490146	f
Desconhecida	Braga	Vila Verde	490147	f
Desconhecida	Braga	Vizela	490148	f
Desconhecida	Bragança	Alfândega da Fé	490149	f
Desconhecida	Bragança	Bragança	490150	f
Desconhecida	Bragança	Carrazeda de Ansiães	490151	f
Desconhecida	Bragança	Freixo de Espada à Cinta	490152	f
Desconhecida	Bragança	Macedo de Cavaleiros	490153	f
Desconhecida	Bragança	Miranda do Douro	490154	f
Desconhecida	Bragança	Mirandela	490155	f
Desconhecida	Bragança	Mogadouro	490156	f
Desconhecida	Bragança	Torre de Moncorvo	490157	f
Desconhecida	Bragança	Vila Flor	490158	f
Desconhecida	Bragança	Vimioso	490159	f
Desconhecida	Bragança	Vinhais	490160	f
Desconhecida	Castelo Branco	Belmonte	490161	f
Desconhecida	Castelo Branco	Castelo Branco	490162	f
Desconhecida	Castelo Branco	Covilhã	490163	f
Desconhecida	Castelo Branco	Fundão	490164	f
Desconhecida	Castelo Branco	Idanha-a-Nova	490165	f
Desconhecida	Castelo Branco	Oleiros	490166	f
Desconhecida	Castelo Branco	Penamacor	490167	f
Desconhecida	Castelo Branco	Proença-a-Nova	490168	f
Desconhecida	Castelo Branco	Sertã	490169	f
Desconhecida	Castelo Branco	Vila de Rei	490170	f
Desconhecida	Castelo Branco	Vila Velha de Ródão	490171	f
Desconhecida	Coimbra	Arganil	490172	f
Desconhecida	Coimbra	Cantanhede	490173	f
Desconhecida	Coimbra	Coimbra	490174	f
Desconhecida	Coimbra	Condeixa-a-Nova	490175	f
Desconhecida	Coimbra	Figueira da Foz	490176	f
Desconhecida	Coimbra	Góis	490177	f
Desconhecida	Coimbra	Lousã	490178	f
Desconhecida	Coimbra	Mira	490179	f
Desconhecida	Coimbra	Miranda do Corvo	490180	f
Desconhecida	Coimbra	Montemor-o-Velho	490181	f
Desconhecida	Coimbra	Oliveira do Hospital	490182	f
Desconhecida	Coimbra	Pampilhosa da Serra	490183	f
Desconhecida	Coimbra	Penacova	490184	f
Desconhecida	Coimbra	Penela	490185	f
Desconhecida	Coimbra	Soure	490186	f
Desconhecida	Coimbra	Tábua	490187	f
Desconhecida	Coimbra	Vila Nova de Poiares	490188	f
Desconhecida	Évora	Alandroal	490189	f
Desconhecida	Évora	Arraiolos	490190	f
Desconhecida	Évora	Borba	490191	f
Desconhecida	Évora	Estremoz	490192	f
Desconhecida	Évora	Évora	490193	f
Desconhecida	Évora	Montemor-o-Novo	490194	f
Desconhecida	Évora	Mora	490195	f
Desconhecida	Évora	Mourão	490196	f
Desconhecida	Évora	Portel	490197	f
Desconhecida	Évora	Redondo	490198	f
Desconhecida	Évora	Reguengos de Monsaraz	490199	f
Desconhecida	Évora	Vendas Novas	490200	f
Desconhecida	Évora	Viana do Alentejo	490201	f
Desconhecida	Évora	Vila Viçosa	490202	f
Desconhecida	Faro	Albufeira	490203	f
Desconhecida	Faro	Alcoutim	490204	f
Desconhecida	Faro	Aljezur	490205	f
Desconhecida	Faro	Castro Marim	490206	f
Desconhecida	Faro	Faro	490207	f
Desconhecida	Faro	Lagoa	490208	f
Desconhecida	Faro	Lagos	490209	f
Desconhecida	Faro	Loulé	490210	f
Desconhecida	Faro	Monchique	490211	f
Desconhecida	Faro	Olhão	490212	f
Desconhecida	Faro	Portimão	490213	f
Desconhecida	Faro	São Brás de Alportel	490214	f
Desconhecida	Faro	Silves	490215	f
Desconhecida	Faro	Tavira	490216	f
Desconhecida	Faro	Vila do Bispo	490217	f
Desconhecida	Faro	Vila Real de Santo António	490218	f
Desconhecida	Guarda	Aguiar da Beira	490219	f
Desconhecida	Guarda	Almeida	490220	f
Desconhecida	Guarda	Celorico da Beira	490221	f
Desconhecida	Guarda	Figueira de Castelo Rodrigo	490222	f
Desconhecida	Guarda	Fornos de Algodres	490223	f
Desconhecida	Guarda	Gouveia	490224	f
Desconhecida	Guarda	Guarda	490225	f
Desconhecida	Guarda	Manteigas	490226	f
Desconhecida	Guarda	Meda	490227	f
Desconhecida	Guarda	Pinhel	490228	f
Desconhecida	Guarda	Sabugal	490229	f
Desconhecida	Guarda	Seia	490230	f
Desconhecida	Guarda	Trancoso	490231	f
Desconhecida	Guarda	Vila Nova de Foz Côa	490232	f
Desconhecida	Leiria	Alcobaça	490233	f
Desconhecida	Leiria	Alvaiázere	490234	f
Desconhecida	Leiria	Ansião	490235	f
Desconhecida	Leiria	Batalha	490236	f
Desconhecida	Leiria	Bombarral	490237	f
Desconhecida	Leiria	Caldas da Rainha	490238	f
Desconhecida	Leiria	Castanheira de Pêra	490239	f
Desconhecida	Leiria	Figueiró dos Vinhos	490240	f
Desconhecida	Leiria	Leiria	490241	f
Desconhecida	Leiria	Marinha Grande	490242	f
Desconhecida	Leiria	Nazaré	490243	f
Desconhecida	Leiria	Óbidos	490244	f
Desconhecida	Leiria	Pedrógão Grande	490245	f
Desconhecida	Leiria	Peniche	490246	f
Desconhecida	Leiria	Pombal	490247	f
Desconhecida	Leiria	Porto de Mós	490248	f
Desconhecida	Lisboa	Alenquer	490249	f
Desconhecida	Lisboa	Arruda dos Vinhos	490250	f
Desconhecida	Lisboa	Azambuja	490251	f
Desconhecida	Lisboa	Cadaval	490252	f
Desconhecida	Lisboa	Cascais	490253	f
Desconhecida	Lisboa	Lisboa	490254	f
Desconhecida	Lisboa	Loures	490255	f
Desconhecida	Lisboa	Lourinhã	490256	f
Desconhecida	Lisboa	Mafra	490257	f
Desconhecida	Lisboa	Oeiras	490258	f
Desconhecida	Lisboa	Sintra	490259	f
Desconhecida	Lisboa	Sobral de Monte Agraço	490260	f
Desconhecida	Lisboa	Torres Vedras	490261	f
Desconhecida	Lisboa	Vila Franca de Xira	490262	f
Desconhecida	Lisboa	Amadora	490263	f
Desconhecida	Lisboa	Odivelas	490264	f
Desconhecida	Portalegre	Alter do Chão	490265	f
Desconhecida	Portalegre	Arronches	490266	f
Desconhecida	Portalegre	Avis	490267	f
Desconhecida	Portalegre	Campo Maior	490268	f
Desconhecida	Portalegre	Castelo de Vide	490269	f
Desconhecida	Portalegre	Crato	490270	f
Desconhecida	Portalegre	Elvas	490271	f
Desconhecida	Portalegre	Fronteira	490272	f
Desconhecida	Portalegre	Gavião	490273	f
Desconhecida	Portalegre	Marvão	490274	f
Desconhecida	Portalegre	Monforte	490275	f
Desconhecida	Portalegre	Nisa	490276	f
Desconhecida	Portalegre	Ponte de Sor	490277	f
Desconhecida	Portalegre	Portalegre	490278	f
Desconhecida	Portalegre	Sousel	490279	f
Desconhecida	Porto	Amarante	490280	f
Desconhecida	Porto	Baião	490281	f
Desconhecida	Porto	Felgueiras	490282	f
Desconhecida	Porto	Gondomar	490283	f
Desconhecida	Porto	Lousada	490284	f
Desconhecida	Porto	Maia	490285	f
Desconhecida	Porto	Marco de Canaveses	490286	f
Desconhecida	Porto	Matosinhos	490287	f
Desconhecida	Porto	Paços de Ferreira	490288	f
Desconhecida	Porto	Paredes	490289	f
Desconhecida	Porto	Penafiel	490290	f
Desconhecida	Porto	Porto	490291	f
Desconhecida	Porto	Póvoa de Varzim	490292	f
Desconhecida	Porto	Santo Tirso	490293	f
Desconhecida	Porto	Valongo	490294	f
Desconhecida	Porto	Vila do Conde	490295	f
Desconhecida	Porto	Vila Nova de Gaia	490296	f
Desconhecida	Porto	Trofa	490297	f
Desconhecida	Santarém	Abrantes	490298	f
Desconhecida	Santarém	Alcanena	490299	f
Desconhecida	Santarém	Almeirim	490300	f
Desconhecida	Santarém	Alpiarça	490301	f
Desconhecida	Santarém	Benavente	490302	f
Desconhecida	Santarém	Cartaxo	490303	f
Desconhecida	Santarém	Chamusca	490304	f
Desconhecida	Santarém	Constância	490305	f
Desconhecida	Santarém	Coruche	490306	f
Desconhecida	Santarém	Entroncamento	490307	f
Desconhecida	Santarém	Ferreira do Zêzere	490308	f
Desconhecida	Santarém	Golegã	490309	f
Desconhecida	Santarém	Mação	490310	f
Desconhecida	Santarém	Rio Maior	490311	f
Desconhecida	Santarém	Salvaterra de Magos	490312	f
Desconhecida	Santarém	Santarém	490313	f
Desconhecida	Santarém	Sardoal	490314	f
Desconhecida	Santarém	Tomar	490315	f
Desconhecida	Santarém	Torres Novas	490316	f
Desconhecida	Santarém	Vila Nova da Barquinha	490317	f
Desconhecida	Santarém	Ourém	490318	f
Desconhecida	Setúbal	Alcácer do Sal	490319	f
Desconhecida	Setúbal	Alcochete	490320	f
Desconhecida	Setúbal	Almada	490321	f
Desconhecida	Setúbal	Barreiro	490322	f
Desconhecida	Setúbal	Grândola	490323	f
Desconhecida	Setúbal	Moita	490324	f
Desconhecida	Setúbal	Montijo	490325	f
Desconhecida	Setúbal	Palmela	490326	f
Desconhecida	Setúbal	Santiago do Cacém	490327	f
Desconhecida	Setúbal	Seixal	490328	f
Desconhecida	Setúbal	Sesimbra	490329	f
Desconhecida	Setúbal	Setúbal	490330	f
Desconhecida	Setúbal	Sines	490331	f
Desconhecida	Viana do Castelo	Arcos de Valdevez	490332	f
Desconhecida	Viana do Castelo	Caminha	490333	f
Desconhecida	Viana do Castelo	Melgaço	490334	f
Desconhecida	Viana do Castelo	Monção	490335	f
Desconhecida	Viana do Castelo	Paredes de Coura	490336	f
Desconhecida	Viana do Castelo	Ponte da Barca	490337	f
Desconhecida	Viana do Castelo	Ponte de Lima	490338	f
Desconhecida	Viana do Castelo	Valença	490339	f
Desconhecida	Viana do Castelo	Viana do Castelo	490340	f
Desconhecida	Viana do Castelo	Vila Nova de Cerveira	490341	f
Desconhecida	Vila Real	Alijó	490342	f
Desconhecida	Vila Real	Boticas	490343	f
Desconhecida	Vila Real	Chaves	490344	f
Desconhecida	Vila Real	Mesão Frio	490345	f
Desconhecida	Vila Real	Mondim de Basto	490346	f
Desconhecida	Vila Real	Montalegre	490347	f
Desconhecida	Vila Real	Murça	490348	f
Desconhecida	Vila Real	Peso da Régua	490349	f
Desconhecida	Vila Real	Ribeira de Pena	490350	f
Desconhecida	Vila Real	Sabrosa	490351	f
Desconhecida	Vila Real	Santa Marta de Penaguião	490352	f
Desconhecida	Vila Real	Valpaços	490353	f
Desconhecida	Vila Real	Vila Pouca de Aguiar	490354	f
Desconhecida	Vila Real	Vila Real	490355	f
Desconhecida	Viseu	Armamar	490356	f
Desconhecida	Viseu	Carregal do Sal	490357	f
Desconhecida	Viseu	Castro Daire	490358	f
Desconhecida	Viseu	Cinfães	490359	f
Desconhecida	Viseu	Lamego	490360	f
Desconhecida	Viseu	Mangualde	490361	f
Desconhecida	Viseu	Moimenta da Beira	490362	f
Desconhecida	Viseu	Mortágua	490363	f
Desconhecida	Viseu	Nelas	490364	f
Desconhecida	Viseu	Oliveira de Frades	490365	f
Desconhecida	Viseu	Penalva do Castelo	490366	f
Desconhecida	Viseu	Penedono	490367	f
Desconhecida	Viseu	Resende	490368	f
Desconhecida	Viseu	Santa Comba Dão	490369	f
Desconhecida	Viseu	São João da Pesqueira	490370	f
Desconhecida	Viseu	São Pedro do Sul	490371	f
Desconhecida	Viseu	Sátão	490372	f
Desconhecida	Viseu	Sernancelhe	490373	f
Desconhecida	Viseu	Tabuaço	490374	f
Desconhecida	Viseu	Tarouca	490375	f
Desconhecida	Viseu	Tondela	490376	f
Desconhecida	Viseu	Vila Nova de Paiva	490377	f
Desconhecida	Viseu	Viseu	490378	f
Desconhecida	Viseu	Vouzela	490379	f
Desconhecida	Ilha da Madeira	Calheta (R.A.M.)	490380	f
Desconhecida	Ilha da Madeira	Câmara de Lobos	490381	f
Desconhecida	Ilha da Madeira	Funchal	490382	f
Desconhecida	Ilha da Madeira	Machico	490383	f
Desconhecida	Ilha da Madeira	Ponta do Sol	490384	f
Desconhecida	Ilha da Madeira	Porto Moniz	490385	f
Desconhecida	Ilha da Madeira	Ribeira Brava	490386	f
Desconhecida	Ilha da Madeira	Santa Cruz	490387	f
Desconhecida	Ilha da Madeira	Santana	490388	f
Desconhecida	Ilha da Madeira	São Vicente	490389	f
Desconhecida	Ilha de Porto Santo	Porto Santo	490390	f
Desconhecida	Ilha de Santa Maria	Vila do Porto	490391	f
Desconhecida	Ilha de São Miguel	Lagoa (R.A.A)	490392	f
Desconhecida	Ilha de São Miguel	Nordeste	490393	f
Desconhecida	Ilha de São Miguel	Ponta Delgada	490394	f
Desconhecida	Ilha de São Miguel	Povoação	490395	f
Desconhecida	Ilha de São Miguel	Ribeira Grande	490396	f
Desconhecida	Ilha de São Miguel	Vila Franca do Campo	490397	f
Desconhecida	Ilha Terceira	Angra do Heroísmo	490398	f
Desconhecida	Ilha Terceira	Vila da Praia da Vitória	490399	f
Desconhecida	Ilha da Graciosa	Santa Cruz da Graciosa	490400	f
Desconhecida	Ilha de São Jorge	Calheta (R.A.A.)	490401	f
Desconhecida	Ilha de São Jorge	Velas	490402	f
Desconhecida	Ilha do Pico	Lajes do Pico	490403	f
Desconhecida	Ilha do Pico	Madalena	490404	f
Desconhecida	Ilha do Pico	São Roque do Pico	490405	f
Desconhecida	Ilha do Faial	Horta	490406	f
Desconhecida	Ilha das Flores	Lajes das Flores	490407	f
Desconhecida	Ilha das Flores	Santa Cruz das Flores	490408	f
Desconhecida	Ilha do Corvo	Corvo	490409	f
Desconhecida	Aveiro	Desconhecido	490411	f
Desconhecida	Beja	Desconhecido	490412	f
Desconhecida	Braga	Desconhecido	490413	f
Desconhecida	Bragança	Desconhecido	490414	f
Desconhecida	Castelo Branco	Desconhecido	490415	f
Desconhecida	Coimbra	Desconhecido	490416	f
Desconhecida	Évora	Desconhecido	490417	f
Desconhecida	Faro	Desconhecido	490418	f
Desconhecida	Guarda	Desconhecido	490419	f
Desconhecida	Leiria	Desconhecido	490420	f
Desconhecida	Lisboa	Desconhecido	490421	f
Desconhecida	Portalegre	Desconhecido	490422	f
Desconhecida	Porto	Desconhecido	490423	f
Desconhecida	Santarém	Desconhecido	490424	f
Desconhecida	Setúbal	Desconhecido	490425	f
Desconhecida	Viana do Castelo	Desconhecido	490426	f
Desconhecida	Vila Real	Desconhecido	490427	f
Desconhecida	Viseu	Desconhecido	490428	f
Desconhecida	Ilha da Madeira	Desconhecido	490429	f
Desconhecida	Ilha de Porto Santo	Desconhecido	490430	f
Desconhecida	Ilha de Santa Maria	Desconhecido	490431	f
Desconhecida	Ilha de São Miguel	Desconhecido	490432	f
Desconhecida	Ilha Terceira	Desconhecido	490433	f
Desconhecida	Ilha da Graciosa	Desconhecido	490434	f
Desconhecida	Ilha de São Jorge	Desconhecido	490435	f
Desconhecida	Ilha do Pico	Desconhecido	490436	f
Desconhecida	Ilha do Faial	Desconhecido	490437	f
Desconhecida	Ilha das Flores	Desconhecido	490438	f
Desconhecida	Ilha do Corvo	Desconhecido	490439	f
Desconhecida	Desconhecido	Desconhecido	490610	f
\.


--
-- Data for Name: Participation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Participation" (role, nickname, "contextParishId", "createdAt", "createdById", "deathPlaceId", "kinshipId", "participationRoleId", "professionOriginal", "titleId", "updatedAt", "updatedById", id, "eventId", "individualId", "professionId", "residenceId", "originId", "lineageIndex") FROM stdin;
SUBJECT	\N	131301	2026-01-15 17:48:35.446	1	\N	\N	\N	\N	\N	2026-01-16 13:59:29.691	1	40	1	1	\N	94115	2330	1
FATHER	\N	\N	2026-01-15 17:49:42.1	1	\N	\N	\N	\N	\N	2026-01-16 13:59:29.701	1	42	1	26	\N	\N	\N	1.1
MOTHER	\N	\N	2026-01-15 17:49:30.444	1	\N	\N	\N	\N	\N	2026-01-16 13:59:29.708	1	41	1	25	\N	\N	\N	1.2
FATHER	\N	\N	2026-01-15 17:50:31.034	1	\N	\N	\N	\N	\N	2026-01-16 13:59:29.716	1	44	1	28	\N	\N	\N	1.2.1
MOTHER	\N	\N	2026-01-15 17:50:52.579	1	\N	\N	\N	\N	\N	2026-01-16 13:59:29.723	1	45	1	29	416	\N	\N	1.2.2
OTHER	\N	\N	2026-01-15 17:49:57.991	1	\N	\N	1	\N	\N	2026-01-16 13:59:29.732	1	43	1	27	\N	\N	\N	1
SUBJECT	\N	131301	2026-01-16 11:38:32.616	1	\N	\N	\N	\N	\N	2026-01-16 14:53:59.088	1	56	2	39	\N	2330	107049	1
GROOM	\N	\N	2026-01-15 20:40:45.714	1	\N	\N	\N	\N	2028	2026-01-15 20:40:45.714	1	46	3	30	\N	\N	\N	1
SUBJECT	\N	\N	2026-01-15 20:54:20.626	1	\N	\N	\N	\N	2028	2026-01-16 11:24:19.204	1	51	3	30	\N	\N	\N	1
BRIDE	\N	\N	2026-01-15 20:40:45.727	1	\N	\N	\N	\N	12	2026-01-16 11:24:19.21	1	47	3	31	687	94115	2745	2
FATHER	\N	\N	2026-01-15 21:04:17.679	1	\N	\N	\N	\N	\N	2026-01-16 11:24:19.216	1	54	3	37	\N	\N	\N	2.1
MOTHER	\N	\N	2026-01-15 20:54:20.645	1	\N	\N	\N	\N	\N	2026-01-16 11:24:19.222	1	52	3	35	\N	\N	\N	2.2
FATHER	\N	\N	2026-01-15 21:04:17.694	1	\N	\N	\N	\N	\N	2026-01-16 11:24:19.227	1	55	3	38	\N	\N	\N	2.2.1
MOTHER	\N	\N	2026-01-15 20:54:20.651	1	\N	\N	\N	\N	\N	2026-01-16 11:24:19.234	1	53	3	36	\N	\N	\N	2.2.2
OTHER	\N	\N	2026-01-15 20:40:45.765	1	\N	17	1	\N	2039	2026-01-16 11:24:19.242	1	50	3	34	416	\N	\N	1
\.


--
-- Data for Name: ParticipationRole; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ParticipationRole" (id, name, "isOriginal") FROM stdin;
0	Procurador da madrinha	f
1	Padrinho	f
2	Testemunha	f
3	Padre	f
4	Madrinha	f
5	Procurador do noivo	f
6	Procurador da noiva	f
7	Procurador do padrinho	f
\.


--
-- Data for Name: Place; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Place" (name, id, "parishId", "isOriginal") FROM stdin;
Lousa	1	40911	f
Trancoso	2	91317	f
Sambade	3	40111	f
Desconhecido	4	10101	f
Desconhecido	5	10102	f
Desconhecido	6	10103	f
Desconhecido	7	10104	f
Desconhecido	8	10105	f
Desconhecido	9	10106	f
Desconhecido	10	10107	f
Desconhecido	11	10108	f
Desconhecido	12	10109	f
Desconhecido	13	10110	f
Desconhecido	14	10111	f
Desconhecido	15	10112	f
Desconhecido	16	10113	f
Desconhecido	17	10114	f
Desconhecido	18	10115	f
Desconhecido	19	10116	f
Desconhecido	20	10117	f
Desconhecido	21	10118	f
Desconhecido	22	10119	f
Desconhecido	23	10120	f
Desconhecido	24	10201	f
Desconhecido	25	10202	f
Desconhecido	26	10203	f
Desconhecido	27	10204	f
Desconhecido	28	10205	f
Desconhecido	29	10206	f
Desconhecido	30	10207	f
Desconhecido	31	10208	f
Desconhecido	32	10301	f
Desconhecido	33	10302	f
Desconhecido	34	10303	f
Desconhecido	35	10304	f
Desconhecido	36	10305	f
Desconhecido	37	10306	f
Desconhecido	38	10307	f
Desconhecido	39	10308	f
Desconhecido	40	10309	f
Desconhecido	41	10310	f
Desconhecido	42	10311	f
Desconhecido	43	10312	f
Desconhecido	44	10313	f
Desconhecido	45	10314	f
Desconhecido	46	10315	f
Desconhecido	47	10401	f
Desconhecido	48	10402	f
Desconhecido	49	10403	f
Desconhecido	50	10404	f
Desconhecido	51	10405	f
Desconhecido	52	10406	f
Desconhecido	53	10407	f
Desconhecido	54	10408	f
Desconhecido	55	10409	f
Desconhecido	56	10410	f
Desconhecido	57	10411	f
Desconhecido	58	10412	f
Desconhecido	59	10413	f
Desconhecido	60	10414	f
Desconhecido	61	10415	f
Desconhecido	62	10416	f
Desconhecido	63	10417	f
Desconhecido	64	10418	f
Desconhecido	65	10419	f
Desconhecido	66	10420	f
Desconhecido	67	10501	f
Desconhecido	68	10502	f
Desconhecido	69	10503	f
Desconhecido	70	10504	f
Desconhecido	71	10505	f
Desconhecido	72	10506	f
Desconhecido	73	10507	f
Desconhecido	74	10508	f
Desconhecido	75	10509	f
Desconhecido	76	10510	f
Desconhecido	77	10511	f
Desconhecido	78	10512	f
Desconhecido	79	10513	f
Desconhecido	80	10514	f
Desconhecido	81	10601	f
Desconhecido	82	10602	f
Desconhecido	83	10603	f
Desconhecido	84	10604	f
Desconhecido	85	10605	f
Desconhecido	86	10606	f
Desconhecido	87	10607	f
Desconhecido	88	10608	f
Desconhecido	89	10609	f
Desconhecido	90	10701	f
Desconhecido	91	10702	f
Desconhecido	92	10703	f
Desconhecido	93	10704	f
Desconhecido	94	10705	f
Desconhecido	95	10801	f
Desconhecido	96	10802	f
Desconhecido	97	10803	f
Desconhecido	98	10804	f
Desconhecido	99	10805	f
Desconhecido	100	10806	f
Desconhecido	101	10807	f
Desconhecido	102	10901	f
Desconhecido	103	10902	f
Desconhecido	104	10903	f
Desconhecido	105	10904	f
Desconhecido	106	10905	f
Desconhecido	107	10906	f
Desconhecido	108	10907	f
Desconhecido	109	10908	f
Desconhecido	110	10909	f
Desconhecido	111	10910	f
Desconhecido	112	10911	f
Desconhecido	113	10912	f
Desconhecido	114	10913	f
Desconhecido	115	10914	f
Desconhecido	116	10915	f
Desconhecido	117	10916	f
Desconhecido	118	10917	f
Desconhecido	119	10918	f
Desconhecido	120	10919	f
Desconhecido	121	10920	f
Desconhecido	122	10921	f
Desconhecido	123	10922	f
Desconhecido	124	10923	f
Desconhecido	125	10924	f
Desconhecido	126	10925	f
Desconhecido	127	10926	f
Desconhecido	128	10927	f
Desconhecido	129	10928	f
Desconhecido	130	10929	f
Desconhecido	131	10930	f
Desconhecido	132	10931	f
Desconhecido	133	11001	f
Desconhecido	134	11002	f
Desconhecido	135	11003	f
Desconhecido	136	11004	f
Desconhecido	137	11101	f
Desconhecido	138	11102	f
Desconhecido	139	11103	f
Desconhecido	140	11104	f
Desconhecido	141	11105	f
Desconhecido	142	11106	f
Desconhecido	143	11107	f
Desconhecido	144	11108	f
Desconhecido	145	11201	f
Desconhecido	146	11202	f
Desconhecido	147	11203	f
Desconhecido	148	11204	f
Desconhecido	149	11301	f
Desconhecido	150	11302	f
Desconhecido	151	11303	f
Desconhecido	152	11304	f
Desconhecido	153	11305	f
Desconhecido	154	11306	f
Desconhecido	155	11307	f
Desconhecido	156	11308	f
Desconhecido	157	11309	f
Desconhecido	158	11310	f
Desconhecido	159	11311	f
Desconhecido	160	11312	f
Desconhecido	161	11313	f
Desconhecido	162	11314	f
Desconhecido	163	11315	f
Desconhecido	164	11316	f
Desconhecido	165	11317	f
Desconhecido	166	11318	f
Desconhecido	167	11319	f
Desconhecido	168	11401	f
Desconhecido	169	11402	f
Desconhecido	170	11403	f
Desconhecido	171	11404	f
Desconhecido	172	11405	f
Desconhecido	173	11406	f
Desconhecido	174	11501	f
Desconhecido	175	11502	f
Desconhecido	176	11503	f
Desconhecido	177	11504	f
Desconhecido	178	11505	f
Desconhecido	179	11506	f
Desconhecido	180	11507	f
Desconhecido	181	11508	f
Desconhecido	182	11601	f
Desconhecido	183	11701	f
Desconhecido	184	11702	f
Desconhecido	185	11703	f
Desconhecido	186	11704	f
Desconhecido	187	11705	f
Desconhecido	188	11706	f
Desconhecido	189	11707	f
Desconhecido	190	11708	f
Desconhecido	191	11709	f
Desconhecido	192	11801	f
Desconhecido	193	11802	f
Desconhecido	194	11803	f
Desconhecido	195	11804	f
Desconhecido	196	11805	f
Desconhecido	197	11806	f
Desconhecido	198	11807	f
Desconhecido	199	11808	f
Desconhecido	200	11809	f
Desconhecido	201	11810	f
Desconhecido	202	11811	f
Desconhecido	203	11901	f
Desconhecido	204	11902	f
Desconhecido	205	11903	f
Desconhecido	206	11904	f
Desconhecido	207	11905	f
Desconhecido	208	11906	f
Desconhecido	209	11907	f
Desconhecido	210	11908	f
Desconhecido	211	11909	f
Desconhecido	212	20101	f
Desconhecido	213	20102	f
Desconhecido	214	20103	f
Desconhecido	215	20104	f
Desconhecido	216	20105	f
Desconhecido	217	20201	f
Desconhecido	218	20202	f
Desconhecido	219	20203	f
Desconhecido	220	20204	f
Desconhecido	221	20205	f
Desconhecido	222	20206	f
Desconhecido	223	20207	f
Desconhecido	224	20208	f
Desconhecido	225	20301	f
Desconhecido	226	20302	f
Desconhecido	227	20401	f
Desconhecido	228	20501	f
Desconhecido	229	20502	f
Desconhecido	230	20503	f
Desconhecido	231	20504	f
Desconhecido	232	20505	f
Desconhecido	233	20506	f
Desconhecido	234	20507	f
Desconhecido	235	20508	f
Desconhecido	236	20509	f
Desconhecido	237	20510	f
Desconhecido	238	20511	f
Desconhecido	239	20512	f
Desconhecido	240	20513	f
Desconhecido	241	20514	f
Desconhecido	242	20515	f
Desconhecido	243	20516	f
Desconhecido	244	20517	f
Desconhecido	245	20518	f
Desconhecido	246	20601	f
Desconhecido	247	20602	f
Desconhecido	248	20603	f
Desconhecido	249	20604	f
Desconhecido	250	20605	f
Desconhecido	251	20701	f
Desconhecido	252	20702	f
Desconhecido	253	20703	f
Desconhecido	254	20704	f
Desconhecido	255	20801	f
Desconhecido	256	20802	f
Desconhecido	257	20803	f
Desconhecido	258	20804	f
Desconhecido	259	20805	f
Desconhecido	260	20806	f
Desconhecido	261	20901	f
Desconhecido	262	20902	f
Desconhecido	263	20903	f
Desconhecido	264	20904	f
Desconhecido	265	20905	f
Desconhecido	266	20906	f
Desconhecido	267	20907	f
Desconhecido	268	20908	f
Desconhecido	269	20909	f
Desconhecido	270	21001	f
Desconhecido	271	21002	f
Desconhecido	272	21003	f
Desconhecido	273	21004	f
Desconhecido	274	21005	f
Desconhecido	275	21006	f
Desconhecido	276	21007	f
Desconhecido	277	21008	f
Desconhecido	278	21101	f
Desconhecido	279	21102	f
Desconhecido	280	21103	f
Desconhecido	281	21104	f
Desconhecido	282	21105	f
Desconhecido	283	21106	f
Desconhecido	284	21107	f
Desconhecido	285	21108	f
Desconhecido	286	21109	f
Desconhecido	287	21110	f
Desconhecido	288	21111	f
Desconhecido	289	21112	f
Desconhecido	290	21113	f
Desconhecido	291	21114	f
Desconhecido	292	21115	f
Desconhecido	293	21116	f
Desconhecido	294	21117	f
Desconhecido	295	21201	f
Desconhecido	296	21202	f
Desconhecido	297	21203	f
Desconhecido	298	21204	f
Desconhecido	299	21205	f
Desconhecido	300	21206	f
Desconhecido	301	21301	f
Desconhecido	302	21302	f
Desconhecido	303	21303	f
Desconhecido	304	21304	f
Desconhecido	305	21305	f
Desconhecido	306	21306	f
Desconhecido	307	21307	f
Desconhecido	308	21401	f
Desconhecido	309	21402	f
Desconhecido	310	21403	f
Desconhecido	311	21404	f
Desconhecido	312	30101	f
Desconhecido	313	30102	f
Desconhecido	314	30103	f
Desconhecido	315	30104	f
Desconhecido	316	30105	f
Desconhecido	317	30106	f
Desconhecido	318	30107	f
Desconhecido	319	30108	f
Desconhecido	320	30109	f
Desconhecido	321	30110	f
Desconhecido	322	30111	f
Desconhecido	323	30112	f
Desconhecido	324	30113	f
Desconhecido	325	30114	f
Desconhecido	326	30115	f
Desconhecido	327	30116	f
Desconhecido	328	30117	f
Desconhecido	329	30118	f
Desconhecido	330	30119	f
Desconhecido	331	30120	f
Desconhecido	332	30121	f
Desconhecido	333	30122	f
Desconhecido	334	30123	f
Desconhecido	335	30124	f
Desconhecido	336	30201	f
Desconhecido	337	30202	f
Desconhecido	338	30203	f
Desconhecido	339	30204	f
Desconhecido	340	30205	f
Desconhecido	341	30206	f
Desconhecido	342	30207	f
Desconhecido	343	30208	f
Desconhecido	344	30209	f
Desconhecido	345	30210	f
Desconhecido	346	30211	f
Desconhecido	347	30212	f
Desconhecido	348	30213	f
Desconhecido	349	30214	f
Desconhecido	350	30215	f
Desconhecido	351	30216	f
Desconhecido	352	30217	f
Desconhecido	353	30218	f
Desconhecido	354	30219	f
Desconhecido	355	30220	f
Desconhecido	356	30221	f
Desconhecido	357	30222	f
Desconhecido	358	30223	f
Desconhecido	359	30224	f
Desconhecido	360	30225	f
Desconhecido	361	30226	f
Desconhecido	362	30227	f
Desconhecido	363	30228	f
Desconhecido	364	30229	f
Desconhecido	365	30230	f
Desconhecido	366	30231	f
Desconhecido	367	30232	f
Desconhecido	368	30233	f
Desconhecido	369	30234	f
Desconhecido	370	30235	f
Desconhecido	371	30236	f
Desconhecido	372	30237	f
Desconhecido	373	30238	f
Desconhecido	374	30239	f
Desconhecido	375	30240	f
Desconhecido	376	30241	f
Desconhecido	377	30242	f
Desconhecido	378	30243	f
Desconhecido	379	30244	f
Desconhecido	380	30245	f
Desconhecido	381	30246	f
Desconhecido	382	30247	f
Desconhecido	383	30248	f
Desconhecido	384	30249	f
Desconhecido	385	30250	f
Desconhecido	386	30251	f
Desconhecido	387	30252	f
Desconhecido	388	30253	f
Desconhecido	389	30254	f
Desconhecido	390	30255	f
Desconhecido	391	30256	f
Desconhecido	392	30257	f
Desconhecido	393	30258	f
Desconhecido	394	30259	f
Desconhecido	395	30260	f
Desconhecido	396	30261	f
Desconhecido	397	30262	f
Desconhecido	398	30263	f
Desconhecido	399	30264	f
Desconhecido	400	30265	f
Desconhecido	401	30266	f
Desconhecido	402	30267	f
Desconhecido	403	30268	f
Desconhecido	404	30269	f
Desconhecido	405	30270	f
Desconhecido	406	30271	f
Desconhecido	407	30272	f
Desconhecido	408	30273	f
Desconhecido	409	30274	f
Desconhecido	410	30275	f
Desconhecido	411	30276	f
Desconhecido	412	30277	f
Desconhecido	413	30278	f
Desconhecido	414	30279	f
Desconhecido	415	30280	f
Desconhecido	416	30281	f
Desconhecido	417	30282	f
Desconhecido	418	30283	f
Desconhecido	419	30284	f
Desconhecido	420	30285	f
Desconhecido	421	30286	f
Desconhecido	422	30287	f
Desconhecido	423	30288	f
Desconhecido	424	30289	f
Desconhecido	425	30301	f
Desconhecido	426	30302	f
Desconhecido	427	30303	f
Desconhecido	428	30304	f
Desconhecido	429	30305	f
Desconhecido	430	30306	f
Desconhecido	431	30307	f
Desconhecido	432	30308	f
Desconhecido	433	30309	f
Desconhecido	434	30310	f
Desconhecido	435	30311	f
Desconhecido	436	30312	f
Desconhecido	437	30313	f
Desconhecido	438	30314	f
Desconhecido	439	30315	f
Desconhecido	440	30316	f
Desconhecido	441	30317	f
Desconhecido	442	30318	f
Desconhecido	443	30319	f
Desconhecido	444	30320	f
Desconhecido	445	30321	f
Desconhecido	446	30322	f
Desconhecido	447	30323	f
Desconhecido	448	30324	f
Desconhecido	449	30325	f
Desconhecido	450	30326	f
Desconhecido	451	30327	f
Desconhecido	452	30328	f
Desconhecido	453	30329	f
Desconhecido	454	30330	f
Desconhecido	455	30331	f
Desconhecido	456	30332	f
Desconhecido	457	30333	f
Desconhecido	458	30334	f
Desconhecido	459	30335	f
Desconhecido	460	30336	f
Desconhecido	461	30337	f
Desconhecido	462	30338	f
Desconhecido	463	30339	f
Desconhecido	464	30340	f
Desconhecido	465	30341	f
Desconhecido	466	30342	f
Desconhecido	467	30343	f
Desconhecido	468	30344	f
Desconhecido	469	30345	f
Desconhecido	470	30346	f
Desconhecido	471	30347	f
Desconhecido	472	30348	f
Desconhecido	473	30349	f
Desconhecido	474	30350	f
Desconhecido	475	30351	f
Desconhecido	476	30352	f
Desconhecido	477	30353	f
Desconhecido	478	30354	f
Desconhecido	479	30355	f
Desconhecido	480	30356	f
Desconhecido	481	30357	f
Desconhecido	482	30358	f
Desconhecido	483	30359	f
Desconhecido	484	30360	f
Desconhecido	485	30361	f
Desconhecido	486	30362	f
Desconhecido	487	30401	f
Desconhecido	488	30402	f
Desconhecido	489	30403	f
Desconhecido	490	30404	f
Desconhecido	491	30405	f
Desconhecido	492	30406	f
Desconhecido	493	30407	f
Desconhecido	494	30408	f
Desconhecido	495	30409	f
Desconhecido	496	30410	f
Desconhecido	497	30411	f
Desconhecido	498	30412	f
Desconhecido	499	30413	f
Desconhecido	500	30414	f
Desconhecido	501	30415	f
Desconhecido	502	30416	f
Desconhecido	503	30417	f
Desconhecido	504	30501	f
Desconhecido	505	30502	f
Desconhecido	506	30503	f
Desconhecido	507	30504	f
Desconhecido	508	30505	f
Desconhecido	509	30506	f
Desconhecido	510	30507	f
Desconhecido	511	30508	f
Desconhecido	512	30509	f
Desconhecido	513	30510	f
Desconhecido	514	30511	f
Desconhecido	515	30512	f
Desconhecido	516	30513	f
Desconhecido	517	30514	f
Desconhecido	518	30515	f
Desconhecido	519	30516	f
Desconhecido	520	30517	f
Desconhecido	521	30518	f
Desconhecido	522	30519	f
Desconhecido	523	30520	f
Desconhecido	524	30521	f
Desconhecido	525	30522	f
Desconhecido	526	30601	f
Desconhecido	527	30602	f
Desconhecido	528	30603	f
Desconhecido	529	30604	f
Desconhecido	530	30605	f
Desconhecido	531	30606	f
Desconhecido	532	30607	f
Desconhecido	533	30608	f
Desconhecido	534	30609	f
Desconhecido	535	30610	f
Desconhecido	536	30611	f
Desconhecido	537	30612	f
Desconhecido	538	30613	f
Desconhecido	539	30614	f
Desconhecido	540	30615	f
Desconhecido	541	30701	f
Desconhecido	542	30702	f
Desconhecido	543	30703	f
Desconhecido	544	30704	f
Desconhecido	545	30705	f
Desconhecido	546	30706	f
Desconhecido	547	30707	f
Desconhecido	548	30708	f
Desconhecido	549	30709	f
Desconhecido	550	30710	f
Desconhecido	551	30711	f
Desconhecido	552	30712	f
Desconhecido	553	30713	f
Desconhecido	554	30714	f
Desconhecido	555	30715	f
Desconhecido	556	30716	f
Desconhecido	557	30717	f
Desconhecido	558	30718	f
Desconhecido	559	30719	f
Desconhecido	560	30720	f
Desconhecido	561	30721	f
Desconhecido	562	30722	f
Desconhecido	563	30723	f
Desconhecido	564	30724	f
Desconhecido	565	30725	f
Desconhecido	566	30726	f
Desconhecido	567	30727	f
Desconhecido	568	30728	f
Desconhecido	569	30729	f
Desconhecido	570	30730	f
Desconhecido	571	30731	f
Desconhecido	572	30732	f
Desconhecido	573	30733	f
Desconhecido	574	30734	f
Desconhecido	575	30735	f
Desconhecido	576	30736	f
Desconhecido	577	30801	f
Desconhecido	578	30802	f
Desconhecido	579	30803	f
Desconhecido	580	30804	f
Desconhecido	581	30805	f
Desconhecido	582	30806	f
Desconhecido	583	30807	f
Desconhecido	584	30808	f
Desconhecido	585	30809	f
Desconhecido	586	30810	f
Desconhecido	587	30811	f
Desconhecido	588	30812	f
Desconhecido	589	30813	f
Desconhecido	590	30814	f
Desconhecido	591	30815	f
Desconhecido	592	30816	f
Desconhecido	593	30817	f
Desconhecido	594	30818	f
Desconhecido	595	30819	f
Desconhecido	596	30820	f
Desconhecido	597	30821	f
Desconhecido	598	30822	f
Desconhecido	599	30823	f
Desconhecido	600	30824	f
Desconhecido	601	30826	f
Desconhecido	602	30827	f
Desconhecido	603	30828	f
Desconhecido	604	30829	f
Desconhecido	605	30830	f
Desconhecido	606	30831	f
Desconhecido	607	30832	f
Desconhecido	608	30833	f
Desconhecido	609	30834	f
Desconhecido	610	30835	f
Desconhecido	611	30836	f
Desconhecido	612	30837	f
Desconhecido	613	30838	f
Desconhecido	614	30839	f
Desconhecido	615	30840	f
Desconhecido	616	30841	f
Desconhecido	617	30842	f
Desconhecido	618	30843	f
Desconhecido	619	30844	f
Desconhecido	620	30845	f
Desconhecido	621	30846	f
Desconhecido	622	30847	f
Desconhecido	623	30848	f
Desconhecido	624	30849	f
Desconhecido	625	30850	f
Desconhecido	626	30851	f
Desconhecido	627	30853	f
Desconhecido	628	30854	f
Desconhecido	629	30855	f
Desconhecido	630	30856	f
Desconhecido	631	30857	f
Desconhecido	632	30858	f
Desconhecido	633	30860	f
Desconhecido	634	30862	f
Desconhecido	635	30863	f
Desconhecido	636	30864	f
Desconhecido	637	30865	f
Desconhecido	638	30866	f
Desconhecido	639	30867	f
Desconhecido	640	30868	f
Desconhecido	641	30869	f
Desconhecido	642	30871	f
Desconhecido	643	30872	f
Desconhecido	644	30873	f
Desconhecido	645	30901	f
Desconhecido	646	30902	f
Desconhecido	647	30903	f
Desconhecido	648	30904	f
Desconhecido	649	30905	f
Desconhecido	650	30906	f
Desconhecido	651	30907	f
Desconhecido	652	30908	f
Desconhecido	653	30909	f
Desconhecido	654	30910	f
Desconhecido	655	30911	f
Desconhecido	656	30912	f
Desconhecido	657	30913	f
Desconhecido	658	30914	f
Desconhecido	659	30915	f
Desconhecido	660	30916	f
Desconhecido	661	30917	f
Desconhecido	662	30918	f
Desconhecido	663	30919	f
Desconhecido	664	30920	f
Desconhecido	665	30921	f
Desconhecido	666	30922	f
Desconhecido	667	30923	f
Desconhecido	668	30924	f
Desconhecido	669	30925	f
Desconhecido	670	30926	f
Desconhecido	671	30927	f
Desconhecido	672	30928	f
Desconhecido	673	30929	f
Desconhecido	674	31001	f
Desconhecido	675	31002	f
Desconhecido	676	31003	f
Desconhecido	677	31004	f
Desconhecido	678	31005	f
Desconhecido	679	31006	f
Desconhecido	680	31007	f
Desconhecido	681	31008	f
Desconhecido	682	31009	f
Desconhecido	683	31010	f
Desconhecido	684	31011	f
Desconhecido	685	31012	f
Desconhecido	686	31013	f
Desconhecido	687	31014	f
Desconhecido	688	31015	f
Desconhecido	689	31016	f
Desconhecido	690	31017	f
Desconhecido	691	31101	f
Desconhecido	692	31102	f
Desconhecido	693	31103	f
Desconhecido	694	31104	f
Desconhecido	695	31105	f
Desconhecido	696	31106	f
Desconhecido	697	31107	f
Desconhecido	698	31108	f
Desconhecido	699	31109	f
Desconhecido	700	31110	f
Desconhecido	701	31111	f
Desconhecido	702	31112	f
Desconhecido	703	31113	f
Desconhecido	704	31114	f
Desconhecido	705	31115	f
Desconhecido	706	31116	f
Desconhecido	707	31117	f
Desconhecido	708	31118	f
Desconhecido	709	31119	f
Desconhecido	710	31120	f
Desconhecido	711	31121	f
Desconhecido	712	31201	f
Desconhecido	713	31202	f
Desconhecido	714	31203	f
Desconhecido	715	31204	f
Desconhecido	716	31205	f
Desconhecido	717	31206	f
Desconhecido	718	31207	f
Desconhecido	719	31208	f
Desconhecido	720	31209	f
Desconhecido	721	31210	f
Desconhecido	722	31211	f
Desconhecido	723	31212	f
Desconhecido	724	31213	f
Desconhecido	725	31214	f
Desconhecido	726	31215	f
Desconhecido	727	31216	f
Desconhecido	728	31217	f
Desconhecido	729	31218	f
Desconhecido	730	31219	f
Desconhecido	731	31220	f
Desconhecido	732	31221	f
Desconhecido	733	31222	f
Desconhecido	734	31223	f
Desconhecido	735	31224	f
Desconhecido	736	31225	f
Desconhecido	737	31226	f
Desconhecido	738	31227	f
Desconhecido	739	31228	f
Desconhecido	740	31229	f
Desconhecido	741	31230	f
Desconhecido	742	31231	f
Desconhecido	743	31232	f
Desconhecido	744	31233	f
Desconhecido	745	31234	f
Desconhecido	746	31235	f
Desconhecido	747	31236	f
Desconhecido	748	31237	f
Desconhecido	749	31238	f
Desconhecido	750	31239	f
Desconhecido	751	31240	f
Desconhecido	752	31241	f
Desconhecido	753	31242	f
Desconhecido	754	31243	f
Desconhecido	755	31244	f
Desconhecido	756	31245	f
Desconhecido	757	31246	f
Desconhecido	758	31247	f
Desconhecido	759	31248	f
Desconhecido	760	31249	f
Desconhecido	761	31301	f
Desconhecido	762	31302	f
Desconhecido	763	31303	f
Desconhecido	764	31304	f
Desconhecido	765	31305	f
Desconhecido	766	31306	f
Desconhecido	767	31307	f
Desconhecido	768	31308	f
Desconhecido	769	31309	f
Desconhecido	770	31310	f
Desconhecido	771	31311	f
Desconhecido	772	31312	f
Desconhecido	773	31313	f
Desconhecido	774	31314	f
Desconhecido	775	31315	f
Desconhecido	776	31316	f
Desconhecido	777	31317	f
Desconhecido	778	31318	f
Desconhecido	779	31319	f
Desconhecido	780	31320	f
Desconhecido	781	31321	f
Desconhecido	782	31322	f
Desconhecido	783	31323	f
Desconhecido	784	31324	f
Desconhecido	785	31325	f
Desconhecido	786	31326	f
Desconhecido	787	31327	f
Desconhecido	788	31328	f
Desconhecido	789	31329	f
Desconhecido	790	31330	f
Desconhecido	791	31331	f
Desconhecido	792	31332	f
Desconhecido	793	31333	f
Desconhecido	794	31334	f
Desconhecido	795	31335	f
Desconhecido	796	31336	f
Desconhecido	797	31337	f
Desconhecido	798	31338	f
Desconhecido	799	31339	f
Desconhecido	800	31340	f
Desconhecido	801	31341	f
Desconhecido	802	31342	f
Desconhecido	803	31343	f
Desconhecido	804	31344	f
Desconhecido	805	31345	f
Desconhecido	806	31346	f
Desconhecido	807	31347	f
Desconhecido	808	31348	f
Desconhecido	809	31349	f
Desconhecido	810	31350	f
Desconhecido	811	31351	f
Desconhecido	812	31352	f
Desconhecido	813	31353	f
Desconhecido	814	31354	f
Desconhecido	815	31355	f
Desconhecido	816	31356	f
Desconhecido	817	31357	f
Desconhecido	818	31358	f
Desconhecido	819	31401	f
Desconhecido	820	31402	f
Desconhecido	821	31403	f
Desconhecido	822	31404	f
Desconhecido	823	31405	f
Desconhecido	824	31406	f
Desconhecido	825	31407	f
Desconhecido	826	40101	f
Desconhecido	827	40102	f
Desconhecido	828	40103	f
Desconhecido	829	40104	f
Desconhecido	830	40105	f
Desconhecido	831	40106	f
Desconhecido	832	40107	f
Desconhecido	833	40108	f
Desconhecido	834	40109	f
Desconhecido	835	40110	f
Desconhecido	836	40111	f
Desconhecido	837	40112	f
Desconhecido	838	40113	f
Desconhecido	839	40114	f
Desconhecido	840	40115	f
Desconhecido	841	40116	f
Desconhecido	842	40117	f
Desconhecido	843	40118	f
Desconhecido	844	40119	f
Desconhecido	845	40120	f
Desconhecido	846	40201	f
Desconhecido	847	40202	f
Desconhecido	848	40203	f
Desconhecido	849	40204	f
Desconhecido	850	40205	f
Desconhecido	851	40206	f
Desconhecido	852	40207	f
Desconhecido	853	40208	f
Desconhecido	854	40209	f
Desconhecido	855	40210	f
Desconhecido	856	40211	f
Desconhecido	857	40212	f
Desconhecido	858	40213	f
Desconhecido	859	40214	f
Desconhecido	860	40215	f
Desconhecido	861	40216	f
Desconhecido	862	40217	f
Desconhecido	863	40218	f
Desconhecido	864	40219	f
Desconhecido	865	40220	f
Desconhecido	866	40221	f
Desconhecido	867	40222	f
Desconhecido	868	40223	f
Desconhecido	869	40224	f
Desconhecido	870	40225	f
Desconhecido	871	40226	f
Desconhecido	872	40227	f
Desconhecido	873	40228	f
Desconhecido	874	40229	f
Desconhecido	875	40230	f
Desconhecido	876	40231	f
Desconhecido	877	40232	f
Desconhecido	878	40233	f
Desconhecido	879	40234	f
Desconhecido	880	40235	f
Desconhecido	881	40236	f
Desconhecido	882	40237	f
Desconhecido	883	40238	f
Desconhecido	884	40239	f
Desconhecido	885	40240	f
Desconhecido	886	40241	f
Desconhecido	887	40242	f
Desconhecido	888	40243	f
Desconhecido	889	40244	f
Desconhecido	890	40245	f
Desconhecido	891	40246	f
Desconhecido	892	40247	f
Desconhecido	893	40248	f
Desconhecido	894	40249	f
Desconhecido	895	40301	f
Desconhecido	896	40302	f
Desconhecido	897	40303	f
Desconhecido	898	40304	f
Desconhecido	899	40305	f
Desconhecido	900	40306	f
Desconhecido	901	40307	f
Desconhecido	902	40308	f
Desconhecido	903	40309	f
Desconhecido	904	40310	f
Desconhecido	905	40311	f
Desconhecido	906	40312	f
Desconhecido	907	40313	f
Desconhecido	908	40314	f
Desconhecido	909	40315	f
Desconhecido	910	40316	f
Desconhecido	911	40317	f
Desconhecido	912	40318	f
Desconhecido	913	40319	f
Desconhecido	914	40401	f
Desconhecido	915	40402	f
Desconhecido	916	40403	f
Desconhecido	917	40404	f
Desconhecido	918	40405	f
Desconhecido	919	40406	f
Desconhecido	920	40501	f
Desconhecido	921	40502	f
Desconhecido	922	40503	f
Desconhecido	923	40504	f
Desconhecido	924	40505	f
Desconhecido	925	40506	f
Desconhecido	926	40507	f
Desconhecido	927	40508	f
Desconhecido	928	40509	f
Desconhecido	929	40510	f
Desconhecido	930	40511	f
Desconhecido	931	40512	f
Desconhecido	932	40513	f
Desconhecido	933	40514	f
Desconhecido	934	40515	f
Desconhecido	935	40516	f
Desconhecido	936	40517	f
Desconhecido	937	40518	f
Desconhecido	938	40519	f
Desconhecido	939	40520	f
Desconhecido	940	40521	f
Desconhecido	941	40522	f
Desconhecido	942	40523	f
Desconhecido	943	40524	f
Desconhecido	944	40525	f
Desconhecido	945	40526	f
Desconhecido	946	40527	f
Desconhecido	947	40528	f
Desconhecido	948	40529	f
Desconhecido	949	40530	f
Desconhecido	950	40531	f
Desconhecido	951	40532	f
Desconhecido	952	40533	f
Desconhecido	953	40534	f
Desconhecido	954	40535	f
Desconhecido	955	40536	f
Desconhecido	956	40537	f
Desconhecido	957	40538	f
Desconhecido	958	40601	f
Desconhecido	959	40602	f
Desconhecido	960	40603	f
Desconhecido	961	40604	f
Desconhecido	962	40605	f
Desconhecido	963	40606	f
Desconhecido	964	40607	f
Desconhecido	965	40608	f
Desconhecido	966	40609	f
Desconhecido	967	40610	f
Desconhecido	968	40611	f
Desconhecido	969	40612	f
Desconhecido	970	40613	f
Desconhecido	971	40614	f
Desconhecido	972	40615	f
Desconhecido	973	40616	f
Desconhecido	974	40617	f
Desconhecido	975	40701	f
Desconhecido	976	40702	f
Desconhecido	977	40703	f
Desconhecido	978	40704	f
Desconhecido	979	40705	f
Desconhecido	980	40706	f
Desconhecido	981	40707	f
Desconhecido	982	40708	f
Desconhecido	983	40709	f
Desconhecido	984	40710	f
Desconhecido	985	40711	f
Desconhecido	986	40712	f
Desconhecido	987	40713	f
Desconhecido	988	40714	f
Desconhecido	989	40715	f
Desconhecido	990	40716	f
Desconhecido	991	40717	f
Desconhecido	992	40718	f
Desconhecido	993	40719	f
Desconhecido	994	40720	f
Desconhecido	995	40721	f
Desconhecido	996	40722	f
Desconhecido	997	40723	f
Desconhecido	998	40724	f
Desconhecido	999	40725	f
Desconhecido	1000	40726	f
Desconhecido	1001	40727	f
Desconhecido	1002	40728	f
Desconhecido	1003	40729	f
Desconhecido	1004	40730	f
Desconhecido	1005	40731	f
Desconhecido	1006	40732	f
Desconhecido	1007	40733	f
Desconhecido	1008	40734	f
Desconhecido	1009	40735	f
Desconhecido	1010	40736	f
Desconhecido	1011	40737	f
Desconhecido	1012	40801	f
Desconhecido	1013	40802	f
Desconhecido	1014	40803	f
Desconhecido	1015	40804	f
Desconhecido	1016	40805	f
Desconhecido	1017	40806	f
Desconhecido	1018	40807	f
Desconhecido	1019	40808	f
Desconhecido	1020	40809	f
Desconhecido	1021	40810	f
Desconhecido	1022	40811	f
Desconhecido	1023	40812	f
Desconhecido	1024	40813	f
Desconhecido	1025	40814	f
Desconhecido	1026	40815	f
Desconhecido	1027	40816	f
Desconhecido	1028	40817	f
Desconhecido	1029	40818	f
Desconhecido	1030	40819	f
Desconhecido	1031	40820	f
Desconhecido	1032	40821	f
Desconhecido	1033	40822	f
Desconhecido	1034	40823	f
Desconhecido	1035	40824	f
Desconhecido	1036	40825	f
Desconhecido	1037	40826	f
Desconhecido	1038	40827	f
Desconhecido	1039	40828	f
Desconhecido	1040	40901	f
Desconhecido	1041	40902	f
Desconhecido	1042	40903	f
Desconhecido	1043	40904	f
Desconhecido	1044	40905	f
Desconhecido	1045	40906	f
Desconhecido	1046	40907	f
Desconhecido	1047	40908	f
Desconhecido	1048	40909	f
Desconhecido	1049	40910	f
Desconhecido	1050	40911	f
Desconhecido	1051	40912	f
Desconhecido	1052	40913	f
Desconhecido	1053	40914	f
Desconhecido	1054	40915	f
Desconhecido	1055	40916	f
Desconhecido	1056	40917	f
Desconhecido	1057	41001	f
Desconhecido	1058	41002	f
Desconhecido	1059	41003	f
Desconhecido	1060	41004	f
Desconhecido	1061	41005	f
Desconhecido	1062	41006	f
Desconhecido	1063	41007	f
Desconhecido	1064	41008	f
Desconhecido	1065	41009	f
Desconhecido	1066	41010	f
Desconhecido	1067	41011	f
Desconhecido	1068	41012	f
Desconhecido	1069	41013	f
Desconhecido	1070	41014	f
Desconhecido	1071	41015	f
Desconhecido	1072	41016	f
Desconhecido	1073	41017	f
Desconhecido	1074	41018	f
Desconhecido	1075	41019	f
Desconhecido	1076	41101	f
Desconhecido	1077	41102	f
Desconhecido	1078	41103	f
Desconhecido	1079	41104	f
Desconhecido	1080	41105	f
Desconhecido	1081	41106	f
Desconhecido	1082	41107	f
Desconhecido	1083	41108	f
Desconhecido	1084	41109	f
Desconhecido	1085	41110	f
Desconhecido	1086	41111	f
Desconhecido	1087	41112	f
Desconhecido	1088	41113	f
Desconhecido	1089	41114	f
Desconhecido	1090	41201	f
Desconhecido	1091	41202	f
Desconhecido	1092	41203	f
Desconhecido	1093	41204	f
Desconhecido	1094	41205	f
Desconhecido	1095	41206	f
Desconhecido	1096	41207	f
Desconhecido	1097	41208	f
Desconhecido	1098	41209	f
Desconhecido	1099	41210	f
Desconhecido	1100	41211	f
Desconhecido	1101	41212	f
Desconhecido	1102	41213	f
Desconhecido	1103	41214	f
Desconhecido	1104	41215	f
Desconhecido	1105	41216	f
Desconhecido	1106	41217	f
Desconhecido	1107	41218	f
Desconhecido	1108	41219	f
Desconhecido	1109	41220	f
Desconhecido	1110	41221	f
Desconhecido	1111	41222	f
Desconhecido	1112	41223	f
Desconhecido	1113	41224	f
Desconhecido	1114	41225	f
Desconhecido	1115	41226	f
Desconhecido	1116	41227	f
Desconhecido	1117	41228	f
Desconhecido	1118	41229	f
Desconhecido	1119	41230	f
Desconhecido	1120	41231	f
Desconhecido	1121	41232	f
Desconhecido	1122	41233	f
Desconhecido	1123	41234	f
Desconhecido	1124	41235	f
Desconhecido	1125	50101	f
Desconhecido	1126	50102	f
Desconhecido	1127	50103	f
Desconhecido	1128	50104	f
Desconhecido	1129	50105	f
Desconhecido	1130	50201	f
Desconhecido	1131	50202	f
Desconhecido	1132	50203	f
Desconhecido	1133	50204	f
Desconhecido	1134	50205	f
Desconhecido	1135	50206	f
Desconhecido	1136	50207	f
Desconhecido	1137	50208	f
Desconhecido	1138	50209	f
Desconhecido	1139	50210	f
Desconhecido	1140	50211	f
Desconhecido	1141	50212	f
Desconhecido	1142	50213	f
Desconhecido	1143	50214	f
Desconhecido	1144	50215	f
Desconhecido	1145	50216	f
Desconhecido	1146	50217	f
Desconhecido	1147	50218	f
Desconhecido	1148	50219	f
Desconhecido	1149	50220	f
Desconhecido	1150	50221	f
Desconhecido	1151	50222	f
Desconhecido	1152	50223	f
Desconhecido	1153	50224	f
Desconhecido	1154	50225	f
Desconhecido	1155	50301	f
Desconhecido	1156	50302	f
Desconhecido	1157	50303	f
Desconhecido	1158	50304	f
Desconhecido	1159	50305	f
Desconhecido	1160	50306	f
Desconhecido	1161	50307	f
Desconhecido	1162	50308	f
Desconhecido	1163	50309	f
Desconhecido	1164	50310	f
Desconhecido	1165	50311	f
Desconhecido	1166	50312	f
Desconhecido	1167	50313	f
Desconhecido	1168	50314	f
Desconhecido	1169	50315	f
Desconhecido	1170	50316	f
Desconhecido	1171	50317	f
Desconhecido	1172	50318	f
Desconhecido	1173	50319	f
Desconhecido	1174	50320	f
Desconhecido	1175	50321	f
Desconhecido	1176	50322	f
Desconhecido	1177	50323	f
Desconhecido	1178	50324	f
Desconhecido	1179	50325	f
Desconhecido	1180	50326	f
Desconhecido	1181	50327	f
Desconhecido	1182	50328	f
Desconhecido	1183	50329	f
Desconhecido	1184	50330	f
Desconhecido	1185	50331	f
Desconhecido	1186	50401	f
Desconhecido	1187	50402	f
Desconhecido	1188	50403	f
Desconhecido	1189	50404	f
Desconhecido	1190	50405	f
Desconhecido	1191	50406	f
Desconhecido	1192	50407	f
Desconhecido	1193	50408	f
Desconhecido	1194	50409	f
Desconhecido	1195	50410	f
Desconhecido	1196	50411	f
Desconhecido	1197	50412	f
Desconhecido	1198	50413	f
Desconhecido	1199	50414	f
Desconhecido	1200	50415	f
Desconhecido	1201	50416	f
Desconhecido	1202	50417	f
Desconhecido	1203	50418	f
Desconhecido	1204	50419	f
Desconhecido	1205	50420	f
Desconhecido	1206	50421	f
Desconhecido	1207	50422	f
Desconhecido	1208	50423	f
Desconhecido	1209	50424	f
Desconhecido	1210	50425	f
Desconhecido	1211	50426	f
Desconhecido	1212	50427	f
Desconhecido	1213	50428	f
Desconhecido	1214	50429	f
Desconhecido	1215	50430	f
Desconhecido	1216	50431	f
Desconhecido	1217	50501	f
Desconhecido	1218	50502	f
Desconhecido	1219	50503	f
Desconhecido	1220	50504	f
Desconhecido	1221	50505	f
Desconhecido	1222	50506	f
Desconhecido	1223	50507	f
Desconhecido	1224	50508	f
Desconhecido	1225	50509	f
Desconhecido	1226	50510	f
Desconhecido	1227	50511	f
Desconhecido	1228	50512	f
Desconhecido	1229	50513	f
Desconhecido	1230	50514	f
Desconhecido	1231	50515	f
Desconhecido	1232	50516	f
Desconhecido	1233	50517	f
Desconhecido	1234	50601	f
Desconhecido	1235	50602	f
Desconhecido	1236	50603	f
Desconhecido	1237	50604	f
Desconhecido	1238	50605	f
Desconhecido	1239	50606	f
Desconhecido	1240	50607	f
Desconhecido	1241	50608	f
Desconhecido	1242	50609	f
Desconhecido	1243	50610	f
Desconhecido	1244	50611	f
Desconhecido	1245	50612	f
Desconhecido	1246	50701	f
Desconhecido	1247	50702	f
Desconhecido	1248	50703	f
Desconhecido	1249	50704	f
Desconhecido	1250	50705	f
Desconhecido	1251	50706	f
Desconhecido	1252	50707	f
Desconhecido	1253	50708	f
Desconhecido	1254	50709	f
Desconhecido	1255	50710	f
Desconhecido	1256	50711	f
Desconhecido	1257	50712	f
Desconhecido	1258	50801	f
Desconhecido	1259	50802	f
Desconhecido	1260	50803	f
Desconhecido	1261	50804	f
Desconhecido	1262	50805	f
Desconhecido	1263	50806	f
Desconhecido	1264	50901	f
Desconhecido	1265	50902	f
Desconhecido	1266	50903	f
Desconhecido	1267	50904	f
Desconhecido	1268	50905	f
Desconhecido	1269	50906	f
Desconhecido	1270	50907	f
Desconhecido	1271	50908	f
Desconhecido	1272	50909	f
Desconhecido	1273	50910	f
Desconhecido	1274	50911	f
Desconhecido	1275	50912	f
Desconhecido	1276	50913	f
Desconhecido	1277	50914	f
Desconhecido	1278	51001	f
Desconhecido	1279	51002	f
Desconhecido	1280	51003	f
Desconhecido	1281	51101	f
Desconhecido	1282	51102	f
Desconhecido	1283	51103	f
Desconhecido	1284	51104	f
Desconhecido	1285	60101	f
Desconhecido	1286	60102	f
Desconhecido	1287	60103	f
Desconhecido	1288	60104	f
Desconhecido	1289	60105	f
Desconhecido	1290	60106	f
Desconhecido	1291	60107	f
Desconhecido	1292	60108	f
Desconhecido	1293	60109	f
Desconhecido	1294	60110	f
Desconhecido	1295	60111	f
Desconhecido	1296	60112	f
Desconhecido	1297	60113	f
Desconhecido	1298	60114	f
Desconhecido	1299	60115	f
Desconhecido	1300	60116	f
Desconhecido	1301	60117	f
Desconhecido	1302	60118	f
Desconhecido	1303	60201	f
Desconhecido	1304	60202	f
Desconhecido	1305	60203	f
Desconhecido	1306	60204	f
Desconhecido	1307	60205	f
Desconhecido	1308	60206	f
Desconhecido	1309	60207	f
Desconhecido	1310	60208	f
Desconhecido	1311	60209	f
Desconhecido	1312	60210	f
Desconhecido	1313	60211	f
Desconhecido	1314	60212	f
Desconhecido	1315	60213	f
Desconhecido	1316	60214	f
Desconhecido	1317	60215	f
Desconhecido	1318	60216	f
Desconhecido	1319	60217	f
Desconhecido	1320	60218	f
Desconhecido	1321	60219	f
Desconhecido	1322	60301	f
Desconhecido	1323	60302	f
Desconhecido	1324	60303	f
Desconhecido	1325	60304	f
Desconhecido	1326	60305	f
Desconhecido	1327	60306	f
Desconhecido	1328	60307	f
Desconhecido	1329	60308	f
Desconhecido	1330	60309	f
Desconhecido	1331	60310	f
Desconhecido	1332	60311	f
Desconhecido	1333	60312	f
Desconhecido	1334	60313	f
Desconhecido	1335	60314	f
Desconhecido	1336	60315	f
Desconhecido	1337	60316	f
Desconhecido	1338	60317	f
Desconhecido	1339	60318	f
Desconhecido	1340	60319	f
Desconhecido	1341	60320	f
Desconhecido	1342	60321	f
Desconhecido	1343	60322	f
Desconhecido	1344	60323	f
Desconhecido	1345	60324	f
Desconhecido	1346	60325	f
Desconhecido	1347	60326	f
Desconhecido	1348	60327	f
Desconhecido	1349	60328	f
Desconhecido	1350	60329	f
Desconhecido	1351	60330	f
Desconhecido	1352	60331	f
Desconhecido	1353	60401	f
Desconhecido	1354	60402	f
Desconhecido	1355	60403	f
Desconhecido	1356	60404	f
Desconhecido	1357	60405	f
Desconhecido	1358	60406	f
Desconhecido	1359	60407	f
Desconhecido	1360	60408	f
Desconhecido	1361	60409	f
Desconhecido	1362	60410	f
Desconhecido	1363	60501	f
Desconhecido	1364	60502	f
Desconhecido	1365	60503	f
Desconhecido	1366	60504	f
Desconhecido	1367	60505	f
Desconhecido	1368	60506	f
Desconhecido	1369	60507	f
Desconhecido	1370	60508	f
Desconhecido	1371	60509	f
Desconhecido	1372	60510	f
Desconhecido	1373	60511	f
Desconhecido	1374	60512	f
Desconhecido	1375	60513	f
Desconhecido	1376	60514	f
Desconhecido	1377	60515	f
Desconhecido	1378	60516	f
Desconhecido	1379	60517	f
Desconhecido	1380	60518	f
Desconhecido	1381	60601	f
Desconhecido	1382	60602	f
Desconhecido	1383	60603	f
Desconhecido	1384	60604	f
Desconhecido	1385	60605	f
Desconhecido	1386	60701	f
Desconhecido	1387	60702	f
Desconhecido	1388	60703	f
Desconhecido	1389	60704	f
Desconhecido	1390	60705	f
Desconhecido	1391	60706	f
Desconhecido	1392	60801	f
Desconhecido	1393	60802	f
Desconhecido	1394	60803	f
Desconhecido	1395	60804	f
Desconhecido	1396	60901	f
Desconhecido	1397	60902	f
Desconhecido	1398	60903	f
Desconhecido	1399	60904	f
Desconhecido	1400	60905	f
Desconhecido	1401	61001	f
Desconhecido	1402	61002	f
Desconhecido	1403	61003	f
Desconhecido	1404	61004	f
Desconhecido	1405	61005	f
Desconhecido	1406	61006	f
Desconhecido	1407	61007	f
Desconhecido	1408	61008	f
Desconhecido	1409	61009	f
Desconhecido	1410	61010	f
Desconhecido	1411	61011	f
Desconhecido	1412	61012	f
Desconhecido	1413	61013	f
Desconhecido	1414	61014	f
Desconhecido	1415	61101	f
Desconhecido	1416	61102	f
Desconhecido	1417	61103	f
Desconhecido	1418	61104	f
Desconhecido	1419	61105	f
Desconhecido	1420	61106	f
Desconhecido	1421	61107	f
Desconhecido	1422	61108	f
Desconhecido	1423	61109	f
Desconhecido	1424	61110	f
Desconhecido	1425	61111	f
Desconhecido	1426	61112	f
Desconhecido	1427	61113	f
Desconhecido	1428	61114	f
Desconhecido	1429	61115	f
Desconhecido	1430	61116	f
Desconhecido	1431	61117	f
Desconhecido	1432	61118	f
Desconhecido	1433	61119	f
Desconhecido	1434	61120	f
Desconhecido	1435	61121	f
Desconhecido	1436	61201	f
Desconhecido	1437	61202	f
Desconhecido	1438	61203	f
Desconhecido	1439	61204	f
Desconhecido	1440	61205	f
Desconhecido	1441	61206	f
Desconhecido	1442	61207	f
Desconhecido	1443	61208	f
Desconhecido	1444	61209	f
Desconhecido	1445	61210	f
Desconhecido	1446	61301	f
Desconhecido	1447	61302	f
Desconhecido	1448	61303	f
Desconhecido	1449	61304	f
Desconhecido	1450	61305	f
Desconhecido	1451	61306	f
Desconhecido	1452	61307	f
Desconhecido	1453	61308	f
Desconhecido	1454	61309	f
Desconhecido	1455	61310	f
Desconhecido	1456	61311	f
Desconhecido	1457	61401	f
Desconhecido	1458	61402	f
Desconhecido	1459	61403	f
Desconhecido	1460	61404	f
Desconhecido	1461	61405	f
Desconhecido	1462	61406	f
Desconhecido	1463	61501	f
Desconhecido	1464	61502	f
Desconhecido	1465	61503	f
Desconhecido	1466	61504	f
Desconhecido	1467	61505	f
Desconhecido	1468	61506	f
Desconhecido	1469	61507	f
Desconhecido	1470	61508	f
Desconhecido	1471	61509	f
Desconhecido	1472	61510	f
Desconhecido	1473	61511	f
Desconhecido	1474	61512	f
Desconhecido	1475	61601	f
Desconhecido	1476	61602	f
Desconhecido	1477	61603	f
Desconhecido	1478	61604	f
Desconhecido	1479	61605	f
Desconhecido	1480	61606	f
Desconhecido	1481	61607	f
Desconhecido	1482	61608	f
Desconhecido	1483	61609	f
Desconhecido	1484	61610	f
Desconhecido	1485	61611	f
Desconhecido	1486	61612	f
Desconhecido	1487	61613	f
Desconhecido	1488	61614	f
Desconhecido	1489	61615	f
Desconhecido	1490	61701	f
Desconhecido	1491	61702	f
Desconhecido	1492	61703	f
Desconhecido	1493	61704	f
Desconhecido	1494	70101	f
Desconhecido	1495	70102	f
Desconhecido	1496	70103	f
Desconhecido	1497	70104	f
Desconhecido	1498	70105	f
Desconhecido	1499	70106	f
Desconhecido	1500	70201	f
Desconhecido	1501	70202	f
Desconhecido	1502	70203	f
Desconhecido	1503	70204	f
Desconhecido	1504	70205	f
Desconhecido	1505	70206	f
Desconhecido	1506	70207	f
Desconhecido	1507	70301	f
Desconhecido	1508	70302	f
Desconhecido	1509	70303	f
Desconhecido	1510	70304	f
Desconhecido	1511	70401	f
Desconhecido	1512	70402	f
Desconhecido	1513	70403	f
Desconhecido	1514	70404	f
Desconhecido	1515	70405	f
Desconhecido	1516	70406	f
Desconhecido	1517	70407	f
Desconhecido	1518	70408	f
Desconhecido	1519	70409	f
Desconhecido	1520	70410	f
Desconhecido	1521	70411	f
Desconhecido	1522	70412	f
Desconhecido	1523	70413	f
Desconhecido	1524	70501	f
Desconhecido	1525	70502	f
Desconhecido	1526	70503	f
Desconhecido	1527	70504	f
Desconhecido	1528	70505	f
Desconhecido	1529	70506	f
Desconhecido	1530	70507	f
Desconhecido	1531	70508	f
Desconhecido	1532	70509	f
Desconhecido	1533	70511	f
Desconhecido	1534	70513	f
Desconhecido	1535	70514	f
Desconhecido	1536	70515	f
Desconhecido	1537	70516	f
Desconhecido	1538	70517	f
Desconhecido	1539	70518	f
Desconhecido	1540	70519	f
Desconhecido	1541	70520	f
Desconhecido	1542	70521	f
Desconhecido	1543	70601	f
Desconhecido	1544	70602	f
Desconhecido	1545	70603	f
Desconhecido	1546	70604	f
Desconhecido	1547	70605	f
Desconhecido	1548	70606	f
Desconhecido	1549	70607	f
Desconhecido	1550	70608	f
Desconhecido	1551	70609	f
Desconhecido	1552	70610	f
Desconhecido	1553	70701	f
Desconhecido	1554	70702	f
Desconhecido	1555	70703	f
Desconhecido	1556	70704	f
Desconhecido	1557	70801	f
Desconhecido	1558	70802	f
Desconhecido	1559	70803	f
Desconhecido	1560	70901	f
Desconhecido	1561	70902	f
Desconhecido	1562	70903	f
Desconhecido	1563	70904	f
Desconhecido	1564	70905	f
Desconhecido	1565	70906	f
Desconhecido	1566	70907	f
Desconhecido	1567	70908	f
Desconhecido	1568	71001	f
Desconhecido	1569	71002	f
Desconhecido	1570	71101	f
Desconhecido	1571	71102	f
Desconhecido	1572	71103	f
Desconhecido	1573	71104	f
Desconhecido	1574	71105	f
Desconhecido	1575	71201	f
Desconhecido	1576	71202	f
Desconhecido	1577	71301	f
Desconhecido	1578	71302	f
Desconhecido	1579	71303	f
Desconhecido	1580	71401	f
Desconhecido	1581	71402	f
Desconhecido	1582	71403	f
Desconhecido	1583	71404	f
Desconhecido	1584	71405	f
Desconhecido	1585	80101	f
Desconhecido	1586	80102	f
Desconhecido	1587	80103	f
Desconhecido	1588	80104	f
Desconhecido	1589	80105	f
Desconhecido	1590	80201	f
Desconhecido	1591	80202	f
Desconhecido	1592	80203	f
Desconhecido	1593	80204	f
Desconhecido	1594	80205	f
Desconhecido	1595	80301	f
Desconhecido	1596	80302	f
Desconhecido	1597	80303	f
Desconhecido	1598	80304	f
Desconhecido	1599	80401	f
Desconhecido	1600	80402	f
Desconhecido	1601	80403	f
Desconhecido	1602	80404	f
Desconhecido	1603	80501	f
Desconhecido	1604	80502	f
Desconhecido	1605	80503	f
Desconhecido	1606	80504	f
Desconhecido	1607	80505	f
Desconhecido	1608	80506	f
Desconhecido	1609	80601	f
Desconhecido	1610	80602	f
Desconhecido	1611	80603	f
Desconhecido	1612	80604	f
Desconhecido	1613	80605	f
Desconhecido	1614	80606	f
Desconhecido	1615	80701	f
Desconhecido	1616	80702	f
Desconhecido	1617	80703	f
Desconhecido	1618	80704	f
Desconhecido	1619	80705	f
Desconhecido	1620	80706	f
Desconhecido	1621	80801	f
Desconhecido	1622	80802	f
Desconhecido	1623	80803	f
Desconhecido	1624	80804	f
Desconhecido	1625	80805	f
Desconhecido	1626	80806	f
Desconhecido	1627	80807	f
Desconhecido	1628	80808	f
Desconhecido	1629	80809	f
Desconhecido	1630	80810	f
Desconhecido	1631	80811	f
Desconhecido	1632	80901	f
Desconhecido	1633	80902	f
Desconhecido	1634	80903	f
Desconhecido	1635	81001	f
Desconhecido	1636	81002	f
Desconhecido	1637	81003	f
Desconhecido	1638	81004	f
Desconhecido	1639	81005	f
Desconhecido	1640	81101	f
Desconhecido	1641	81102	f
Desconhecido	1642	81103	f
Desconhecido	1643	81201	f
Desconhecido	1644	81301	f
Desconhecido	1645	81302	f
Desconhecido	1646	81303	f
Desconhecido	1647	81304	f
Desconhecido	1648	81305	f
Desconhecido	1649	81306	f
Desconhecido	1650	81307	f
Desconhecido	1651	81308	f
Desconhecido	1652	81401	f
Desconhecido	1653	81402	f
Desconhecido	1654	81403	f
Desconhecido	1655	81404	f
Desconhecido	1656	81405	f
Desconhecido	1657	81406	f
Desconhecido	1658	81407	f
Desconhecido	1659	81408	f
Desconhecido	1660	81409	f
Desconhecido	1661	81501	f
Desconhecido	1662	81502	f
Desconhecido	1663	81503	f
Desconhecido	1664	81504	f
Desconhecido	1665	81505	f
Desconhecido	1666	81601	f
Desconhecido	1667	81602	f
Desconhecido	1668	81603	f
Desconhecido	1669	90101	f
Desconhecido	1670	90102	f
Desconhecido	1671	90103	f
Desconhecido	1672	90104	f
Desconhecido	1673	90105	f
Desconhecido	1674	90106	f
Desconhecido	1675	90107	f
Desconhecido	1676	90108	f
Desconhecido	1677	90109	f
Desconhecido	1678	90110	f
Desconhecido	1679	90111	f
Desconhecido	1680	90112	f
Desconhecido	1681	90113	f
Desconhecido	1682	90201	f
Desconhecido	1683	90202	f
Desconhecido	1684	90203	f
Desconhecido	1685	90204	f
Desconhecido	1686	90205	f
Desconhecido	1687	90206	f
Desconhecido	1688	90207	f
Desconhecido	1689	90208	f
Desconhecido	1690	90209	f
Desconhecido	1691	90210	f
Desconhecido	1692	90211	f
Desconhecido	1693	90212	f
Desconhecido	1694	90213	f
Desconhecido	1695	90214	f
Desconhecido	1696	90215	f
Desconhecido	1697	90216	f
Desconhecido	1698	90217	f
Desconhecido	1699	90218	f
Desconhecido	1700	90219	f
Desconhecido	1701	90220	f
Desconhecido	1702	90221	f
Desconhecido	1703	90222	f
Desconhecido	1704	90223	f
Desconhecido	1705	90224	f
Desconhecido	1706	90225	f
Desconhecido	1707	90226	f
Desconhecido	1708	90227	f
Desconhecido	1709	90228	f
Desconhecido	1710	90229	f
Desconhecido	1711	90301	f
Desconhecido	1712	90302	f
Desconhecido	1713	90303	f
Desconhecido	1714	90304	f
Desconhecido	1715	90305	f
Desconhecido	1716	90306	f
Desconhecido	1717	90307	f
Desconhecido	1718	90308	f
Desconhecido	1719	90309	f
Desconhecido	1720	90310	f
Desconhecido	1721	90311	f
Desconhecido	1722	90312	f
Desconhecido	1723	90313	f
Desconhecido	1724	90314	f
Desconhecido	1725	90315	f
Desconhecido	1726	90316	f
Desconhecido	1727	90317	f
Desconhecido	1728	90318	f
Desconhecido	1729	90319	f
Desconhecido	1730	90320	f
Desconhecido	1731	90321	f
Desconhecido	1732	90322	f
Desconhecido	1733	90401	f
Desconhecido	1734	90402	f
Desconhecido	1735	90403	f
Desconhecido	1736	90404	f
Desconhecido	1737	90405	f
Desconhecido	1738	90406	f
Desconhecido	1739	90407	f
Desconhecido	1740	90408	f
Desconhecido	1741	90409	f
Desconhecido	1742	90410	f
Desconhecido	1743	90411	f
Desconhecido	1744	90412	f
Desconhecido	1745	90413	f
Desconhecido	1746	90414	f
Desconhecido	1747	90415	f
Desconhecido	1748	90416	f
Desconhecido	1749	90417	f
Desconhecido	1750	90501	f
Desconhecido	1751	90502	f
Desconhecido	1752	90503	f
Desconhecido	1753	90504	f
Desconhecido	1754	90505	f
Desconhecido	1755	90506	f
Desconhecido	1756	90507	f
Desconhecido	1757	90508	f
Desconhecido	1758	90509	f
Desconhecido	1759	90510	f
Desconhecido	1760	90511	f
Desconhecido	1761	90512	f
Desconhecido	1762	90513	f
Desconhecido	1763	90514	f
Desconhecido	1764	90515	f
Desconhecido	1765	90516	f
Desconhecido	1766	90601	f
Desconhecido	1767	90602	f
Desconhecido	1768	90603	f
Desconhecido	1769	90604	f
Desconhecido	1770	90605	f
Desconhecido	1771	90606	f
Desconhecido	1772	90607	f
Desconhecido	1773	90608	f
Desconhecido	1774	90609	f
Desconhecido	1775	90610	f
Desconhecido	1776	90611	f
Desconhecido	1777	90612	f
Desconhecido	1778	90613	f
Desconhecido	1779	90614	f
Desconhecido	1780	90615	f
Desconhecido	1781	90616	f
Desconhecido	1782	90617	f
Desconhecido	1783	90618	f
Desconhecido	1784	90619	f
Desconhecido	1785	90620	f
Desconhecido	1786	90621	f
Desconhecido	1787	90622	f
Desconhecido	1788	90701	f
Desconhecido	1789	90702	f
Desconhecido	1790	90703	f
Desconhecido	1791	90704	f
Desconhecido	1792	90705	f
Desconhecido	1793	90706	f
Desconhecido	1794	90707	f
Desconhecido	1795	90708	f
Desconhecido	1796	90709	f
Desconhecido	1797	90710	f
Desconhecido	1798	90711	f
Desconhecido	1799	90712	f
Desconhecido	1800	90713	f
Desconhecido	1801	90714	f
Desconhecido	1802	90715	f
Desconhecido	1803	90716	f
Desconhecido	1804	90717	f
Desconhecido	1805	90718	f
Desconhecido	1806	90719	f
Desconhecido	1807	90720	f
Desconhecido	1808	90721	f
Desconhecido	1809	90722	f
Desconhecido	1810	90723	f
Desconhecido	1811	90724	f
Desconhecido	1812	90725	f
Desconhecido	1813	90726	f
Desconhecido	1814	90727	f
Desconhecido	1815	90728	f
Desconhecido	1816	90729	f
Desconhecido	1817	90730	f
Desconhecido	1818	90731	f
Desconhecido	1819	90732	f
Desconhecido	1820	90733	f
Desconhecido	1821	90734	f
Desconhecido	1822	90735	f
Desconhecido	1823	90736	f
Desconhecido	1824	90737	f
Desconhecido	1825	90738	f
Desconhecido	1826	90739	f
Desconhecido	1827	90740	f
Desconhecido	1828	90741	f
Desconhecido	1829	90742	f
Desconhecido	1830	90743	f
Desconhecido	1831	90744	f
Desconhecido	1832	90745	f
Desconhecido	1833	90746	f
Desconhecido	1834	90747	f
Desconhecido	1835	90748	f
Desconhecido	1836	90749	f
Desconhecido	1837	90750	f
Desconhecido	1838	90751	f
Desconhecido	1839	90752	f
Desconhecido	1840	90753	f
Desconhecido	1841	90754	f
Desconhecido	1842	90755	f
Desconhecido	1843	90801	f
Desconhecido	1844	90802	f
Desconhecido	1845	90803	f
Desconhecido	1846	90804	f
Desconhecido	1847	90901	f
Desconhecido	1848	90902	f
Desconhecido	1849	90903	f
Desconhecido	1850	90904	f
Desconhecido	1851	90905	f
Desconhecido	1852	90906	f
Desconhecido	1853	90907	f
Desconhecido	1854	90908	f
Desconhecido	1855	90909	f
Desconhecido	1856	90910	f
Desconhecido	1857	90911	f
Desconhecido	1858	90912	f
Desconhecido	1859	90913	f
Desconhecido	1860	90914	f
Desconhecido	1861	90915	f
Desconhecido	1862	90916	f
Desconhecido	1863	91001	f
Desconhecido	1864	91002	f
Desconhecido	1865	91003	f
Desconhecido	1866	91004	f
Desconhecido	1867	91005	f
Desconhecido	1868	91006	f
Desconhecido	1869	91007	f
Desconhecido	1870	91008	f
Desconhecido	1871	91009	f
Desconhecido	1872	91010	f
Desconhecido	1873	91011	f
Desconhecido	1874	91012	f
Desconhecido	1875	91013	f
Desconhecido	1876	91014	f
Desconhecido	1877	91015	f
Desconhecido	1878	91016	f
Desconhecido	1879	91017	f
Desconhecido	1880	91018	f
Desconhecido	1881	91019	f
Desconhecido	1882	91020	f
Desconhecido	1883	91021	f
Desconhecido	1884	91022	f
Desconhecido	1885	91023	f
Desconhecido	1886	91024	f
Desconhecido	1887	91025	f
Desconhecido	1888	91026	f
Desconhecido	1889	91027	f
Desconhecido	1890	91101	f
Desconhecido	1891	91102	f
Desconhecido	1892	91103	f
Desconhecido	1893	91104	f
Desconhecido	1894	91105	f
Desconhecido	1895	91106	f
Desconhecido	1896	91107	f
Desconhecido	1897	91108	f
Desconhecido	1898	91109	f
Desconhecido	1899	91110	f
Desconhecido	1900	91111	f
Desconhecido	1901	91112	f
Desconhecido	1902	91113	f
Desconhecido	1903	91114	f
Desconhecido	1904	91115	f
Desconhecido	1905	91116	f
Desconhecido	1906	91117	f
Desconhecido	1907	91118	f
Desconhecido	1908	91119	f
Desconhecido	1909	91120	f
Desconhecido	1910	91121	f
Desconhecido	1911	91122	f
Desconhecido	1912	91123	f
Desconhecido	1913	91124	f
Desconhecido	1914	91125	f
Desconhecido	1915	91126	f
Desconhecido	1916	91127	f
Desconhecido	1917	91128	f
Desconhecido	1918	91129	f
Desconhecido	1919	91130	f
Desconhecido	1920	91131	f
Desconhecido	1921	91132	f
Desconhecido	1922	91133	f
Desconhecido	1923	91134	f
Desconhecido	1924	91135	f
Desconhecido	1925	91136	f
Desconhecido	1926	91137	f
Desconhecido	1927	91138	f
Desconhecido	1928	91139	f
Desconhecido	1929	91140	f
Desconhecido	1930	91201	f
Desconhecido	1931	91202	f
Desconhecido	1932	91203	f
Desconhecido	1933	91204	f
Desconhecido	1934	91205	f
Desconhecido	1935	91206	f
Desconhecido	1936	91207	f
Desconhecido	1937	91208	f
Desconhecido	1938	91209	f
Desconhecido	1939	91210	f
Desconhecido	1940	91211	f
Desconhecido	1941	91212	f
Desconhecido	1942	91213	f
Desconhecido	1943	91214	f
Desconhecido	1944	91215	f
Desconhecido	1945	91216	f
Desconhecido	1946	91217	f
Desconhecido	1947	91218	f
Desconhecido	1948	91219	f
Desconhecido	1949	91220	f
Desconhecido	1950	91221	f
Desconhecido	1951	91222	f
Desconhecido	1952	91223	f
Desconhecido	1953	91224	f
Desconhecido	1954	91225	f
Desconhecido	1955	91226	f
Desconhecido	1956	91227	f
Desconhecido	1957	91228	f
Desconhecido	1958	91229	f
Desconhecido	1959	91301	f
Desconhecido	1960	91302	f
Desconhecido	1961	91303	f
Desconhecido	1962	91304	f
Desconhecido	1963	91305	f
Desconhecido	1964	91306	f
Desconhecido	1965	91307	f
Desconhecido	1966	91308	f
Desconhecido	1967	91309	f
Desconhecido	1968	91310	f
Desconhecido	1969	91311	f
Desconhecido	1970	91312	f
Desconhecido	1971	91313	f
Desconhecido	1972	91314	f
Desconhecido	1973	91315	f
Desconhecido	1974	91316	f
Desconhecido	1975	91317	f
Desconhecido	1976	91318	f
Desconhecido	1977	91319	f
Desconhecido	1978	91320	f
Desconhecido	1979	91321	f
Desconhecido	1980	91322	f
Desconhecido	1981	91323	f
Desconhecido	1982	91324	f
Desconhecido	1983	91325	f
Desconhecido	1984	91326	f
Desconhecido	1985	91327	f
Desconhecido	1986	91328	f
Desconhecido	1987	91329	f
Desconhecido	1988	91401	f
Desconhecido	1989	91402	f
Desconhecido	1990	91403	f
Desconhecido	1991	91404	f
Desconhecido	1992	91405	f
Desconhecido	1993	91406	f
Desconhecido	1994	91407	f
Desconhecido	1995	91408	f
Desconhecido	1996	91409	f
Desconhecido	1997	91410	f
Desconhecido	1998	91411	f
Desconhecido	1999	91412	f
Desconhecido	2000	91413	f
Desconhecido	2001	91414	f
Desconhecido	2002	91415	f
Desconhecido	2003	91416	f
Desconhecido	2004	91417	f
Desconhecido	2005	100101	f
Desconhecido	2006	100102	f
Desconhecido	2007	100103	f
Desconhecido	2008	100104	f
Desconhecido	2009	100105	f
Desconhecido	2010	100106	f
Desconhecido	2011	100107	f
Desconhecido	2012	100108	f
Desconhecido	2013	100109	f
Desconhecido	2014	100110	f
Desconhecido	2015	100111	f
Desconhecido	2016	100112	f
Desconhecido	2017	100113	f
Desconhecido	2018	100114	f
Desconhecido	2019	100115	f
Desconhecido	2020	100116	f
Desconhecido	2021	100118	f
Desconhecido	2022	100119	f
Desconhecido	2023	100201	f
Desconhecido	2024	100202	f
Desconhecido	2025	100203	f
Desconhecido	2026	100204	f
Desconhecido	2027	100205	f
Desconhecido	2028	100206	f
Desconhecido	2029	100207	f
Desconhecido	2030	100301	f
Desconhecido	2031	100302	f
Desconhecido	2032	100303	f
Desconhecido	2033	100304	f
Desconhecido	2034	100305	f
Desconhecido	2035	100306	f
Desconhecido	2036	100307	f
Desconhecido	2037	100308	f
Desconhecido	2038	100401	f
Desconhecido	2039	100402	f
Desconhecido	2040	100403	f
Desconhecido	2041	100404	f
Desconhecido	2042	100501	f
Desconhecido	2043	100502	f
Desconhecido	2044	100503	f
Desconhecido	2045	100504	f
Desconhecido	2046	100505	f
Desconhecido	2047	100601	f
Desconhecido	2048	100602	f
Desconhecido	2049	100603	f
Desconhecido	2050	100604	f
Desconhecido	2051	100605	f
Desconhecido	2052	100606	f
Desconhecido	2053	100607	f
Desconhecido	2054	100608	f
Desconhecido	2055	100609	f
Desconhecido	2056	100610	f
Desconhecido	2057	100611	f
Desconhecido	2058	100612	f
Desconhecido	2059	100613	f
Desconhecido	2060	100614	f
Desconhecido	2061	100615	f
Desconhecido	2062	100616	f
Desconhecido	2063	100701	f
Desconhecido	2064	100702	f
Desconhecido	2065	100801	f
Desconhecido	2066	100802	f
Desconhecido	2067	100803	f
Desconhecido	2068	100804	f
Desconhecido	2069	100805	f
Desconhecido	2070	100901	f
Desconhecido	2071	100902	f
Desconhecido	2072	100903	f
Desconhecido	2073	100904	f
Desconhecido	2074	100905	f
Desconhecido	2075	100906	f
Desconhecido	2076	100907	f
Desconhecido	2077	100908	f
Desconhecido	2078	100909	f
Desconhecido	2079	100910	f
Desconhecido	2080	100911	f
Desconhecido	2081	100912	f
Desconhecido	2082	100913	f
Desconhecido	2083	100914	f
Desconhecido	2084	100915	f
Desconhecido	2085	100916	f
Desconhecido	2086	100917	f
Desconhecido	2087	100918	f
Desconhecido	2088	100919	f
Desconhecido	2089	100920	f
Desconhecido	2090	100921	f
Desconhecido	2091	100922	f
Desconhecido	2092	100923	f
Desconhecido	2093	100924	f
Desconhecido	2094	100925	f
Desconhecido	2095	100926	f
Desconhecido	2096	100927	f
Desconhecido	2097	100930	f
Desconhecido	2098	100931	f
Desconhecido	2099	101001	f
Desconhecido	2100	101002	f
Desconhecido	2101	101003	f
Desconhecido	2102	101101	f
Desconhecido	2103	101102	f
Desconhecido	2104	101103	f
Desconhecido	2105	101201	f
Desconhecido	2106	101202	f
Desconhecido	2107	101203	f
Desconhecido	2108	101204	f
Desconhecido	2109	101205	f
Desconhecido	2110	101206	f
Desconhecido	2111	101207	f
Desconhecido	2112	101208	f
Desconhecido	2113	101209	f
Desconhecido	2114	101301	f
Desconhecido	2115	101302	f
Desconhecido	2116	101303	f
Desconhecido	2117	101401	f
Desconhecido	2118	101402	f
Desconhecido	2119	101403	f
Desconhecido	2120	101404	f
Desconhecido	2121	101405	f
Desconhecido	2122	101406	f
Desconhecido	2123	101501	f
Desconhecido	2124	101502	f
Desconhecido	2125	101503	f
Desconhecido	2126	101504	f
Desconhecido	2127	101505	f
Desconhecido	2128	101506	f
Desconhecido	2129	101507	f
Desconhecido	2130	101508	f
Desconhecido	2131	101509	f
Desconhecido	2132	101510	f
Desconhecido	2133	101511	f
Desconhecido	2134	101512	f
Desconhecido	2135	101513	f
Desconhecido	2136	101514	f
Desconhecido	2137	101515	f
Desconhecido	2138	101516	f
Desconhecido	2139	101517	f
Desconhecido	2140	101601	f
Desconhecido	2141	101602	f
Desconhecido	2142	101603	f
Desconhecido	2143	101604	f
Desconhecido	2144	101605	f
Desconhecido	2145	101606	f
Desconhecido	2146	101607	f
Desconhecido	2147	101608	f
Desconhecido	2148	101609	f
Desconhecido	2149	101610	f
Desconhecido	2150	101611	f
Desconhecido	2151	101612	f
Desconhecido	2152	101613	f
Desconhecido	2153	110101	f
Desconhecido	2154	110102	f
Desconhecido	2155	110103	f
Desconhecido	2156	110104	f
Desconhecido	2157	110105	f
Desconhecido	2158	110106	f
Desconhecido	2159	110107	f
Desconhecido	2160	110108	f
Desconhecido	2161	110109	f
Desconhecido	2162	110110	f
Desconhecido	2163	110111	f
Desconhecido	2164	110112	f
Desconhecido	2165	110113	f
Desconhecido	2166	110114	f
Desconhecido	2167	110115	f
Desconhecido	2168	110116	f
Desconhecido	2169	110201	f
Desconhecido	2170	110202	f
Desconhecido	2171	110203	f
Desconhecido	2172	110204	f
Desconhecido	2173	110301	f
Desconhecido	2174	110302	f
Desconhecido	2175	110303	f
Desconhecido	2176	110304	f
Desconhecido	2177	110305	f
Desconhecido	2178	110306	f
Desconhecido	2179	110307	f
Desconhecido	2180	110308	f
Desconhecido	2181	110309	f
Desconhecido	2182	110401	f
Desconhecido	2183	110402	f
Desconhecido	2184	110403	f
Desconhecido	2185	110404	f
Desconhecido	2186	110405	f
Desconhecido	2187	110406	f
Desconhecido	2188	110407	f
Desconhecido	2189	110408	f
Desconhecido	2190	110409	f
Desconhecido	2191	110410	f
Desconhecido	2192	110501	f
Desconhecido	2193	110502	f
Desconhecido	2194	110503	f
Desconhecido	2195	110504	f
Desconhecido	2196	110505	f
Desconhecido	2197	110506	f
Desconhecido	2198	110601	f
Desconhecido	2199	110602	f
Desconhecido	2200	110603	f
Desconhecido	2201	110604	f
Desconhecido	2202	110605	f
Desconhecido	2203	110606	f
Desconhecido	2204	110607	f
Desconhecido	2205	110608	f
Desconhecido	2206	110609	f
Desconhecido	2207	110610	f
Desconhecido	2208	110611	f
Desconhecido	2209	110612	f
Desconhecido	2210	110613	f
Desconhecido	2211	110614	f
Desconhecido	2212	110615	f
Desconhecido	2213	110616	f
Desconhecido	2214	110617	f
Desconhecido	2215	110618	f
Desconhecido	2216	110619	f
Desconhecido	2217	110620	f
Desconhecido	2218	110621	f
Desconhecido	2219	110622	f
Desconhecido	2220	110623	f
Desconhecido	2221	110624	f
Desconhecido	2222	110625	f
Desconhecido	2223	110626	f
Desconhecido	2224	110627	f
Desconhecido	2225	110628	f
Desconhecido	2226	110629	f
Desconhecido	2227	110630	f
Desconhecido	2228	110631	f
Desconhecido	2229	110632	f
Desconhecido	2230	110633	f
Desconhecido	2231	110634	f
Desconhecido	2232	110635	f
Desconhecido	2233	110636	f
Desconhecido	2234	110637	f
Desconhecido	2235	110638	f
Desconhecido	2236	110639	f
Desconhecido	2237	110640	f
Desconhecido	2238	110641	f
Desconhecido	2239	110642	f
Desconhecido	2240	110643	f
Desconhecido	2241	110644	f
Desconhecido	2242	110645	f
Desconhecido	2243	110646	f
Desconhecido	2244	110647	f
Desconhecido	2245	110648	f
Desconhecido	2246	110649	f
Desconhecido	2247	110650	f
Desconhecido	2248	110651	f
Desconhecido	2249	110652	f
Desconhecido	2250	110653	f
Desconhecido	2251	110701	f
Desconhecido	2252	110702	f
Desconhecido	2253	110703	f
Desconhecido	2254	110705	f
Desconhecido	2255	110706	f
Desconhecido	2256	110707	f
Desconhecido	2257	110708	f
Desconhecido	2258	110709	f
Desconhecido	2259	110712	f
Desconhecido	2260	110713	f
Desconhecido	2261	110714	f
Desconhecido	2262	110715	f
Desconhecido	2263	110716	f
Desconhecido	2264	110717	f
Desconhecido	2265	110719	f
Desconhecido	2266	110722	f
Desconhecido	2267	110723	f
Desconhecido	2268	110724	f
Desconhecido	2269	110801	f
Desconhecido	2270	110802	f
Desconhecido	2271	110803	f
Desconhecido	2272	110804	f
Desconhecido	2273	110805	f
Desconhecido	2274	110806	f
Desconhecido	2275	110807	f
Desconhecido	2276	110808	f
Desconhecido	2277	110809	f
Desconhecido	2278	110810	f
Desconhecido	2279	110811	f
Desconhecido	2280	110901	f
Desconhecido	2281	110902	f
Desconhecido	2282	110903	f
Desconhecido	2283	110904	f
Desconhecido	2284	110905	f
Desconhecido	2285	110906	f
Desconhecido	2286	110907	f
Desconhecido	2287	110908	f
Desconhecido	2288	110909	f
Desconhecido	2289	110910	f
Desconhecido	2290	110911	f
Desconhecido	2291	110912	f
Desconhecido	2292	110913	f
Desconhecido	2293	110914	f
Desconhecido	2294	110915	f
Desconhecido	2295	110916	f
Desconhecido	2296	110917	f
Desconhecido	2297	111002	f
Desconhecido	2298	111003	f
Desconhecido	2299	111004	f
Desconhecido	2300	111005	f
Desconhecido	2301	111006	f
Desconhecido	2302	111007	f
Desconhecido	2303	111008	f
Desconhecido	2304	111009	f
Desconhecido	2305	111010	f
Desconhecido	2306	111011	f
Desconhecido	2307	111102	f
Desconhecido	2308	111103	f
Desconhecido	2309	111104	f
Desconhecido	2310	111105	f
Desconhecido	2311	111106	f
Desconhecido	2312	111107	f
Desconhecido	2313	111108	f
Desconhecido	2314	111109	f
Desconhecido	2315	111110	f
Desconhecido	2316	111111	f
Desconhecido	2317	111112	f
Desconhecido	2318	111113	f
Desconhecido	2319	111114	f
Desconhecido	2320	111115	f
Desconhecido	2321	111116	f
Desconhecido	2322	111117	f
Desconhecido	2323	111118	f
Desconhecido	2324	111119	f
Desconhecido	2325	111120	f
Desconhecido	2326	111121	f
Desconhecido	2327	111201	f
Desconhecido	2328	111202	f
Desconhecido	2329	111203	f
Desconhecido	2330	111301	f
Desconhecido	2331	111302	f
Desconhecido	2332	111303	f
Desconhecido	2333	111304	f
Desconhecido	2334	111305	f
Desconhecido	2335	111306	f
Desconhecido	2336	111307	f
Desconhecido	2337	111308	f
Desconhecido	2338	111309	f
Desconhecido	2339	111310	f
Desconhecido	2340	111311	f
Desconhecido	2341	111312	f
Desconhecido	2342	111313	f
Desconhecido	2343	111314	f
Desconhecido	2344	111315	f
Desconhecido	2345	111316	f
Desconhecido	2346	111317	f
Desconhecido	2347	111318	f
Desconhecido	2348	111319	f
Desconhecido	2349	111320	f
Desconhecido	2350	111401	f
Desconhecido	2351	111402	f
Desconhecido	2352	111403	f
Desconhecido	2353	111404	f
Desconhecido	2354	111405	f
Desconhecido	2355	111406	f
Desconhecido	2356	111407	f
Desconhecido	2357	111408	f
Desconhecido	2358	111409	f
Desconhecido	2359	111410	f
Desconhecido	2360	111411	f
Desconhecido	2361	111501	f
Desconhecido	2362	111502	f
Desconhecido	2363	111503	f
Desconhecido	2364	111504	f
Desconhecido	2365	111505	f
Desconhecido	2366	111506	f
Desconhecido	2367	111507	f
Desconhecido	2368	111508	f
Desconhecido	2369	111509	f
Desconhecido	2370	111510	f
Desconhecido	2371	111511	f
Desconhecido	2372	111601	f
Desconhecido	2373	111602	f
Desconhecido	2374	111603	f
Desconhecido	2375	111604	f
Desconhecido	2376	111605	f
Desconhecido	2377	111606	f
Desconhecido	2378	111607	f
Desconhecido	2379	120101	f
Desconhecido	2380	120102	f
Desconhecido	2381	120103	f
Desconhecido	2382	120104	f
Desconhecido	2383	120201	f
Desconhecido	2384	120202	f
Desconhecido	2385	120203	f
Desconhecido	2386	120301	f
Desconhecido	2387	120302	f
Desconhecido	2388	120303	f
Desconhecido	2389	120304	f
Desconhecido	2390	120305	f
Desconhecido	2391	120306	f
Desconhecido	2392	120307	f
Desconhecido	2393	120308	f
Desconhecido	2394	120401	f
Desconhecido	2395	120402	f
Desconhecido	2396	120403	f
Desconhecido	2397	120501	f
Desconhecido	2398	120502	f
Desconhecido	2399	120503	f
Desconhecido	2400	120504	f
Desconhecido	2401	120601	f
Desconhecido	2402	120602	f
Desconhecido	2403	120603	f
Desconhecido	2404	120604	f
Desconhecido	2405	120605	f
Desconhecido	2406	120606	f
Desconhecido	2407	120701	f
Desconhecido	2408	120702	f
Desconhecido	2409	120703	f
Desconhecido	2410	120704	f
Desconhecido	2411	120705	f
Desconhecido	2412	120706	f
Desconhecido	2413	120707	f
Desconhecido	2414	120708	f
Desconhecido	2415	120709	f
Desconhecido	2416	120710	f
Desconhecido	2417	120711	f
Desconhecido	2418	120801	f
Desconhecido	2419	120802	f
Desconhecido	2420	120803	f
Desconhecido	2421	120901	f
Desconhecido	2422	120902	f
Desconhecido	2423	120903	f
Desconhecido	2424	120904	f
Desconhecido	2425	120905	f
Desconhecido	2426	121001	f
Desconhecido	2427	121002	f
Desconhecido	2428	121003	f
Desconhecido	2429	121004	f
Desconhecido	2430	121101	f
Desconhecido	2431	121102	f
Desconhecido	2432	121103	f
Desconhecido	2433	121104	f
Desconhecido	2434	121201	f
Desconhecido	2435	121202	f
Desconhecido	2436	121203	f
Desconhecido	2437	121204	f
Desconhecido	2438	121205	f
Desconhecido	2439	121206	f
Desconhecido	2440	121207	f
Desconhecido	2441	121208	f
Desconhecido	2442	121209	f
Desconhecido	2443	121210	f
Desconhecido	2444	121301	f
Desconhecido	2445	121302	f
Desconhecido	2446	121303	f
Desconhecido	2447	121304	f
Desconhecido	2448	121305	f
Desconhecido	2449	121306	f
Desconhecido	2450	121307	f
Desconhecido	2451	121401	f
Desconhecido	2452	121402	f
Desconhecido	2453	121403	f
Desconhecido	2454	121404	f
Desconhecido	2455	121405	f
Desconhecido	2456	121406	f
Desconhecido	2457	121407	f
Desconhecido	2458	121408	f
Desconhecido	2459	121409	f
Desconhecido	2460	121410	f
Desconhecido	2461	121501	f
Desconhecido	2462	121502	f
Desconhecido	2463	121503	f
Desconhecido	2464	121504	f
Desconhecido	2465	130101	f
Desconhecido	2466	130102	f
Desconhecido	2467	130103	f
Desconhecido	2468	130104	f
Desconhecido	2469	130105	f
Desconhecido	2470	130106	f
Desconhecido	2471	130107	f
Desconhecido	2472	130108	f
Desconhecido	2473	130109	f
Desconhecido	2474	130110	f
Desconhecido	2475	130111	f
Desconhecido	2476	130112	f
Desconhecido	2477	130113	f
Desconhecido	2478	130114	f
Desconhecido	2479	130115	f
Desconhecido	2480	130116	f
Desconhecido	2481	130117	f
Desconhecido	2482	130118	f
Desconhecido	2483	130119	f
Desconhecido	2484	130120	f
Desconhecido	2485	130121	f
Desconhecido	2486	130122	f
Desconhecido	2487	130123	f
Desconhecido	2488	130124	f
Desconhecido	2489	130125	f
Desconhecido	2490	130126	f
Desconhecido	2491	130127	f
Desconhecido	2492	130128	f
Desconhecido	2493	130129	f
Desconhecido	2494	130130	f
Desconhecido	2495	130131	f
Desconhecido	2496	130132	f
Desconhecido	2497	130133	f
Desconhecido	2498	130134	f
Desconhecido	2499	130135	f
Desconhecido	2500	130136	f
Desconhecido	2501	130137	f
Desconhecido	2502	130138	f
Desconhecido	2503	130139	f
Desconhecido	2504	130140	f
Desconhecido	2505	130201	f
Desconhecido	2506	130202	f
Desconhecido	2507	130203	f
Desconhecido	2508	130204	f
Desconhecido	2509	130205	f
Desconhecido	2510	130206	f
Desconhecido	2511	130207	f
Desconhecido	2512	130208	f
Desconhecido	2513	130209	f
Desconhecido	2514	130210	f
Desconhecido	2515	130211	f
Desconhecido	2516	130212	f
Desconhecido	2517	130213	f
Desconhecido	2518	130214	f
Desconhecido	2519	130215	f
Desconhecido	2520	130216	f
Desconhecido	2521	130217	f
Desconhecido	2522	130218	f
Desconhecido	2523	130219	f
Desconhecido	2524	130220	f
Desconhecido	2525	130301	f
Desconhecido	2526	130302	f
Desconhecido	2527	130303	f
Desconhecido	2528	130304	f
Desconhecido	2529	130305	f
Desconhecido	2530	130306	f
Desconhecido	2531	130307	f
Desconhecido	2532	130308	f
Desconhecido	2533	130309	f
Desconhecido	2534	130310	f
Desconhecido	2535	130311	f
Desconhecido	2536	130312	f
Desconhecido	2537	130313	f
Desconhecido	2538	130314	f
Desconhecido	2539	130315	f
Desconhecido	2540	130316	f
Desconhecido	2541	130317	f
Desconhecido	2542	130318	f
Desconhecido	2543	130319	f
Desconhecido	2544	130320	f
Desconhecido	2545	130321	f
Desconhecido	2546	130323	f
Desconhecido	2547	130324	f
Desconhecido	2548	130325	f
Desconhecido	2549	130326	f
Desconhecido	2550	130327	f
Desconhecido	2551	130328	f
Desconhecido	2552	130329	f
Desconhecido	2553	130330	f
Desconhecido	2554	130331	f
Desconhecido	2555	130332	f
Desconhecido	2556	130333	f
Desconhecido	2557	130401	f
Desconhecido	2558	130402	f
Desconhecido	2559	130403	f
Desconhecido	2560	130404	f
Desconhecido	2561	130405	f
Desconhecido	2562	130406	f
Desconhecido	2563	130407	f
Desconhecido	2564	130408	f
Desconhecido	2565	130409	f
Desconhecido	2566	130410	f
Desconhecido	2567	130411	f
Desconhecido	2568	130412	f
Desconhecido	2569	130501	f
Desconhecido	2570	130502	f
Desconhecido	2571	130503	f
Desconhecido	2572	130504	f
Desconhecido	2573	130505	f
Desconhecido	2574	130506	f
Desconhecido	2575	130507	f
Desconhecido	2576	130508	f
Desconhecido	2577	130509	f
Desconhecido	2578	130510	f
Desconhecido	2579	130511	f
Desconhecido	2580	130512	f
Desconhecido	2581	130513	f
Desconhecido	2582	130514	f
Desconhecido	2583	130515	f
Desconhecido	2584	130516	f
Desconhecido	2585	130517	f
Desconhecido	2586	130518	f
Desconhecido	2587	130520	f
Desconhecido	2588	130521	f
Desconhecido	2589	130522	f
Desconhecido	2590	130523	f
Desconhecido	2591	130524	f
Desconhecido	2592	130525	f
Desconhecido	2593	130526	f
Desconhecido	2594	130601	f
Desconhecido	2595	130602	f
Desconhecido	2596	130603	f
Desconhecido	2597	130604	f
Desconhecido	2598	130605	f
Desconhecido	2599	130606	f
Desconhecido	2600	130607	f
Desconhecido	2601	130608	f
Desconhecido	2602	130609	f
Desconhecido	2603	130610	f
Desconhecido	2604	130611	f
Desconhecido	2605	130612	f
Desconhecido	2606	130613	f
Desconhecido	2607	130614	f
Desconhecido	2608	130615	f
Desconhecido	2609	130616	f
Desconhecido	2610	130617	f
Desconhecido	2611	130701	f
Desconhecido	2612	130702	f
Desconhecido	2613	130703	f
Desconhecido	2614	130704	f
Desconhecido	2615	130705	f
Desconhecido	2616	130706	f
Desconhecido	2617	130707	f
Desconhecido	2618	130708	f
Desconhecido	2619	130709	f
Desconhecido	2620	130710	f
Desconhecido	2621	130711	f
Desconhecido	2622	130712	f
Desconhecido	2623	130713	f
Desconhecido	2624	130714	f
Desconhecido	2625	130715	f
Desconhecido	2626	130716	f
Desconhecido	2627	130717	f
Desconhecido	2628	130718	f
Desconhecido	2629	130719	f
Desconhecido	2630	130720	f
Desconhecido	2631	130721	f
Desconhecido	2632	130722	f
Desconhecido	2633	130723	f
Desconhecido	2634	130724	f
Desconhecido	2635	130725	f
Desconhecido	2636	130726	f
Desconhecido	2637	130727	f
Desconhecido	2638	130728	f
Desconhecido	2639	130729	f
Desconhecido	2640	130730	f
Desconhecido	2641	130731	f
Desconhecido	2642	130801	f
Desconhecido	2643	130802	f
Desconhecido	2644	130803	f
Desconhecido	2645	130804	f
Desconhecido	2646	130805	f
Desconhecido	2647	130806	f
Desconhecido	2648	130807	f
Desconhecido	2649	130808	f
Desconhecido	2650	130809	f
Desconhecido	2651	130810	f
Desconhecido	2652	130901	f
Desconhecido	2653	130902	f
Desconhecido	2654	130903	f
Desconhecido	2655	130904	f
Desconhecido	2656	130905	f
Desconhecido	2657	130906	f
Desconhecido	2658	130907	f
Desconhecido	2659	130908	f
Desconhecido	2660	130909	f
Desconhecido	2661	130910	f
Desconhecido	2662	130911	f
Desconhecido	2663	130912	f
Desconhecido	2664	130913	f
Desconhecido	2665	130914	f
Desconhecido	2666	130915	f
Desconhecido	2667	130916	f
Desconhecido	2668	131001	f
Desconhecido	2669	131002	f
Desconhecido	2670	131003	f
Desconhecido	2671	131004	f
Desconhecido	2672	131005	f
Desconhecido	2673	131006	f
Desconhecido	2674	131007	f
Desconhecido	2675	131008	f
Desconhecido	2676	131009	f
Desconhecido	2677	131010	f
Desconhecido	2678	131011	f
Desconhecido	2679	131012	f
Desconhecido	2680	131013	f
Desconhecido	2681	131014	f
Desconhecido	2682	131015	f
Desconhecido	2683	131016	f
Desconhecido	2684	131017	f
Desconhecido	2685	131018	f
Desconhecido	2686	131019	f
Desconhecido	2687	131020	f
Desconhecido	2688	131021	f
Desconhecido	2689	131022	f
Desconhecido	2690	131023	f
Desconhecido	2691	131024	f
Desconhecido	2692	131101	f
Desconhecido	2693	131102	f
Desconhecido	2694	131103	f
Desconhecido	2695	131104	f
Desconhecido	2696	131105	f
Desconhecido	2697	131106	f
Desconhecido	2698	131107	f
Desconhecido	2699	131108	f
Desconhecido	2700	131109	f
Desconhecido	2701	131110	f
Desconhecido	2702	131111	f
Desconhecido	2703	131112	f
Desconhecido	2704	131113	f
Desconhecido	2705	131114	f
Desconhecido	2706	131115	f
Desconhecido	2707	131116	f
Desconhecido	2708	131117	f
Desconhecido	2709	131118	f
Desconhecido	2710	131119	f
Desconhecido	2711	131120	f
Desconhecido	2712	131121	f
Desconhecido	2713	131122	f
Desconhecido	2714	131123	f
Desconhecido	2715	131124	f
Desconhecido	2716	131125	f
Desconhecido	2717	131126	f
Desconhecido	2718	131127	f
Desconhecido	2719	131128	f
Desconhecido	2720	131129	f
Desconhecido	2721	131130	f
Desconhecido	2722	131131	f
Desconhecido	2723	131132	f
Desconhecido	2724	131133	f
Desconhecido	2725	131134	f
Desconhecido	2726	131135	f
Desconhecido	2727	131136	f
Desconhecido	2728	131137	f
Desconhecido	2729	131138	f
Desconhecido	2730	131201	f
Desconhecido	2731	131202	f
Desconhecido	2732	131203	f
Desconhecido	2733	131204	f
Desconhecido	2734	131205	f
Desconhecido	2735	131206	f
Desconhecido	2736	131207	f
Desconhecido	2737	131208	f
Desconhecido	2738	131209	f
Desconhecido	2739	131210	f
Desconhecido	2740	131211	f
Desconhecido	2741	131212	f
Desconhecido	2742	131213	f
Desconhecido	2743	131214	f
Desconhecido	2744	131215	f
Desconhecido	2745	131301	f
Desconhecido	2746	131302	f
Desconhecido	2747	131303	f
Desconhecido	2748	131304	f
Desconhecido	2749	131305	f
Desconhecido	2750	131306	f
Desconhecido	2751	131307	f
Desconhecido	2752	131308	f
Desconhecido	2753	131309	f
Desconhecido	2754	131310	f
Desconhecido	2755	131311	f
Desconhecido	2756	131312	f
Desconhecido	2757	131401	f
Desconhecido	2758	131402	f
Desconhecido	2759	131404	f
Desconhecido	2760	131405	f
Desconhecido	2761	131406	f
Desconhecido	2762	131407	f
Desconhecido	2763	131410	f
Desconhecido	2764	131411	f
Desconhecido	2765	131412	f
Desconhecido	2766	131413	f
Desconhecido	2767	131415	f
Desconhecido	2768	131416	f
Desconhecido	2769	131417	f
Desconhecido	2770	131418	f
Desconhecido	2771	131419	f
Desconhecido	2772	131420	f
Desconhecido	2773	131422	f
Desconhecido	2774	131424	f
Desconhecido	2775	131426	f
Desconhecido	2776	131427	f
Desconhecido	2777	131429	f
Desconhecido	2778	131430	f
Desconhecido	2779	131431	f
Desconhecido	2780	131432	f
Desconhecido	2781	131501	f
Desconhecido	2782	131502	f
Desconhecido	2783	131503	f
Desconhecido	2784	131504	f
Desconhecido	2785	131505	f
Desconhecido	2786	131601	f
Desconhecido	2787	131602	f
Desconhecido	2788	131603	f
Desconhecido	2789	131604	f
Desconhecido	2790	131605	f
Desconhecido	2791	131606	f
Desconhecido	2792	131607	f
Desconhecido	2793	131608	f
Desconhecido	2794	131609	f
Desconhecido	2795	131610	f
Desconhecido	2796	131611	f
Desconhecido	2797	131612	f
Desconhecido	2798	131613	f
Desconhecido	2799	131614	f
Desconhecido	2800	131615	f
Desconhecido	2801	131616	f
Desconhecido	2802	131617	f
Desconhecido	2803	131618	f
Desconhecido	2804	131619	f
Desconhecido	2805	131620	f
Desconhecido	2806	131621	f
Desconhecido	2807	131622	f
Desconhecido	2808	131623	f
Desconhecido	2809	131624	f
Desconhecido	2810	131625	f
Desconhecido	2811	131626	f
Desconhecido	2812	131627	f
Desconhecido	2813	131628	f
Desconhecido	2814	131629	f
Desconhecido	2815	131630	f
Desconhecido	2816	131701	f
Desconhecido	2817	131702	f
Desconhecido	2818	131703	f
Desconhecido	2819	131704	f
Desconhecido	2820	131705	f
Desconhecido	2821	131706	f
Desconhecido	2822	131707	f
Desconhecido	2823	131708	f
Desconhecido	2824	131709	f
Desconhecido	2825	131710	f
Desconhecido	2826	131711	f
Desconhecido	2827	131712	f
Desconhecido	2828	131713	f
Desconhecido	2829	131714	f
Desconhecido	2830	131715	f
Desconhecido	2831	131716	f
Desconhecido	2832	131717	f
Desconhecido	2833	131718	f
Desconhecido	2834	131719	f
Desconhecido	2835	131720	f
Desconhecido	2836	131721	f
Desconhecido	2837	131722	f
Desconhecido	2838	131723	f
Desconhecido	2839	131724	f
Desconhecido	2840	131801	f
Desconhecido	2841	131802	f
Desconhecido	2842	131803	f
Desconhecido	2843	131804	f
Desconhecido	2844	131805	f
Desconhecido	2845	131806	f
Desconhecido	2846	131807	f
Desconhecido	2847	131808	f
Desconhecido	2848	140101	f
Desconhecido	2849	140102	f
Desconhecido	2850	140103	f
Desconhecido	2851	140104	f
Desconhecido	2852	140105	f
Desconhecido	2853	140106	f
Desconhecido	2854	140107	f
Desconhecido	2855	140108	f
Desconhecido	2856	140109	f
Desconhecido	2857	140110	f
Desconhecido	2858	140111	f
Desconhecido	2859	140112	f
Desconhecido	2860	140113	f
Desconhecido	2861	140114	f
Desconhecido	2862	140115	f
Desconhecido	2863	140116	f
Desconhecido	2864	140117	f
Desconhecido	2865	140118	f
Desconhecido	2866	140119	f
Desconhecido	2867	140201	f
Desconhecido	2868	140202	f
Desconhecido	2869	140203	f
Desconhecido	2870	140204	f
Desconhecido	2871	140205	f
Desconhecido	2872	140206	f
Desconhecido	2873	140207	f
Desconhecido	2874	140208	f
Desconhecido	2875	140209	f
Desconhecido	2876	140210	f
Desconhecido	2877	140301	f
Desconhecido	2878	140302	f
Desconhecido	2879	140303	f
Desconhecido	2880	140304	f
Desconhecido	2881	140401	f
Desconhecido	2882	140501	f
Desconhecido	2883	140502	f
Desconhecido	2884	140503	f
Desconhecido	2885	140504	f
Desconhecido	2886	140601	f
Desconhecido	2887	140602	f
Desconhecido	2888	140603	f
Desconhecido	2889	140604	f
Desconhecido	2890	140605	f
Desconhecido	2891	140606	f
Desconhecido	2892	140607	f
Desconhecido	2893	140608	f
Desconhecido	2894	140701	f
Desconhecido	2895	140702	f
Desconhecido	2896	140703	f
Desconhecido	2897	140704	f
Desconhecido	2898	140705	f
Desconhecido	2899	140706	f
Desconhecido	2900	140707	f
Desconhecido	2901	140801	f
Desconhecido	2902	140802	f
Desconhecido	2903	140803	f
Desconhecido	2904	140901	f
Desconhecido	2905	140902	f
Desconhecido	2906	140903	f
Desconhecido	2907	140904	f
Desconhecido	2908	140905	f
Desconhecido	2909	140906	f
Desconhecido	2910	140907	f
Desconhecido	2911	140908	f
Desconhecido	2912	141001	f
Desconhecido	2913	141101	f
Desconhecido	2914	141102	f
Desconhecido	2915	141103	f
Desconhecido	2916	141104	f
Desconhecido	2917	141105	f
Desconhecido	2918	141106	f
Desconhecido	2919	141107	f
Desconhecido	2920	141108	f
Desconhecido	2921	141109	f
Desconhecido	2922	141201	f
Desconhecido	2923	141202	f
Desconhecido	2924	141301	f
Desconhecido	2925	141302	f
Desconhecido	2926	141303	f
Desconhecido	2927	141304	f
Desconhecido	2928	141305	f
Desconhecido	2929	141306	f
Desconhecido	2930	141307	f
Desconhecido	2931	141308	f
Desconhecido	2932	141401	f
Desconhecido	2933	141402	f
Desconhecido	2934	141403	f
Desconhecido	2935	141404	f
Desconhecido	2936	141405	f
Desconhecido	2937	141406	f
Desconhecido	2938	141407	f
Desconhecido	2939	141408	f
Desconhecido	2940	141409	f
Desconhecido	2941	141410	f
Desconhecido	2942	141411	f
Desconhecido	2943	141412	f
Desconhecido	2944	141413	f
Desconhecido	2945	141414	f
Desconhecido	2946	141501	f
Desconhecido	2947	141502	f
Desconhecido	2948	141503	f
Desconhecido	2949	141504	f
Desconhecido	2950	141505	f
Desconhecido	2951	141506	f
Desconhecido	2952	141601	f
Desconhecido	2953	141602	f
Desconhecido	2954	141603	f
Desconhecido	2955	141604	f
Desconhecido	2956	141605	f
Desconhecido	2957	141606	f
Desconhecido	2958	141607	f
Desconhecido	2959	141608	f
Desconhecido	2960	141609	f
Desconhecido	2961	141610	f
Desconhecido	2962	141611	f
Desconhecido	2963	141612	f
Desconhecido	2964	141613	f
Desconhecido	2965	141614	f
Desconhecido	2966	141615	f
Desconhecido	2967	141616	f
Desconhecido	2968	141617	f
Desconhecido	2969	141618	f
Desconhecido	2970	141619	f
Desconhecido	2971	141620	f
Desconhecido	2972	141621	f
Desconhecido	2973	141622	f
Desconhecido	2974	141623	f
Desconhecido	2975	141624	f
Desconhecido	2976	141625	f
Desconhecido	2977	141626	f
Desconhecido	2978	141627	f
Desconhecido	2979	141628	f
Desconhecido	2980	141701	f
Desconhecido	2981	141702	f
Desconhecido	2982	141703	f
Desconhecido	2983	141704	f
Desconhecido	2984	141801	f
Desconhecido	2985	141802	f
Desconhecido	2986	141803	f
Desconhecido	2987	141804	f
Desconhecido	2988	141805	f
Desconhecido	2989	141806	f
Desconhecido	2990	141807	f
Desconhecido	2991	141808	f
Desconhecido	2992	141809	f
Desconhecido	2993	141810	f
Desconhecido	2994	141811	f
Desconhecido	2995	141812	f
Desconhecido	2996	141813	f
Desconhecido	2997	141814	f
Desconhecido	2998	141815	f
Desconhecido	2999	141816	f
Desconhecido	3000	141901	f
Desconhecido	3001	141902	f
Desconhecido	3002	141903	f
Desconhecido	3003	141904	f
Desconhecido	3004	141905	f
Desconhecido	3005	141906	f
Desconhecido	3006	141907	f
Desconhecido	3007	141908	f
Desconhecido	3008	141909	f
Desconhecido	3009	141910	f
Desconhecido	3010	141911	f
Desconhecido	3011	141912	f
Desconhecido	3012	141913	f
Desconhecido	3013	141914	f
Desconhecido	3014	141915	f
Desconhecido	3015	141916	f
Desconhecido	3016	141917	f
Desconhecido	3017	142001	f
Desconhecido	3018	142002	f
Desconhecido	3019	142003	f
Desconhecido	3020	142004	f
Desconhecido	3021	142005	f
Desconhecido	3022	142101	f
Desconhecido	3023	142102	f
Desconhecido	3024	142103	f
Desconhecido	3025	142104	f
Desconhecido	3026	142105	f
Desconhecido	3027	142106	f
Desconhecido	3028	142107	f
Desconhecido	3029	142108	f
Desconhecido	3030	142109	f
Desconhecido	3031	142110	f
Desconhecido	3032	142111	f
Desconhecido	3033	142112	f
Desconhecido	3034	142113	f
Desconhecido	3035	142114	f
Desconhecido	3036	142115	f
Desconhecido	3037	142116	f
Desconhecido	3038	142117	f
Desconhecido	3039	142118	f
Desconhecido	3040	150101	f
Desconhecido	3041	150102	f
Desconhecido	3042	150103	f
Desconhecido	3043	150104	f
Desconhecido	3044	150105	f
Desconhecido	3045	150106	f
Desconhecido	3046	150201	f
Desconhecido	3047	150202	f
Desconhecido	3048	150203	f
Desconhecido	3049	150301	f
Desconhecido	3050	150302	f
Desconhecido	3051	150303	f
Desconhecido	3052	150304	f
Desconhecido	3053	150305	f
Desconhecido	3054	150306	f
Desconhecido	3055	150307	f
Desconhecido	3056	150308	f
Desconhecido	3057	150309	f
Desconhecido	3058	150310	f
Desconhecido	3059	150311	f
Desconhecido	3060	150401	f
Desconhecido	3061	150402	f
Desconhecido	3062	150403	f
Desconhecido	3063	150404	f
Desconhecido	3064	150405	f
Desconhecido	3065	150406	f
Desconhecido	3066	150407	f
Desconhecido	3067	150408	f
Desconhecido	3068	150501	f
Desconhecido	3069	150502	f
Desconhecido	3070	150503	f
Desconhecido	3071	150504	f
Desconhecido	3072	150505	f
Desconhecido	3073	150601	f
Desconhecido	3074	150602	f
Desconhecido	3075	150603	f
Desconhecido	3076	150604	f
Desconhecido	3077	150605	f
Desconhecido	3078	150606	f
Desconhecido	3079	150701	f
Desconhecido	3080	150702	f
Desconhecido	3081	150703	f
Desconhecido	3082	150704	f
Desconhecido	3083	150705	f
Desconhecido	3084	150706	f
Desconhecido	3085	150707	f
Desconhecido	3086	150708	f
Desconhecido	3087	150801	f
Desconhecido	3088	150802	f
Desconhecido	3089	150803	f
Desconhecido	3090	150804	f
Desconhecido	3091	150805	f
Desconhecido	3092	150901	f
Desconhecido	3093	150902	f
Desconhecido	3094	150903	f
Desconhecido	3095	150904	f
Desconhecido	3096	150905	f
Desconhecido	3097	150906	f
Desconhecido	3098	150907	f
Desconhecido	3099	150908	f
Desconhecido	3100	150909	f
Desconhecido	3101	150910	f
Desconhecido	3102	150911	f
Desconhecido	3103	151001	f
Desconhecido	3104	151002	f
Desconhecido	3105	151003	f
Desconhecido	3106	151004	f
Desconhecido	3107	151005	f
Desconhecido	3108	151006	f
Desconhecido	3109	151101	f
Desconhecido	3110	151102	f
Desconhecido	3111	151103	f
Desconhecido	3112	151201	f
Desconhecido	3113	151202	f
Desconhecido	3114	151203	f
Desconhecido	3115	151204	f
Desconhecido	3116	151205	f
Desconhecido	3117	151206	f
Desconhecido	3118	151207	f
Desconhecido	3119	151208	f
Desconhecido	3120	151301	f
Desconhecido	3121	151302	f
Desconhecido	3122	160101	f
Desconhecido	3123	160102	f
Desconhecido	3124	160103	f
Desconhecido	3125	160104	f
Desconhecido	3126	160105	f
Desconhecido	3127	160106	f
Desconhecido	3128	160107	f
Desconhecido	3129	160108	f
Desconhecido	3130	160109	f
Desconhecido	3131	160110	f
Desconhecido	3132	160111	f
Desconhecido	3133	160112	f
Desconhecido	3134	160113	f
Desconhecido	3135	160114	f
Desconhecido	3136	160115	f
Desconhecido	3137	160116	f
Desconhecido	3138	160117	f
Desconhecido	3139	160118	f
Desconhecido	3140	160119	f
Desconhecido	3141	160120	f
Desconhecido	3142	160121	f
Desconhecido	3143	160122	f
Desconhecido	3144	160123	f
Desconhecido	3145	160124	f
Desconhecido	3146	160125	f
Desconhecido	3147	160126	f
Desconhecido	3148	160127	f
Desconhecido	3149	160128	f
Desconhecido	3150	160129	f
Desconhecido	3151	160130	f
Desconhecido	3152	160131	f
Desconhecido	3153	160132	f
Desconhecido	3154	160133	f
Desconhecido	3155	160134	f
Desconhecido	3156	160135	f
Desconhecido	3157	160136	f
Desconhecido	3158	160137	f
Desconhecido	3159	160138	f
Desconhecido	3160	160139	f
Desconhecido	3161	160140	f
Desconhecido	3162	160141	f
Desconhecido	3163	160142	f
Desconhecido	3164	160143	f
Desconhecido	3165	160144	f
Desconhecido	3166	160145	f
Desconhecido	3167	160146	f
Desconhecido	3168	160147	f
Desconhecido	3169	160148	f
Desconhecido	3170	160149	f
Desconhecido	3171	160150	f
Desconhecido	3172	160151	f
Desconhecido	3173	160201	f
Desconhecido	3174	160202	f
Desconhecido	3175	160203	f
Desconhecido	3176	160204	f
Desconhecido	3177	160205	f
Desconhecido	3178	160206	f
Desconhecido	3179	160207	f
Desconhecido	3180	160208	f
Desconhecido	3181	160209	f
Desconhecido	3182	160210	f
Desconhecido	3183	160211	f
Desconhecido	3184	160212	f
Desconhecido	3185	160213	f
Desconhecido	3186	160214	f
Desconhecido	3187	160215	f
Desconhecido	3188	160216	f
Desconhecido	3189	160217	f
Desconhecido	3190	160218	f
Desconhecido	3191	160219	f
Desconhecido	3192	160220	f
Desconhecido	3193	160301	f
Desconhecido	3194	160302	f
Desconhecido	3195	160303	f
Desconhecido	3196	160304	f
Desconhecido	3197	160305	f
Desconhecido	3198	160306	f
Desconhecido	3199	160307	f
Desconhecido	3200	160308	f
Desconhecido	3201	160309	f
Desconhecido	3202	160310	f
Desconhecido	3203	160311	f
Desconhecido	3204	160312	f
Desconhecido	3205	160313	f
Desconhecido	3206	160314	f
Desconhecido	3207	160315	f
Desconhecido	3208	160316	f
Desconhecido	3209	160317	f
Desconhecido	3210	160318	f
Desconhecido	3211	160401	f
Desconhecido	3212	160402	f
Desconhecido	3213	160403	f
Desconhecido	3214	160404	f
Desconhecido	3215	160405	f
Desconhecido	3216	160406	f
Desconhecido	3217	160407	f
Desconhecido	3218	160408	f
Desconhecido	3219	160409	f
Desconhecido	3220	160410	f
Desconhecido	3221	160411	f
Desconhecido	3222	160412	f
Desconhecido	3223	160413	f
Desconhecido	3224	160414	f
Desconhecido	3225	160415	f
Desconhecido	3226	160416	f
Desconhecido	3227	160417	f
Desconhecido	3228	160418	f
Desconhecido	3229	160419	f
Desconhecido	3230	160420	f
Desconhecido	3231	160421	f
Desconhecido	3232	160422	f
Desconhecido	3233	160423	f
Desconhecido	3234	160424	f
Desconhecido	3235	160425	f
Desconhecido	3236	160426	f
Desconhecido	3237	160427	f
Desconhecido	3238	160428	f
Desconhecido	3239	160429	f
Desconhecido	3240	160430	f
Desconhecido	3241	160431	f
Desconhecido	3242	160432	f
Desconhecido	3243	160433	f
Desconhecido	3244	160501	f
Desconhecido	3245	160502	f
Desconhecido	3246	160503	f
Desconhecido	3247	160504	f
Desconhecido	3248	160505	f
Desconhecido	3249	160506	f
Desconhecido	3250	160507	f
Desconhecido	3251	160508	f
Desconhecido	3252	160509	f
Desconhecido	3253	160510	f
Desconhecido	3254	160511	f
Desconhecido	3255	160512	f
Desconhecido	3256	160513	f
Desconhecido	3257	160514	f
Desconhecido	3258	160515	f
Desconhecido	3259	160516	f
Desconhecido	3260	160517	f
Desconhecido	3261	160518	f
Desconhecido	3262	160519	f
Desconhecido	3263	160520	f
Desconhecido	3264	160521	f
Desconhecido	3265	160601	f
Desconhecido	3266	160602	f
Desconhecido	3267	160603	f
Desconhecido	3268	160604	f
Desconhecido	3269	160605	f
Desconhecido	3270	160606	f
Desconhecido	3271	160607	f
Desconhecido	3272	160608	f
Desconhecido	3273	160609	f
Desconhecido	3274	160610	f
Desconhecido	3275	160611	f
Desconhecido	3276	160612	f
Desconhecido	3277	160613	f
Desconhecido	3278	160614	f
Desconhecido	3279	160615	f
Desconhecido	3280	160616	f
Desconhecido	3281	160617	f
Desconhecido	3282	160618	f
Desconhecido	3283	160619	f
Desconhecido	3284	160620	f
Desconhecido	3285	160621	f
Desconhecido	3286	160622	f
Desconhecido	3287	160623	f
Desconhecido	3288	160624	f
Desconhecido	3289	160625	f
Desconhecido	3290	160701	f
Desconhecido	3291	160702	f
Desconhecido	3292	160703	f
Desconhecido	3293	160704	f
Desconhecido	3294	160705	f
Desconhecido	3295	160706	f
Desconhecido	3296	160707	f
Desconhecido	3297	160708	f
Desconhecido	3298	160709	f
Desconhecido	3299	160710	f
Desconhecido	3300	160711	f
Desconhecido	3301	160712	f
Desconhecido	3302	160713	f
Desconhecido	3303	160714	f
Desconhecido	3304	160715	f
Desconhecido	3305	160716	f
Desconhecido	3306	160717	f
Desconhecido	3307	160718	f
Desconhecido	3308	160719	f
Desconhecido	3309	160720	f
Desconhecido	3310	160721	f
Desconhecido	3311	160722	f
Desconhecido	3312	160723	f
Desconhecido	3313	160724	f
Desconhecido	3314	160725	f
Desconhecido	3315	160726	f
Desconhecido	3316	160727	f
Desconhecido	3317	160728	f
Desconhecido	3318	160729	f
Desconhecido	3319	160730	f
Desconhecido	3320	160731	f
Desconhecido	3321	160732	f
Desconhecido	3322	160733	f
Desconhecido	3323	160734	f
Desconhecido	3324	160735	f
Desconhecido	3325	160736	f
Desconhecido	3326	160737	f
Desconhecido	3327	160738	f
Desconhecido	3328	160739	f
Desconhecido	3329	160740	f
Desconhecido	3330	160741	f
Desconhecido	3331	160742	f
Desconhecido	3332	160743	f
Desconhecido	3333	160744	f
Desconhecido	3334	160745	f
Desconhecido	3335	160746	f
Desconhecido	3336	160747	f
Desconhecido	3337	160748	f
Desconhecido	3338	160749	f
Desconhecido	3339	160750	f
Desconhecido	3340	160751	f
Desconhecido	3341	160801	f
Desconhecido	3342	160802	f
Desconhecido	3343	160803	f
Desconhecido	3344	160804	f
Desconhecido	3345	160805	f
Desconhecido	3346	160806	f
Desconhecido	3347	160807	f
Desconhecido	3348	160808	f
Desconhecido	3349	160809	f
Desconhecido	3350	160810	f
Desconhecido	3351	160811	f
Desconhecido	3352	160812	f
Desconhecido	3353	160813	f
Desconhecido	3354	160814	f
Desconhecido	3355	160815	f
Desconhecido	3356	160816	f
Desconhecido	3357	160901	f
Desconhecido	3358	160902	f
Desconhecido	3359	160903	f
Desconhecido	3360	160904	f
Desconhecido	3361	160905	f
Desconhecido	3362	160906	f
Desconhecido	3363	160907	f
Desconhecido	3364	160908	f
Desconhecido	3365	160909	f
Desconhecido	3366	160910	f
Desconhecido	3367	160911	f
Desconhecido	3368	160912	f
Desconhecido	3369	160913	f
Desconhecido	3370	160914	f
Desconhecido	3371	160915	f
Desconhecido	3372	160916	f
Desconhecido	3373	160917	f
Desconhecido	3374	160918	f
Desconhecido	3375	160919	f
Desconhecido	3376	160920	f
Desconhecido	3377	160921	f
Desconhecido	3378	160922	f
Desconhecido	3379	160923	f
Desconhecido	3380	160924	f
Desconhecido	3381	160925	f
Desconhecido	3382	160926	f
Desconhecido	3383	160927	f
Desconhecido	3384	160928	f
Desconhecido	3385	160929	f
Desconhecido	3386	160930	f
Desconhecido	3387	160931	f
Desconhecido	3388	160932	f
Desconhecido	3389	160933	f
Desconhecido	3390	160934	f
Desconhecido	3391	160935	f
Desconhecido	3392	160936	f
Desconhecido	3393	160937	f
Desconhecido	3394	160938	f
Desconhecido	3395	160939	f
Desconhecido	3396	160940	f
Desconhecido	3397	161001	f
Desconhecido	3398	161002	f
Desconhecido	3399	161003	f
Desconhecido	3400	161004	f
Desconhecido	3401	161005	f
Desconhecido	3402	161006	f
Desconhecido	3403	161007	f
Desconhecido	3404	161008	f
Desconhecido	3405	161009	f
Desconhecido	3406	161010	f
Desconhecido	3407	161011	f
Desconhecido	3408	161012	f
Desconhecido	3409	161013	f
Desconhecido	3410	161014	f
Desconhecido	3411	161015	f
Desconhecido	3412	170101	f
Desconhecido	3413	170102	f
Desconhecido	3414	170103	f
Desconhecido	3415	170104	f
Desconhecido	3416	170105	f
Desconhecido	3417	170106	f
Desconhecido	3418	170107	f
Desconhecido	3419	170108	f
Desconhecido	3420	170109	f
Desconhecido	3421	170110	f
Desconhecido	3422	170111	f
Desconhecido	3423	170112	f
Desconhecido	3424	170113	f
Desconhecido	3425	170114	f
Desconhecido	3426	170115	f
Desconhecido	3427	170116	f
Desconhecido	3428	170117	f
Desconhecido	3429	170118	f
Desconhecido	3430	170119	f
Desconhecido	3431	170201	f
Desconhecido	3432	170202	f
Desconhecido	3433	170203	f
Desconhecido	3434	170204	f
Desconhecido	3435	170205	f
Desconhecido	3436	170206	f
Desconhecido	3437	170207	f
Desconhecido	3438	170208	f
Desconhecido	3439	170209	f
Desconhecido	3440	170210	f
Desconhecido	3441	170211	f
Desconhecido	3442	170212	f
Desconhecido	3443	170213	f
Desconhecido	3444	170214	f
Desconhecido	3445	170215	f
Desconhecido	3446	170216	f
Desconhecido	3447	170301	f
Desconhecido	3448	170302	f
Desconhecido	3449	170303	f
Desconhecido	3450	170304	f
Desconhecido	3451	170305	f
Desconhecido	3452	170306	f
Desconhecido	3453	170307	f
Desconhecido	3454	170309	f
Desconhecido	3455	170310	f
Desconhecido	3456	170311	f
Desconhecido	3457	170312	f
Desconhecido	3458	170313	f
Desconhecido	3459	170314	f
Desconhecido	3460	170315	f
Desconhecido	3461	170316	f
Desconhecido	3462	170317	f
Desconhecido	3463	170318	f
Desconhecido	3464	170319	f
Desconhecido	3465	170320	f
Desconhecido	3466	170321	f
Desconhecido	3467	170322	f
Desconhecido	3468	170323	f
Desconhecido	3469	170324	f
Desconhecido	3470	170325	f
Desconhecido	3471	170326	f
Desconhecido	3472	170327	f
Desconhecido	3473	170328	f
Desconhecido	3474	170329	f
Desconhecido	3475	170330	f
Desconhecido	3476	170331	f
Desconhecido	3477	170332	f
Desconhecido	3478	170333	f
Desconhecido	3479	170334	f
Desconhecido	3480	170335	f
Desconhecido	3481	170336	f
Desconhecido	3482	170337	f
Desconhecido	3483	170338	f
Desconhecido	3484	170339	f
Desconhecido	3485	170340	f
Desconhecido	3486	170341	f
Desconhecido	3487	170342	f
Desconhecido	3488	170343	f
Desconhecido	3489	170344	f
Desconhecido	3490	170345	f
Desconhecido	3491	170346	f
Desconhecido	3492	170347	f
Desconhecido	3493	170348	f
Desconhecido	3494	170349	f
Desconhecido	3495	170350	f
Desconhecido	3496	170351	f
Desconhecido	3497	170352	f
Desconhecido	3498	170401	f
Desconhecido	3499	170402	f
Desconhecido	3500	170403	f
Desconhecido	3501	170404	f
Desconhecido	3502	170405	f
Desconhecido	3503	170406	f
Desconhecido	3504	170407	f
Desconhecido	3505	170501	f
Desconhecido	3506	170502	f
Desconhecido	3507	170503	f
Desconhecido	3508	170504	f
Desconhecido	3509	170505	f
Desconhecido	3510	170506	f
Desconhecido	3511	170507	f
Desconhecido	3512	170508	f
Desconhecido	3513	170601	f
Desconhecido	3514	170602	f
Desconhecido	3515	170603	f
Desconhecido	3516	170604	f
Desconhecido	3517	170605	f
Desconhecido	3518	170606	f
Desconhecido	3519	170607	f
Desconhecido	3520	170608	f
Desconhecido	3521	170609	f
Desconhecido	3522	170610	f
Desconhecido	3523	170611	f
Desconhecido	3524	170612	f
Desconhecido	3525	170613	f
Desconhecido	3526	170614	f
Desconhecido	3527	170615	f
Desconhecido	3528	170616	f
Desconhecido	3529	170617	f
Desconhecido	3530	170618	f
Desconhecido	3531	170619	f
Desconhecido	3532	170620	f
Desconhecido	3533	170621	f
Desconhecido	3534	170622	f
Desconhecido	3535	170623	f
Desconhecido	3536	170624	f
Desconhecido	3537	170625	f
Desconhecido	3538	170626	f
Desconhecido	3539	170627	f
Desconhecido	3540	170628	f
Desconhecido	3541	170629	f
Desconhecido	3542	170630	f
Desconhecido	3543	170631	f
Desconhecido	3544	170632	f
Desconhecido	3545	170633	f
Desconhecido	3546	170634	f
Desconhecido	3547	170635	f
Desconhecido	3548	170701	f
Desconhecido	3549	170702	f
Desconhecido	3550	170703	f
Desconhecido	3551	170704	f
Desconhecido	3552	170705	f
Desconhecido	3553	170706	f
Desconhecido	3554	170707	f
Desconhecido	3555	170708	f
Desconhecido	3556	170709	f
Desconhecido	3557	170801	f
Desconhecido	3558	170802	f
Desconhecido	3559	170803	f
Desconhecido	3560	170804	f
Desconhecido	3561	170805	f
Desconhecido	3562	170806	f
Desconhecido	3563	170807	f
Desconhecido	3564	170808	f
Desconhecido	3565	170809	f
Desconhecido	3566	170810	f
Desconhecido	3567	170811	f
Desconhecido	3568	170812	f
Desconhecido	3569	170901	f
Desconhecido	3570	170902	f
Desconhecido	3571	170903	f
Desconhecido	3572	170904	f
Desconhecido	3573	170905	f
Desconhecido	3574	170906	f
Desconhecido	3575	170907	f
Desconhecido	3576	171001	f
Desconhecido	3577	171002	f
Desconhecido	3578	171003	f
Desconhecido	3579	171004	f
Desconhecido	3580	171005	f
Desconhecido	3581	171006	f
Desconhecido	3582	171007	f
Desconhecido	3583	171008	f
Desconhecido	3584	171009	f
Desconhecido	3585	171010	f
Desconhecido	3586	171011	f
Desconhecido	3587	171012	f
Desconhecido	3588	171013	f
Desconhecido	3589	171014	f
Desconhecido	3590	171015	f
Desconhecido	3591	171101	f
Desconhecido	3592	171102	f
Desconhecido	3593	171103	f
Desconhecido	3594	171104	f
Desconhecido	3595	171105	f
Desconhecido	3596	171106	f
Desconhecido	3597	171107	f
Desconhecido	3598	171108	f
Desconhecido	3599	171109	f
Desconhecido	3600	171110	f
Desconhecido	3601	171201	f
Desconhecido	3602	171202	f
Desconhecido	3603	171203	f
Desconhecido	3604	171204	f
Desconhecido	3605	171205	f
Desconhecido	3606	171206	f
Desconhecido	3607	171207	f
Desconhecido	3608	171208	f
Desconhecido	3609	171209	f
Desconhecido	3610	171210	f
Desconhecido	3611	171211	f
Desconhecido	3612	171212	f
Desconhecido	3613	171213	f
Desconhecido	3614	171214	f
Desconhecido	3615	171215	f
Desconhecido	3616	171216	f
Desconhecido	3617	171217	f
Desconhecido	3618	171218	f
Desconhecido	3619	171219	f
Desconhecido	3620	171220	f
Desconhecido	3621	171221	f
Desconhecido	3622	171222	f
Desconhecido	3623	171223	f
Desconhecido	3624	171224	f
Desconhecido	3625	171225	f
Desconhecido	3626	171226	f
Desconhecido	3627	171227	f
Desconhecido	3628	171228	f
Desconhecido	3629	171229	f
Desconhecido	3630	171230	f
Desconhecido	3631	171231	f
Desconhecido	3632	171301	f
Desconhecido	3633	171302	f
Desconhecido	3634	171303	f
Desconhecido	3635	171304	f
Desconhecido	3636	171305	f
Desconhecido	3637	171306	f
Desconhecido	3638	171307	f
Desconhecido	3639	171308	f
Desconhecido	3640	171309	f
Desconhecido	3641	171310	f
Desconhecido	3642	171311	f
Desconhecido	3643	171312	f
Desconhecido	3644	171313	f
Desconhecido	3645	171314	f
Desconhecido	3646	171315	f
Desconhecido	3647	171316	f
Desconhecido	3648	171317	f
Desconhecido	3649	171401	f
Desconhecido	3650	171402	f
Desconhecido	3651	171403	f
Desconhecido	3652	171404	f
Desconhecido	3653	171405	f
Desconhecido	3654	171406	f
Desconhecido	3655	171407	f
Desconhecido	3656	171408	f
Desconhecido	3657	171409	f
Desconhecido	3658	171410	f
Desconhecido	3659	171411	f
Desconhecido	3660	171412	f
Desconhecido	3661	171413	f
Desconhecido	3662	171414	f
Desconhecido	3663	171415	f
Desconhecido	3664	171416	f
Desconhecido	3665	171417	f
Desconhecido	3666	171418	f
Desconhecido	3667	171419	f
Desconhecido	3668	171420	f
Desconhecido	3669	171421	f
Desconhecido	3670	171422	f
Desconhecido	3671	171423	f
Desconhecido	3672	171424	f
Desconhecido	3673	171425	f
Desconhecido	3674	171426	f
Desconhecido	3675	171427	f
Desconhecido	3676	171428	f
Desconhecido	3677	171429	f
Desconhecido	3678	171430	f
Desconhecido	3679	180101	f
Desconhecido	3680	180102	f
Desconhecido	3681	180103	f
Desconhecido	3682	180104	f
Desconhecido	3683	180105	f
Desconhecido	3684	180106	f
Desconhecido	3685	180107	f
Desconhecido	3686	180108	f
Desconhecido	3687	180109	f
Desconhecido	3688	180110	f
Desconhecido	3689	180111	f
Desconhecido	3690	180112	f
Desconhecido	3691	180113	f
Desconhecido	3692	180114	f
Desconhecido	3693	180115	f
Desconhecido	3694	180116	f
Desconhecido	3695	180117	f
Desconhecido	3696	180118	f
Desconhecido	3697	180119	f
Desconhecido	3698	180201	f
Desconhecido	3699	180202	f
Desconhecido	3700	180203	f
Desconhecido	3701	180204	f
Desconhecido	3702	180205	f
Desconhecido	3703	180206	f
Desconhecido	3704	180207	f
Desconhecido	3705	180301	f
Desconhecido	3706	180302	f
Desconhecido	3707	180303	f
Desconhecido	3708	180304	f
Desconhecido	3709	180305	f
Desconhecido	3710	180306	f
Desconhecido	3711	180307	f
Desconhecido	3712	180308	f
Desconhecido	3713	180309	f
Desconhecido	3714	180310	f
Desconhecido	3715	180311	f
Desconhecido	3716	180312	f
Desconhecido	3717	180313	f
Desconhecido	3718	180314	f
Desconhecido	3719	180315	f
Desconhecido	3720	180316	f
Desconhecido	3721	180317	f
Desconhecido	3722	180318	f
Desconhecido	3723	180319	f
Desconhecido	3724	180320	f
Desconhecido	3725	180321	f
Desconhecido	3726	180322	f
Desconhecido	3727	180401	f
Desconhecido	3728	180402	f
Desconhecido	3729	180403	f
Desconhecido	3730	180404	f
Desconhecido	3731	180405	f
Desconhecido	3732	180406	f
Desconhecido	3733	180407	f
Desconhecido	3734	180408	f
Desconhecido	3735	180409	f
Desconhecido	3736	180410	f
Desconhecido	3737	180411	f
Desconhecido	3738	180412	f
Desconhecido	3739	180413	f
Desconhecido	3740	180414	f
Desconhecido	3741	180415	f
Desconhecido	3742	180416	f
Desconhecido	3743	180417	f
Desconhecido	3744	180501	f
Desconhecido	3745	180502	f
Desconhecido	3746	180503	f
Desconhecido	3747	180504	f
Desconhecido	3748	180505	f
Desconhecido	3749	180506	f
Desconhecido	3750	180507	f
Desconhecido	3751	180508	f
Desconhecido	3752	180509	f
Desconhecido	3753	180510	f
Desconhecido	3754	180511	f
Desconhecido	3755	180512	f
Desconhecido	3756	180513	f
Desconhecido	3757	180514	f
Desconhecido	3758	180515	f
Desconhecido	3759	180516	f
Desconhecido	3760	180517	f
Desconhecido	3761	180518	f
Desconhecido	3762	180519	f
Desconhecido	3763	180520	f
Desconhecido	3764	180521	f
Desconhecido	3765	180522	f
Desconhecido	3766	180523	f
Desconhecido	3767	180524	f
Desconhecido	3768	180601	f
Desconhecido	3769	180602	f
Desconhecido	3770	180603	f
Desconhecido	3771	180604	f
Desconhecido	3772	180605	f
Desconhecido	3773	180606	f
Desconhecido	3774	180607	f
Desconhecido	3775	180608	f
Desconhecido	3776	180609	f
Desconhecido	3777	180610	f
Desconhecido	3778	180611	f
Desconhecido	3779	180612	f
Desconhecido	3780	180613	f
Desconhecido	3781	180614	f
Desconhecido	3782	180615	f
Desconhecido	3783	180616	f
Desconhecido	3784	180617	f
Desconhecido	3785	180618	f
Desconhecido	3786	180701	f
Desconhecido	3787	180702	f
Desconhecido	3788	180703	f
Desconhecido	3789	180704	f
Desconhecido	3790	180705	f
Desconhecido	3791	180706	f
Desconhecido	3792	180707	f
Desconhecido	3793	180708	f
Desconhecido	3794	180709	f
Desconhecido	3795	180710	f
Desconhecido	3796	180711	f
Desconhecido	3797	180712	f
Desconhecido	3798	180713	f
Desconhecido	3799	180714	f
Desconhecido	3800	180715	f
Desconhecido	3801	180716	f
Desconhecido	3802	180717	f
Desconhecido	3803	180718	f
Desconhecido	3804	180719	f
Desconhecido	3805	180720	f
Desconhecido	3806	180801	f
Desconhecido	3807	180802	f
Desconhecido	3808	180803	f
Desconhecido	3809	180804	f
Desconhecido	3810	180805	f
Desconhecido	3811	180806	f
Desconhecido	3812	180807	f
Desconhecido	3813	180808	f
Desconhecido	3814	180809	f
Desconhecido	3815	180810	f
Desconhecido	3816	180901	f
Desconhecido	3817	180902	f
Desconhecido	3818	180903	f
Desconhecido	3819	180904	f
Desconhecido	3820	180905	f
Desconhecido	3821	180906	f
Desconhecido	3822	180907	f
Desconhecido	3823	180908	f
Desconhecido	3824	180909	f
Desconhecido	3825	181001	f
Desconhecido	3826	181002	f
Desconhecido	3827	181003	f
Desconhecido	3828	181004	f
Desconhecido	3829	181005	f
Desconhecido	3830	181006	f
Desconhecido	3831	181007	f
Desconhecido	3832	181008	f
Desconhecido	3833	181009	f
Desconhecido	3834	181010	f
Desconhecido	3835	181011	f
Desconhecido	3836	181012	f
Desconhecido	3837	181101	f
Desconhecido	3838	181102	f
Desconhecido	3839	181103	f
Desconhecido	3840	181104	f
Desconhecido	3841	181105	f
Desconhecido	3842	181106	f
Desconhecido	3843	181107	f
Desconhecido	3844	181108	f
Desconhecido	3845	181109	f
Desconhecido	3846	181110	f
Desconhecido	3847	181111	f
Desconhecido	3848	181112	f
Desconhecido	3849	181113	f
Desconhecido	3850	181201	f
Desconhecido	3851	181202	f
Desconhecido	3852	181203	f
Desconhecido	3853	181204	f
Desconhecido	3854	181205	f
Desconhecido	3855	181206	f
Desconhecido	3856	181207	f
Desconhecido	3857	181208	f
Desconhecido	3858	181209	f
Desconhecido	3859	181301	f
Desconhecido	3860	181302	f
Desconhecido	3861	181303	f
Desconhecido	3862	181304	f
Desconhecido	3863	181305	f
Desconhecido	3864	181306	f
Desconhecido	3865	181307	f
Desconhecido	3866	181308	f
Desconhecido	3867	181309	f
Desconhecido	3868	181310	f
Desconhecido	3869	181311	f
Desconhecido	3870	181312	f
Desconhecido	3871	181313	f
Desconhecido	3872	181314	f
Desconhecido	3873	181315	f
Desconhecido	3874	181401	f
Desconhecido	3875	181402	f
Desconhecido	3876	181403	f
Desconhecido	3877	181404	f
Desconhecido	3878	181405	f
Desconhecido	3879	181406	f
Desconhecido	3880	181407	f
Desconhecido	3881	181408	f
Desconhecido	3882	181409	f
Desconhecido	3883	181501	f
Desconhecido	3884	181502	f
Desconhecido	3885	181503	f
Desconhecido	3886	181504	f
Desconhecido	3887	181505	f
Desconhecido	3888	181506	f
Desconhecido	3889	181507	f
Desconhecido	3890	181508	f
Desconhecido	3891	181509	f
Desconhecido	3892	181510	f
Desconhecido	3893	181511	f
Desconhecido	3894	181512	f
Desconhecido	3895	181513	f
Desconhecido	3896	181514	f
Desconhecido	3897	181601	f
Desconhecido	3898	181602	f
Desconhecido	3899	181603	f
Desconhecido	3900	181604	f
Desconhecido	3901	181605	f
Desconhecido	3902	181606	f
Desconhecido	3903	181607	f
Desconhecido	3904	181608	f
Desconhecido	3905	181609	f
Desconhecido	3906	181610	f
Desconhecido	3907	181611	f
Desconhecido	3908	181612	f
Desconhecido	3909	181613	f
Desconhecido	3910	181614	f
Desconhecido	3911	181615	f
Desconhecido	3912	181616	f
Desconhecido	3913	181617	f
Desconhecido	3914	181618	f
Desconhecido	3915	181619	f
Desconhecido	3916	181701	f
Desconhecido	3917	181702	f
Desconhecido	3918	181703	f
Desconhecido	3919	181704	f
Desconhecido	3920	181705	f
Desconhecido	3921	181706	f
Desconhecido	3922	181707	f
Desconhecido	3923	181708	f
Desconhecido	3924	181709	f
Desconhecido	3925	181710	f
Desconhecido	3926	181711	f
Desconhecido	3927	181712	f
Desconhecido	3928	181801	f
Desconhecido	3929	181802	f
Desconhecido	3930	181803	f
Desconhecido	3931	181804	f
Desconhecido	3932	181805	f
Desconhecido	3933	181806	f
Desconhecido	3934	181807	f
Desconhecido	3935	181808	f
Desconhecido	3936	181809	f
Desconhecido	3937	181810	f
Desconhecido	3938	181811	f
Desconhecido	3939	181812	f
Desconhecido	3940	181813	f
Desconhecido	3941	181814	f
Desconhecido	3942	181815	f
Desconhecido	3943	181816	f
Desconhecido	3944	181817	f
Desconhecido	3945	181901	f
Desconhecido	3946	181902	f
Desconhecido	3947	181903	f
Desconhecido	3948	181904	f
Desconhecido	3949	181905	f
Desconhecido	3950	181906	f
Desconhecido	3951	181907	f
Desconhecido	3952	181908	f
Desconhecido	3953	181909	f
Desconhecido	3954	181910	f
Desconhecido	3955	181911	f
Desconhecido	3956	181912	f
Desconhecido	3957	181913	f
Desconhecido	3958	181914	f
Desconhecido	3959	181915	f
Desconhecido	3960	181916	f
Desconhecido	3961	181917	f
Desconhecido	3962	182001	f
Desconhecido	3963	182002	f
Desconhecido	3964	182003	f
Desconhecido	3965	182004	f
Desconhecido	3966	182005	f
Desconhecido	3967	182006	f
Desconhecido	3968	182007	f
Desconhecido	3969	182008	f
Desconhecido	3970	182009	f
Desconhecido	3971	182010	f
Desconhecido	3972	182101	f
Desconhecido	3973	182102	f
Desconhecido	3974	182103	f
Desconhecido	3975	182104	f
Desconhecido	3976	182105	f
Desconhecido	3977	182106	f
Desconhecido	3978	182107	f
Desconhecido	3979	182108	f
Desconhecido	3980	182109	f
Desconhecido	3981	182110	f
Desconhecido	3982	182111	f
Desconhecido	3983	182112	f
Desconhecido	3984	182113	f
Desconhecido	3985	182114	f
Desconhecido	3986	182115	f
Desconhecido	3987	182116	f
Desconhecido	3988	182117	f
Desconhecido	3989	182118	f
Desconhecido	3990	182119	f
Desconhecido	3991	182120	f
Desconhecido	3992	182121	f
Desconhecido	3993	182122	f
Desconhecido	3994	182123	f
Desconhecido	3995	182124	f
Desconhecido	3996	182125	f
Desconhecido	3997	182126	f
Desconhecido	3998	182201	f
Desconhecido	3999	182202	f
Desconhecido	4000	182203	f
Desconhecido	4001	182204	f
Desconhecido	4002	182205	f
Desconhecido	4003	182206	f
Desconhecido	4004	182207	f
Desconhecido	4005	182301	f
Desconhecido	4006	182302	f
Desconhecido	4007	182303	f
Desconhecido	4008	182304	f
Desconhecido	4009	182305	f
Desconhecido	4010	182306	f
Desconhecido	4011	182307	f
Desconhecido	4012	182308	f
Desconhecido	4013	182309	f
Desconhecido	4014	182310	f
Desconhecido	4015	182311	f
Desconhecido	4016	182312	f
Desconhecido	4017	182313	f
Desconhecido	4018	182314	f
Desconhecido	4019	182315	f
Desconhecido	4020	182316	f
Desconhecido	4021	182317	f
Desconhecido	4022	182318	f
Desconhecido	4023	182319	f
Desconhecido	4024	182320	f
Desconhecido	4025	182321	f
Desconhecido	4026	182322	f
Desconhecido	4027	182323	f
Desconhecido	4028	182324	f
Desconhecido	4029	182325	f
Desconhecido	4030	182326	f
Desconhecido	4031	182327	f
Desconhecido	4032	182328	f
Desconhecido	4033	182329	f
Desconhecido	4034	182330	f
Desconhecido	4035	182331	f
Desconhecido	4036	182332	f
Desconhecido	4037	182333	f
Desconhecido	4038	182334	f
Desconhecido	4039	182401	f
Desconhecido	4040	182402	f
Desconhecido	4041	182403	f
Desconhecido	4042	182404	f
Desconhecido	4043	182405	f
Desconhecido	4044	182406	f
Desconhecido	4045	182407	f
Desconhecido	4046	182408	f
Desconhecido	4047	182409	f
Desconhecido	4048	182410	f
Desconhecido	4049	182411	f
Desconhecido	4050	182412	f
Desconhecido	4051	310101	f
Desconhecido	4052	310102	f
Desconhecido	4053	310103	f
Desconhecido	4054	310104	f
Desconhecido	4055	310105	f
Desconhecido	4056	310106	f
Desconhecido	4057	310107	f
Desconhecido	4058	310108	f
Desconhecido	4059	310201	f
Desconhecido	4060	310202	f
Desconhecido	4061	310203	f
Desconhecido	4062	310204	f
Desconhecido	4063	310205	f
Desconhecido	4064	310301	f
Desconhecido	4065	310302	f
Desconhecido	4066	310303	f
Desconhecido	4067	310304	f
Desconhecido	4068	310305	f
Desconhecido	4069	310306	f
Desconhecido	4070	310307	f
Desconhecido	4071	310308	f
Desconhecido	4072	310309	f
Desconhecido	4073	310310	f
Desconhecido	4074	310401	f
Desconhecido	4075	310402	f
Desconhecido	4076	310403	f
Desconhecido	4077	310404	f
Desconhecido	4078	310405	f
Desconhecido	4079	310501	f
Desconhecido	4080	310502	f
Desconhecido	4081	310503	f
Desconhecido	4082	310601	f
Desconhecido	4083	310602	f
Desconhecido	4084	310603	f
Desconhecido	4085	310604	f
Desconhecido	4086	310701	f
Desconhecido	4087	310702	f
Desconhecido	4088	310703	f
Desconhecido	4089	310704	f
Desconhecido	4090	310802	f
Desconhecido	4091	310803	f
Desconhecido	4092	310804	f
Desconhecido	4093	310805	f
Desconhecido	4094	310806	f
Desconhecido	4095	310901	f
Desconhecido	4096	310902	f
Desconhecido	4097	310903	f
Desconhecido	4098	310904	f
Desconhecido	4099	310905	f
Desconhecido	4100	310906	f
Desconhecido	4101	311001	f
Desconhecido	4102	311002	f
Desconhecido	4103	311003	f
Desconhecido	4104	320101	f
Desconhecido	4105	410101	f
Desconhecido	4106	410102	f
Desconhecido	4107	410103	f
Desconhecido	4108	410104	f
Desconhecido	4109	410105	f
Desconhecido	4110	420101	f
Desconhecido	4111	420102	f
Desconhecido	4112	420103	f
Desconhecido	4113	420104	f
Desconhecido	4114	420105	f
Desconhecido	4115	420201	f
Desconhecido	4116	420202	f
Desconhecido	4117	420203	f
Desconhecido	4118	420204	f
Desconhecido	4119	420206	f
Desconhecido	4120	420207	f
Desconhecido	4121	420208	f
Desconhecido	4122	420209	f
Desconhecido	4123	420210	f
Desconhecido	4124	420301	f
Desconhecido	4125	420303	f
Desconhecido	4126	420304	f
Desconhecido	4127	420305	f
Desconhecido	4128	420306	f
Desconhecido	4129	420307	f
Desconhecido	4130	420308	f
Desconhecido	4131	420309	f
Desconhecido	4132	420310	f
Desconhecido	4133	420311	f
Desconhecido	4134	420312	f
Desconhecido	4135	420313	f
Desconhecido	4136	420314	f
Desconhecido	4137	420315	f
Desconhecido	4138	420316	f
Desconhecido	4139	420317	f
Desconhecido	4140	420318	f
Desconhecido	4141	420319	f
Desconhecido	4142	420320	f
Desconhecido	4143	420321	f
Desconhecido	4144	420322	f
Desconhecido	4145	420323	f
Desconhecido	4146	420324	f
Desconhecido	4147	420325	f
Desconhecido	4148	420401	f
Desconhecido	4149	420402	f
Desconhecido	4150	420403	f
Desconhecido	4151	420404	f
Desconhecido	4152	420405	f
Desconhecido	4153	420406	f
Desconhecido	4154	420501	f
Desconhecido	4155	420502	f
Desconhecido	4156	420503	f
Desconhecido	4157	420504	f
Desconhecido	4158	420505	f
Desconhecido	4159	420506	f
Desconhecido	4160	420507	f
Desconhecido	4161	420508	f
Desconhecido	4162	420509	f
Desconhecido	4163	420510	f
Desconhecido	4164	420511	f
Desconhecido	4165	420512	f
Desconhecido	4166	420513	f
Desconhecido	4167	420514	f
Desconhecido	4168	420601	f
Desconhecido	4169	420602	f
Desconhecido	4170	420603	f
Desconhecido	4171	420604	f
Desconhecido	4172	420605	f
Desconhecido	4173	420606	f
Desconhecido	4174	430101	f
Desconhecido	4175	430102	f
Desconhecido	4176	430103	f
Desconhecido	4177	430104	f
Desconhecido	4178	430105	f
Desconhecido	4179	430106	f
Desconhecido	4180	430107	f
Desconhecido	4181	430108	f
Desconhecido	4182	430109	f
Desconhecido	4183	430110	f
Desconhecido	4184	430111	f
Desconhecido	4185	430112	f
Desconhecido	4186	430113	f
Desconhecido	4187	430114	f
Desconhecido	4188	430115	f
Desconhecido	4189	430116	f
Desconhecido	4190	430117	f
Desconhecido	4191	430118	f
Desconhecido	4192	430119	f
Desconhecido	4193	430201	f
Desconhecido	4194	430202	f
Desconhecido	4195	430203	f
Desconhecido	4196	430204	f
Desconhecido	4197	430205	f
Desconhecido	4198	430206	f
Desconhecido	4199	430207	f
Desconhecido	4200	430208	f
Desconhecido	4201	430209	f
Desconhecido	4202	430210	f
Desconhecido	4203	430211	f
Desconhecido	4204	440101	f
Desconhecido	4205	440102	f
Desconhecido	4206	440103	f
Desconhecido	4207	440104	f
Desconhecido	4208	450101	f
Desconhecido	4209	450102	f
Desconhecido	4210	450103	f
Desconhecido	4211	450104	f
Desconhecido	4212	450105	f
Desconhecido	4213	450201	f
Desconhecido	4214	450202	f
Desconhecido	4215	450203	f
Desconhecido	4216	450204	f
Desconhecido	4217	450205	f
Desconhecido	4218	450206	f
Desconhecido	4219	460101	f
Desconhecido	4220	460102	f
Desconhecido	4221	460103	f
Desconhecido	4222	460104	f
Desconhecido	4223	460105	f
Desconhecido	4224	460106	f
Desconhecido	4225	460201	f
Desconhecido	4226	460202	f
Desconhecido	4227	460203	f
Desconhecido	4228	460204	f
Desconhecido	4229	460205	f
Desconhecido	4230	460206	f
Desconhecido	4231	460301	f
Desconhecido	4232	460302	f
Desconhecido	4233	460303	f
Desconhecido	4234	460304	f
Desconhecido	4235	460305	f
Desconhecido	4236	470101	f
Desconhecido	4237	470102	f
Desconhecido	4238	470103	f
Desconhecido	4239	470104	f
Desconhecido	4240	470105	f
Desconhecido	4241	470106	f
Desconhecido	4242	470107	f
Desconhecido	4243	470108	f
Desconhecido	4244	470109	f
Desconhecido	4245	470110	f
Desconhecido	4246	470111	f
Desconhecido	4247	470112	f
Desconhecido	4248	470113	f
Desconhecido	4249	480101	f
Desconhecido	4250	480102	f
Desconhecido	4251	480103	f
Desconhecido	4252	480104	f
Desconhecido	4253	480105	f
Desconhecido	4254	480106	f
Desconhecido	4255	480107	f
Desconhecido	4256	480201	f
Desconhecido	4257	480202	f
Desconhecido	4258	480203	f
Desconhecido	4259	480204	f
Desconhecido	4260	490101	f
Desconhecido	4261	490102	f
Desconhecido	4262	490103	f
Desconhecido	4263	490104	f
Desconhecido	4264	490105	f
Desconhecido	4265	490106	f
Desconhecido	4266	490107	f
Desconhecido	4267	490108	f
Desconhecido	4268	490109	f
Desconhecido	4269	490110	f
Desconhecido	4270	490111	f
Desconhecido	4271	490112	f
Desconhecido	4272	490113	f
Desconhecido	4273	490114	f
Desconhecido	4274	490115	f
Desconhecido	4275	490116	f
Desconhecido	4276	490117	f
Desconhecido	4277	490118	f
Desconhecido	4278	490119	f
Desconhecido	4279	490120	f
Desconhecido	4280	490121	f
Desconhecido	4281	490122	f
Desconhecido	4282	490123	f
Desconhecido	4283	490124	f
Desconhecido	4284	490125	f
Desconhecido	4285	490126	f
Desconhecido	4286	490127	f
Desconhecido	4287	490128	f
Desconhecido	4288	490129	f
Desconhecido	4289	490130	f
Desconhecido	4290	490131	f
Desconhecido	4291	490132	f
Desconhecido	4292	490133	f
Desconhecido	4293	490134	f
Desconhecido	4294	490135	f
Desconhecido	4295	490136	f
Desconhecido	4296	490137	f
Desconhecido	4297	490138	f
Desconhecido	4298	490139	f
Desconhecido	4299	490140	f
Desconhecido	4300	490141	f
Desconhecido	4301	490142	f
Desconhecido	4302	490143	f
Desconhecido	4303	490144	f
Desconhecido	4304	490145	f
Desconhecido	4305	490146	f
Desconhecido	4306	490147	f
Desconhecido	4307	490148	f
Desconhecido	4308	490149	f
Desconhecido	4309	490150	f
Desconhecido	4310	490151	f
Desconhecido	4311	490152	f
Desconhecido	4312	490153	f
Desconhecido	4313	490154	f
Desconhecido	4314	490155	f
Desconhecido	4315	490156	f
Desconhecido	4316	490157	f
Desconhecido	4317	490158	f
Desconhecido	4318	490159	f
Desconhecido	4319	490160	f
Desconhecido	4320	490161	f
Desconhecido	4321	490162	f
Desconhecido	4322	490163	f
Desconhecido	4323	490164	f
Desconhecido	4324	490165	f
Desconhecido	4325	490166	f
Desconhecido	4326	490167	f
Desconhecido	4327	490168	f
Desconhecido	4328	490169	f
Desconhecido	4329	490170	f
Desconhecido	4330	490171	f
Desconhecido	4331	490172	f
Desconhecido	4332	490173	f
Desconhecido	4333	490174	f
Desconhecido	4334	490175	f
Desconhecido	4335	490176	f
Desconhecido	4336	490177	f
Desconhecido	4337	490178	f
Desconhecido	4338	490179	f
Desconhecido	4339	490180	f
Desconhecido	4340	490181	f
Desconhecido	4341	490182	f
Desconhecido	4342	490183	f
Desconhecido	4343	490184	f
Desconhecido	4344	490185	f
Desconhecido	4345	490186	f
Desconhecido	4346	490187	f
Desconhecido	4347	490188	f
Desconhecido	4348	490189	f
Desconhecido	4349	490190	f
Desconhecido	4350	490191	f
Desconhecido	4351	490192	f
Desconhecido	4352	490193	f
Desconhecido	4353	490194	f
Desconhecido	4354	490195	f
Desconhecido	4355	490196	f
Desconhecido	4356	490197	f
Desconhecido	4357	490198	f
Desconhecido	4358	490199	f
Desconhecido	4359	490200	f
Desconhecido	4360	490201	f
Desconhecido	4361	490202	f
Desconhecido	4362	490203	f
Desconhecido	4363	490204	f
Desconhecido	4364	490205	f
Desconhecido	4365	490206	f
Desconhecido	4366	490207	f
Desconhecido	4367	490208	f
Desconhecido	4368	490209	f
Desconhecido	4369	490210	f
Desconhecido	4370	490211	f
Desconhecido	4371	490212	f
Desconhecido	4372	490213	f
Desconhecido	4373	490214	f
Desconhecido	4374	490215	f
Desconhecido	4375	490216	f
Desconhecido	4376	490217	f
Desconhecido	4377	490218	f
Desconhecido	4378	490219	f
Desconhecido	4379	490220	f
Desconhecido	4380	490221	f
Desconhecido	4381	490222	f
Desconhecido	4382	490223	f
Desconhecido	4383	490224	f
Desconhecido	4384	490225	f
Desconhecido	4385	490226	f
Desconhecido	4386	490227	f
Desconhecido	4387	490228	f
Desconhecido	4388	490229	f
Desconhecido	4389	490230	f
Desconhecido	4390	490231	f
Desconhecido	4391	490232	f
Desconhecido	4392	490233	f
Desconhecido	4393	490234	f
Desconhecido	4394	490235	f
Desconhecido	4395	490236	f
Desconhecido	4396	490237	f
Desconhecido	4397	490238	f
Desconhecido	4398	490239	f
Desconhecido	4399	490240	f
Desconhecido	4400	490241	f
Desconhecido	4401	490242	f
Desconhecido	4402	490243	f
Desconhecido	4403	490244	f
Desconhecido	4404	490245	f
Desconhecido	4405	490246	f
Desconhecido	4406	490247	f
Desconhecido	4407	490248	f
Desconhecido	4408	490249	f
Desconhecido	4409	490250	f
Desconhecido	4410	490251	f
Desconhecido	4411	490252	f
Desconhecido	4412	490253	f
Desconhecido	4413	490254	f
Desconhecido	4414	490255	f
Desconhecido	4415	490256	f
Desconhecido	4416	490257	f
Desconhecido	4417	490258	f
Desconhecido	4418	490259	f
Desconhecido	4419	490260	f
Desconhecido	4420	490261	f
Desconhecido	4421	490262	f
Desconhecido	4422	490263	f
Desconhecido	4423	490264	f
Desconhecido	4424	490265	f
Desconhecido	4425	490266	f
Desconhecido	4426	490267	f
Desconhecido	4427	490268	f
Desconhecido	4428	490269	f
Desconhecido	4429	490270	f
Desconhecido	4430	490271	f
Desconhecido	4431	490272	f
Desconhecido	4432	490273	f
Desconhecido	4433	490274	f
Desconhecido	4434	490275	f
Desconhecido	4435	490276	f
Desconhecido	4436	490277	f
Desconhecido	4437	490278	f
Desconhecido	4438	490279	f
Desconhecido	4439	490280	f
Desconhecido	4440	490281	f
Desconhecido	4441	490282	f
Desconhecido	4442	490283	f
Desconhecido	4443	490284	f
Desconhecido	4444	490285	f
Desconhecido	4445	490286	f
Desconhecido	4446	490287	f
Desconhecido	4447	490288	f
Desconhecido	4448	490289	f
Desconhecido	4449	490290	f
Desconhecido	4450	490291	f
Desconhecido	4451	490292	f
Desconhecido	4452	490293	f
Desconhecido	4453	490294	f
Desconhecido	4454	490295	f
Desconhecido	4455	490296	f
Desconhecido	4456	490297	f
Desconhecido	4457	490298	f
Desconhecido	4458	490299	f
Desconhecido	4459	490300	f
Desconhecido	4460	490301	f
Desconhecido	4461	490302	f
Desconhecido	4462	490303	f
Desconhecido	4463	490304	f
Desconhecido	4464	490305	f
Desconhecido	4465	490306	f
Desconhecido	4466	490307	f
Desconhecido	4467	490308	f
Desconhecido	4468	490309	f
Desconhecido	4469	490310	f
Desconhecido	4470	490311	f
Desconhecido	4471	490312	f
Desconhecido	4472	490313	f
Desconhecido	4473	490314	f
Desconhecido	4474	490315	f
Desconhecido	4475	490316	f
Desconhecido	4476	490317	f
Desconhecido	4477	490318	f
Desconhecido	4478	490319	f
Desconhecido	4479	490320	f
Desconhecido	4480	490321	f
Desconhecido	4481	490322	f
Desconhecido	4482	490323	f
Desconhecido	4483	490324	f
Desconhecido	4484	490325	f
Desconhecido	4485	490326	f
Desconhecido	4486	490327	f
Desconhecido	4487	490328	f
Desconhecido	4488	490329	f
Desconhecido	4489	490330	f
Desconhecido	4490	490331	f
Desconhecido	4491	490332	f
Desconhecido	4492	490333	f
Desconhecido	4493	490334	f
Desconhecido	4494	490335	f
Desconhecido	4495	490336	f
Desconhecido	4496	490337	f
Desconhecido	4497	490338	f
Desconhecido	4498	490339	f
Desconhecido	4499	490340	f
Desconhecido	4500	490341	f
Desconhecido	4501	490342	f
Desconhecido	4502	490343	f
Desconhecido	4503	490344	f
Desconhecido	4504	490345	f
Desconhecido	4505	490346	f
Desconhecido	4506	490347	f
Desconhecido	4507	490348	f
Desconhecido	4508	490349	f
Desconhecido	4509	490350	f
Desconhecido	4510	490351	f
Desconhecido	4511	490352	f
Desconhecido	4512	490353	f
Desconhecido	4513	490354	f
Desconhecido	4514	490355	f
Desconhecido	4515	490356	f
Desconhecido	4516	490357	f
Desconhecido	4517	490358	f
Desconhecido	4518	490359	f
Desconhecido	4519	490360	f
Desconhecido	4520	490361	f
Desconhecido	4521	490362	f
Desconhecido	4522	490363	f
Desconhecido	4523	490364	f
Desconhecido	4524	490365	f
Desconhecido	4525	490366	f
Desconhecido	4526	490367	f
Desconhecido	4527	490368	f
Desconhecido	4528	490369	f
Desconhecido	4529	490370	f
Desconhecido	4530	490371	f
Desconhecido	4531	490372	f
Desconhecido	4532	490373	f
Desconhecido	4533	490374	f
Desconhecido	4534	490375	f
Desconhecido	4535	490376	f
Desconhecido	4536	490377	f
Desconhecido	4537	490378	f
Desconhecido	4538	490379	f
Desconhecido	4539	490380	f
Desconhecido	4540	490381	f
Desconhecido	4541	490382	f
Desconhecido	4542	490383	f
Desconhecido	4543	490384	f
Desconhecido	4544	490385	f
Desconhecido	4545	490386	f
Desconhecido	4546	490387	f
Desconhecido	4547	490388	f
Desconhecido	4548	490389	f
Desconhecido	4549	490390	f
Desconhecido	4550	490391	f
Desconhecido	4551	490392	f
Desconhecido	4552	490393	f
Desconhecido	4553	490394	f
Desconhecido	4554	490395	f
Desconhecido	4555	490396	f
Desconhecido	4556	490397	f
Desconhecido	4557	490398	f
Desconhecido	4558	490399	f
Desconhecido	4559	490400	f
Desconhecido	4560	490401	f
Desconhecido	4561	490402	f
Desconhecido	4562	490403	f
Desconhecido	4563	490404	f
Desconhecido	4564	490405	f
Desconhecido	4565	490406	f
Desconhecido	4566	490407	f
Desconhecido	4567	490408	f
Desconhecido	4568	490409	f
Desconhecido	4570	490411	f
Desconhecido	4571	490412	f
Desconhecido	4572	490413	f
Desconhecido	4573	490414	f
Desconhecido	4574	490415	f
Desconhecido	4575	490416	f
Desconhecido	4576	490417	f
Desconhecido	4577	490418	f
Desconhecido	4578	490419	f
Desconhecido	4579	490420	f
Desconhecido	4580	490421	f
Desconhecido	4581	490422	f
Desconhecido	4582	490423	f
Desconhecido	4583	490424	f
Desconhecido	4584	490425	f
Desconhecido	4585	490426	f
Desconhecido	4586	490427	f
Desconhecido	4587	490428	f
Desconhecido	4588	490429	f
Desconhecido	4589	490430	f
Desconhecido	4590	490431	f
Desconhecido	4591	490432	f
Desconhecido	4592	490433	f
Desconhecido	4593	490434	f
Desconhecido	4594	490435	f
Desconhecido	4595	490436	f
Desconhecido	4596	490437	f
Desconhecido	4597	490438	f
Desconhecido	4598	490439	f
Desconhecido	4769	490610	f
Castanheiro	4842	40305	f
Rocio de Pardelhas	4843	30709	f
Rua de Baixo	4844	30709	f
Vila Cova	4845	180618	f
Várzea de Tavares	4846	180618	f
Duas Igrejas, Vila Verde	5845	31339	f
Rio Mau, Vila Verde	5846	31339	f
Duas Igrejas, Vila Verde	5847	31314	f
Fiscal, Amares	5848	30111	f
Viatodos, Barcelos	5849	30284	f
Goães, Vila Verde	5850	31318	f
Moega	5851	31339	f
Pinheiro de Baixo	5852	31339	f
Vinhal	5853	31339	f
Moimenta, Terras de Bouro	5854	31010	f
Feira Nova	5855	31339	f
Rebordões (Souto)	5856	160747	f
Cabo	5857	31339	f
Sins	5858	31339	f
Casa da Pena	5859	31339	f
Ruivos (Santa Eulália)	5860	160617	f
Ermida	5861	31339	f
Viso	5862	31339	f
Burral	5863	31339	f
Pinheiro de Cima	5864	31339	f
Lameirinhas	5865	31339	f
Castanheiro da Feira	5866	31339	f
Carreiro	5867	31339	f
Talhô	5868	31339	f
Hospital de S. Marcos	5869	30342	f
Mourão	5870	31339	f
Moinho da Pena	5871	31339	f
Sernades	5872	31339	f
Aveleira	5873	31339	f
Passal	5874	31339	f
Casa da Zenha	5875	31339	f
Barreiro (Viso)	5876	31339	f
Sobrado	5877	31339	f
Guilhamil	5878	31339	f
Ribadal	5879	31339	f
Crasto	5880	160739	f
Veiga	5881	31339	f
Côto das Cruzes	5882	31339	f
Capelães	5883	31339	f
Igreja	5884	31339	f
Têso (Cabo)	5885	31339	f
Pedreira	5886	31339	f
Casa do Mourão	5887	31339	f
Mato	5888	31339	f
Corredoura	5889	31339	f
Roibal	5891	31339	f
Hospital de S. Marcos	5892	30341	f
Casal Diogo	5893	30502	f
Lugar da Vinha	5894	30504	f
Ribeira	5895	30504	f
Lordelo	5896	30522	f
Crespos	5897	30504	f
Pereira	5898	30504	f
Lugar do Casal	5899	30504	f
Britelo	5900	30504	f
Vilar	5901	30512	f
Laje	5902	30512	f
Cruzeiro	5903	30504	f
Carril	5904	30504	f
Seixomil	5905	30504	f
Paço	5906	30516	f
Cruz	5907	30504	f
Corujeira	5908	30512	f
Corredoura	5909	30502	f
Venda Nova	5910	30504	f
Quinta de Santo Andou	5911	30502	f
Freixieiro	5912	30504	f
Vilarinho	5913	170508	f
Nogueira	5914	30512	f
Cabo	5915	30504	f
Lamas	5916	30512	f
Enxertos	5917	30504	f
Lameiros	5918	30414	f
Burguete	5919	30504	f
Mosqueiros	5920	30504	f
Lugar do Prado	5921	30504	f
Ponte	5922	30504	f
Fareleira	5923	30504	f
Canelha	5924	30504	f
Lamardeiro	5926	30502	f
Outeiro da Ribeira	5927	30504	f
Travassinhos	5928	30502	f
Casal	5929	30504	f
Crasto	5930	30504	f
Seturrada	5931	30504	f
Adoulfe	5932	30504	f
Paixão	5933	30504	f
Souto	5934	30504	f
Outeiral	5935	30504	f
Covas	5936	30507	f
Tanque	5937	30504	f
Santa Maria de Galegos	5938	160815	f
São Cristovão	5939	490346	f
Lugar de Loureiro	5940	30512	f
Lugar da Raposeira	5941	30521	f
Basto	5942	30505	f
Corgo	5943	30509	f
Paço	5944	30504	f
Prado	5945	30504	f
Cerdeirinha	5946	30522	f
São Cristovão de Mondim	5947	170505	f
São Martinho	5948	30519	f
Vila	5949	30504	f
Vilalva	5950	30502	f
Toutaim	5951	30519	f
Souto Maior	5952	30502	f
Cerdeiredo	5953	30522	f
Adoufe	5954	30512	f
Lugar de Vila Pouca	5955	30502	f
Vilar de Ferreiros	5956	170508	f
Fervença	5957	30510	f
Pousadouro	5958	170505	f
Outeiro	5959	30504	f
Souto	5960	30502	f
Refalcão	5961	30404	f
Lama	5962	30512	f
Vinha	5963	30504	f
Carril	5964	30502	f
Silvares	5965	30507	f
Arnoia	5966	30502	f
Sela	5967	30504	f
Lugar do Castelo	5968	30502	f
Rego	5969	30506	f
Telhado	5970	30505	f
Igreja	5971	130324	f
Doroso	5972	30723	f
Carrazedo	5973	30504	f
Quintã	5974	30412	f
Fafe	5975	30709	f
Monte	5976	30504	f
Carrazedo	5977	30414	f
Vila Nova	5978	30504	f
Lordelo	5979	30518	f
Tornadouro	5980	30502	f
Veade	5981	30522	f
Mondim	5982	170505	f
Arcos	5983	30504	f
Taipa	5984	30502	f
Prelada	5985	30510	f
Cerqueda	5986	30502	f
Fijô	5987	30502	f
Sarrazinhos	5988	30502	f
Seixomil	5989	30502	f
Enchouzela	5990	30505	f
Torre	5991	30730	f
Lourido	5992	30504	f
Baldieira	5993	170508	f
Cruz de Baixo	5994	30502	f
Corredoura	5995	30504	f
Alijó	5996	30517	f
Paredes	5997	130116	f
Campo	5998	30507	f
Real	5999	30510	f
Quintela	6000	30512	f
Lage	6001	30502	f
Loureiro	6002	30512	f
Pombal	6003	30502	f
Paços	6004	171419	f
Fundoães	6005	30510	f
Fundevila	6006	30510	f
Chamiçal	6007	30505	f
Alfarela	6008	30505	f
Bouça	6009	30504	f
Vila Verde	6010	30502	f
Lourido	6011	30502	f
Vinhal	6012	30412	f
Lavandeira	6013	30519	f
Pedra Vedra	6014	170505	f
Santa Luzia	6015	30504	f
Varzigueto	6016	170504	f
Suarriba	6017	30502	f
Linhares	6018	30505	f
Chouzas	6019	30504	f
Chelo	6020	30502	f
Vila Meã	6021	130127	f
Fontela	6022	30504	f
Boucinha	6023	30502	f
Cales	6024	30513	f
Boeiros	6025	30504	f
Tenperas	6026	30502	f
Saúde	6027	30504	f
Cruz de cima	6028	30502	f
Estres	6029	130140	f
Paldeiro	6030	30505	f
Granja	6031	30502	f
Bairro	6032	30506	f
Cale	6033	30504	f
Mosteiro	6034	130302	f
Pereiró	6035	30220	f
Porto Carreiro	6036	30220	f
Pontegãos	6037	30220	f
Sobreiras	6038	30502	f
Medros	6039	30220	f
Folões	6040	30220	f
Sobreiro	6041	30516	f
Vila Chã	6042	30220	f
Bouça	6043	30220	f
Longras	6044	30220	f
Assento	6045	30220	f
Igreja	6046	30220	f
Marnota	6047	30220	f
Barge	6048	30220	f
Carcavelos	6049	30502	f
Castedo	6050	40906	f
Igreja Matriz, Castedo	6051	40906	f
Mourão	6052	41007	f
Torre de Moncorvo	6053	40916	f
Carrazeda de Ansiães	6054	40304	f
Favaios	6055	170107	f
Pinhal do Douro	6056	40318	f
Junqueira	6057	40902	f
Valtorno	6058	41016	f
Cabeça de Mouro	6061	40903	f
Touça	6062	91416	f
Sarzeda	6063	181815	f
Candedo	6064	170701	f
Seixo de Manhoses	6065	41013	f
Vilarinho da Castanheira	6066	40318	f
Fontelonga	6067	40306	f
Santo Amaro	6068	91413	f
Açoreira	6069	40901	f
Amedo	6070	40301	f
Estevais da Vilariça	6071	40906	f
Felgar	6072	40907	f
Estevais	6073	40902	f
Vide	6074	40906	f
Vide	6075	40909	f
Ferreira	6076	160508	f
lagoaça	6077	40403	f
Sendim da Serra	6078	40113	f
Pinhal do Douro	6079	40304	f
Cabeça Boa	6080	40903	f
Sendim da ribeira	6081	40102	f
Sendim da Ribeira	6082	40112	f
Mogo da Malta	6083	40310	f
Vila Chã da Montanha	6084	170116	f
Fonte Longa, Meda	6085	40907	f
Fonte Longa	6086	90906	f
Mareces	6087	30220	f
Vila de Ala	6088	40826	f
Alfandega da Fé	6089	40102	f
Salsas	6090	40239	f
Pai Penela	6091	90911	f
Estevais da Vilariça	6092	40902	f
Carviçais	6093	40905	f
Cardanha	6094	40904	f
Souto da Velha	6095	40915	f
Parambos	6096	40311	f
Rabaçal	6097	90914	f
Taíde	6098	30926	f
Eucisia,	6099	40104	f
Vila Nova de Paiva, Lamego	6100	182207	f
Seixo de Ansiães	6101	40316	f
Cedovim	6103	91403	f
Covas	6104	31312	f
Covas,Vila Verde	6105	31312	f
Sapardos, Vila Nova de Cerveira	6106	161012	f
Barqueiros	6107	170401	f
Freixo de Espada à Cinta	6108	40402	f
Casteição	6109	90904	f
Zedes	6110	40319	f
Peredo dos Castelhanos	6111	40914	f
Peredo dos Castelhanos	6112	40901	f
Oliveira do Hospital	6113	61112	f
Horta da Vilariça	6114	40909	f
Santa Maria do Souto	6115	30845	f
Santa Marinha de Arosa	6116	30802	f
Chãos,Lamego	6117	180501	f
Vila Nova de Foz Côa	6118	91417	f
Mogadouro	6119	40810	f
Valongo do azeite	6120	181512	f
Valongo do azeite, S.João da Pesqueira	6121	181512	f
Fonte Arcada	6122	30909	f
Pinhal do Douro	6123	40313	f
Larinho	6124	40910	f
Fonte de Baixo	6125	30214	f
Morais	6126	40521	f
Gouveia	6127	90616	f
Urros	6128	40917	f
Maçores	6129	40912	f
longroiva	6130	90907	f
Gouveia	6131	40107	f
Antas	6132	181201	f
Felgueiras	6133	40908	f
Marialva	6134	90908	f
Outeiro de Gatos	6135	90910	f
Santa Margarida	6136	181208	f
Valverde	6137	90113	f
Fafe	6138	30735	f
Vila Cova	6139	30735	f
Selores, Carrazedade Ansiães	6140	40317	f
Horta	6141	91407	f
R. Canto, em casa	6142	40906	f
Cabanas de Baixo	6143	40903	f
Rua Direita, Felgar	6144	40907	f
R. da Igreja	6145	40907	f
R.Santa Barbara	6146	40907	f
Quintas das Pereiras	6147	40905	f
Rua cimo do Lugar	6148	40907	f
Rua Cabo do Lugar	6149	40907	f
R. Calçada	6150	40907	f
Escalhão	6151	90406	f
Chelo	6152	30502	f
Rua Poças	6153	40907	f
Guilleiro, Trancoso	6154	91310	f
Vale do Porco	6155	90912	f
Outeiro	6156	170506	f
R Canto	6157	40907	f
Póvoa de Penedono	6158	181206	f
R. Aguadeira, Felgar	6159	40907	f
Rua do Eirô	6160	40907	f
Ourozinho	6161	181205	f
R. da Fraga	6162	40907	f
Vila Flor	6163	41017	f
Linhares, Carrazeda de Ansiães	6164	40308	f
Dornelas	6165	90105	f
Cimo de Vila	6166	170506	f
Foz do Douro, Porto	6167	131205	f
Santo Tirso	6168	30502	f
Zedes, Carrazedade Ansiães	6169	40319	f
Pereiros, Carrazeda	6170	40313	f
Pereiros,Carrazeda	6171	40312	f
R. do Escouradal	6172	40907	f
Quinta das Bandeiras,Torre Moncoovo	6173	40901	f
Quinta das Bandeiras, Torre de Moncorvo	6174	40901	f
Nespereira	6175	30521	f
Vilar de Ossos	6176	41232	f
Vale de Ladrões	6177	90916	f
Valverde	6178	40117	f
Carviçais, Torre de Moncorvo	6179	40901	f
São João da Pesqueira	6180	181508	f
R. Nova	6181	40907	f
Vila de Ala	6182	40810	f
Sarzedo	6183	180717	f
R. do Cotovelo	6184	40907	f
Feixe	6185	30519	f
Quinta de Sequeiros, Açoreira	6186	40901	f
Quinta do Campo, Açoreira	6187	40901	f
Rua do cimo do povo	6188	40901	f
Casal de Lobos	6189	30507	f
Cabris	6191	170903	f
Castelo Melhor	6192	91402	f
Freixo de Numão	6193	91406	f
Santa Cristina	6194	30522	f
Cerdeira	6195	30518	f
Rego da Barca	6196	40901	f
Eiras	6197	30504	f
Crasto	6198	130116	f
Lugar de Sequeiros	6199	40901	f
Tojal, Viseu	6200	181710	f
Vila Nova	6201	30509	f
Vila Boa	6202	30517	f
Pereira	6203	30520	f
Casinha	6204	30502	f
Muxões	6205	30511	f
Petimão	6206	30402	f
Fornos de Algodres	6207	90505	f
Meda	6208	90909	f
Comeal	6209	90405	f
Castedo, Alijó	6210	170105	f
Quintela, Sernancelhe	6211	181814	f
Melo, Gouveia	6212	90609	f
Pocico	6213	30504	f
Carvalho Verde	6214	30502	f
Ribeira	6215	30521	f
Paço	6216	30502	f
Vilar Torpim	6217	90417	f
Freixiel, Vila Flor	6218	41005	f
São João da Pesqueira	6219	91417	f
Carvalhal	6220	30515	f
Vilar de Rei	6221	40827	f
santos evos	6222	182325	f
vale de ladroes	6223	90909	f
pinhal do douro	6224	40911	f
cabeça boa	6225	40903	f
Ligares, Freixo de Espada à Cinta	6226	40404	f
larinho	6227	40911	f
lodões	6228	91417	f
Lodões	6229	91417	f
Lodões	6230	41006	f
Vilarinho da Castanheira	6231	40911	f
oviedo	6232	40911	f
oviedo	6233	40911	f
Oviedo Galiza	6234	40911	f
Castelo	6235	30502	f
Feijoal	6236	30521	f
Póvoa de Lanhoso	6237	30919	f
Torre Dona Chama	6238	40911	f
Torre de Dona Chama	6239	40730	f
Sé	6240	131214	f
Águeda, Aveiro	6241	10104	f
Póvoa de Lanhoso	6242	40911	f
Vilela	6243	30929	f
Frechas, Mirandela	6244	40716	f
Freixeda, Mirandela	6245	40717	f
Bragança	6246	40245	f
Carviçais	6247	40911	f
Benfica	6248	40911	f
Benfica-Lisboa	6249	110608	f
Ancede-Baião	6250	130201	f
lousa	6251	40911	f
vale de Ladrões	6252	40911	f
Távora, Tabuaço	6253	181915	f
Silhades	6254	40907	f
Outeiro	6255	30514	f
Ancede	6256	40911	f
Ancede-Baião	6257	40911	f
Castro Laboreiro	6258	160302	f
Barrosende	6259	130135	f
Torre de Terrenho	6260	91323	f
Quinta da Salgada	6261	40901	f
Quinta da Salgada, Açoreira	6262	40901	f
PInhal do Douro	6263	40313	f
R.Barreiros	6264	40907	f
Chaves	6265	40911	f
chaves	6266	40911	f
Castelo Branco	6267	40807	f
Ribeiro dos Moinhos	6268	40907	f
Castainço, Penadono	6269	181203	f
Almendra	6270	91401	f
Rossio	6271	40911	f
Moínhos	6272	30512	f
Vinhais	6273	40901	f
Quinta da Teixeira, Açoreira	6274	40901	f
Sequeiros	6275	30515	f
Chosendo	6276	180710	f
Cabo de Vila	6277	130135	f
Torre de Moncorvo	6278	40907	f
Casas Novas	6279	30512	f
São Mamede de Ribatua, Alijó	6280	170114	f
Barca de Alva, Escalhão	6281	90406	f
Gémeos	6282	30512	f
Miranda do Douro	6283	40608	f
Casa da Lama	6284	30512	f
Murça	6285	170705	f
Rua da Praça	6286	40907	f
São Silvestre	6287	30512	f
Rua do Prado	6288	40907	f
Castro Vicente	6289	40808	f
Nagozela	6290	181409	f
Cabeça de Mouro	6291	40911	f
Casa Nova	6292	30504	f
Vilarelhos	6293	40119	f
Nagozelo do Douro	6294	181504	f
Rua do Cantinho	6295	40907	f
Rua da Lixa	6296	130331	f
Rua Travessa	6297	40907	f
Mós	6298	40913	f
Pocinho, Vila Nova de Foz Côa	6299	91417	f
Rua da Canelha	6300	40907	f
Rua Quebra Costas	6301	40907	f
Rua Saco	6302	40907	f
Travaços	6303	30502	f
Mós do Douro	6304	91408	f
Vale de Ladroes	6305	40911	f
Melgaço	6306	40911	f
Vale de Ladrões	6310	90909	f
Rua da Fonte Nogueira	6311	40907	f
Cruzeiro	6312	30514	f
Outeiro	6313	30520	f
R. do Chafariz	6314	40907	f
Santa Marinha	6315	91215	f
Soterrada	6316	30502	f
R. Curral	6317	40907	f
São Miguel de Vilarinho	6318	40828	f
Algoso, Vimioso	6319	41101	f
R. Eira	7319	40907	f
Moreira do Rei, Trancoso	7320	91312	f
Quinta do Sardão	7321	40112	f
Muxagata, Foz Côa	7322	91410	f
Fonte Velha	7323	40907	f
Muxagata Vila Nova de Foz Côa	7324	91410	f
Piantou Oviedo Galiza	7325	40911	f
R. Forno	7326	40907	f
São Pedro de France, Viseu	7327	181710	f
São Pedro de France, Viseu	7328	182329	f
Sarzedo Moimenta da Beira	7329	40911	f
Garfe, Povoa de Lanhoso	7330	30913	f
Oliveira do Conde, Carregal do Sal	7331	180204	f
Fonte Coberta	7332	30514	f
Paradança	7333	170505	f
Quinta dos Picões	7334	40105	f
Mesão Frio	7335	170405	f
Senhora da Saúde	7336	30504	f
Padredo	7337	30506	f
Fervença	7338	30515	f
Almeida	7339	90203	f
Coriscada	7340	90905	f
Ferradosa	7341	40105	f
Aldeia de Baixo	7342	30508	f
Codeçoso	7343	30508	f
Casa da Pereira	7344	30504	f
Meirinhos	7345	40809	f
Vale das Fontes	7346	41227	f
Poiares	7347	40406	f
Chãs	7348	91404	f
ourozinho	7349	40911	f
Ourozinho	7350	40911	f
Penedono	7351	40911	f
Arnas	7352	181801	f
Cervães	7353	31309	f
Cortinhas	7354	130128	f
Tapadinha	7355	30504	f
Toro	7356	30504	f
Aguiar da Beira	7357	90101	f
Ínsua	7359	181105	f
Costa	7360	130135	f
Chãs	7361	180603	f
Chãs de Tavares	7362	180603	f
Soalheira	7363	30502	f
Lagoaça	7364	40403	f
Dornelas	7365	40911	f
Quintela	7366	130904	f
R. Debaixo das Amoreiras	7367	40907	f
R. Trás da Igreja	7368	40907	f
Arrifana	7369	10902	f
Belver	7370	40303	f
Belver	7371	40304	f
Peneira	7372	30505	f
Vale de Espinho, Sabugal	7373	91136	f
Vinha	7374	30509	f
Quinta das Quebradas	7375	40807	f
Pisão	7376	30510	f
Campo	7377	30514	f
Bornes, Macedo de Cavaleiros	7378	40505	f
Valença do Minho	7379	160815	f
Ervedosa	7380	41208	f
Quintã	7381	30505	f
Barrô	7382	181302	f
Covilhã	7383	50307	f
R. Terreiro	7384	40907	f
Vilas Boas	7385	41019	f
Mereces	7386	30213	f
Arouca	7387	10403	f
Povoa de Lanhoso	7388	40911	f
Nabo	7389	41008	f
Vila Chã	7390	170508	f
Vilar de Viando	7391	170505	f
Cabeço da Mua	7392	40907	f
Ranhados, Meda	7393	90915	f
Eido	7394	30278	f
Coral,Rio Sabor	7395	40907	f
Campo da Vinha	7396	30307	f
Fonte Arcada	7397	181808	f
Pinzio, Pinhel	7398	91018	f
Vilar Chão	7399	40118	f
Rua do Souto	7400	30307	f
Arrabalde da Estrada	7401	30285	f
Campelo	7402	30259	f
Fervença	7403	30249	f
Nozelos	7404	171214	f
Santa Comba, Lamego	7405	180521	f
Samões	7406	41010	f
Vale Frechoso	7407	41015	f
Arrabalde do Espírito Santo	7408	30285	f
Calçadas	7409	30522	f
Agrela	7410	30504	f
Calçadas	7411	30209	f
Vinha	7413	30516	f
Devesa	7414	30208	f
Presa	7415	30208	f
Monte	7416	30220	f
Gandra	7417	30213	f
Aldeia	7418	30259	f
Silgueiros	7419	30259	f
Pinheiro	7420	30208	f
Reigada	7421	90413	f
Bouça	7422	30249	f
Ribeiro	7423	30288	f
Agra	7424	30208	f
Varziela	7425	30259	f
Devesa	7426	30515	f
Pedrego	7427	30259	f
Crujães	7428	30283	f
Gandarela	7429	30520	f
Carvalheiras	7430	30521	f
Quinta da Lapa Sernacelhe	7431	181816	f
Póvoa de Santo Adrião	7432	111606	f
Eira	7434	30237	f
Jardim	7435	30220	f
Torre	7436	30263	f
Portelas	7437	30238	f
Vilar do Rei	7438	40810	f
Rua de Baixo	7439	30213	f
Portela	7440	30263	f
Vilar	7441	30263	f
Marinhão	7442	30734	f
Lobão	7443	30517	f
Carreira	7444	30208	f
Souto de Penedono	7445	181206	f
Granjal Sernancelhe	7446	181810	f
Moldes	7447	30263	f
Paredes da Beira	7448	181505	f
Rio de Moinhos	7449	70303	f
Quintão	7451	30208	f
Azevedinho	7452	30254	f
Numão	7453	91411	f
Fontelonga	7454	91317	f
Tapada	7455	30514	f
Rio Bom	7456	30515	f
Penedos	7457	30220	f
Eido	7458	30265	f
Santagões	7459	131605	f
Penedos	7460	30209	f
Socorro	7461	30208	f
S.Vicente de Mangualde da Serra	7462	90608	f
Outeiro	7464	30208	f
Monte de Baixo	7465	30220	f
Rouces	7466	160316	f
Espezes	7467	30249	f
Vilarinho dos Galegos	7468	40828	f
Carvalho	7469	30507	f
Castelo	7470	30507	f
Soutelo	7471	30518	f
Cruz	7472	30511	f
Remoinhos	7473	30504	f
Quintã	7474	30507	f
Cabreira	7475	30507	f
Monte	7476	30237	f
Medros	7477	30213	f
Moreiros	7478	30276	f
Monte de Cima	7479	30220	f
Aldeia de Cima	7480	130408	f
Bemposta	7481	30287	f
Aldeia de Cima	7482	30614	f
Pedral	7483	30407	f
Carril	8483	30509	f
Ferreiros	8484	30228	f
Salmães	8485	30502	f
Estrada	8486	30208	f
Leirós	8487	30274	f
Fraião	8488	30277	f
Areal	8489	30213	f
Fermil	8490	30522	f
Gemunde	8491	31202	f
Covas	8492	30238	f
Ferreirós	8493	30502	f
Burguete	8494	30513	f
Pai Penela	8495	180521	f
Beco R. Cabeço, lousa	8496	40911	f
Barreiro	8497	30267	f
Mesão Frio, Guimarães	8498	30830	f
Largo do Eiro, Lousa	8499	40911	f
Rebordões	8500	30513	f
R.Fonte Da Cruz, Lousa	8501	40911	f
R.Maia, Lousa	8502	40911	f
Mourão , Vila Flor	8503	41017	f
Penamacor	8504	50710	f
Águas, Sabugal	8505	91101	f
Mogo de Ansiães	8506	40304	f
Rua do Almada	8507	131212	f
R. Cabo Aldeia Lousa	8508	40911	f
Ponte da Vila	8509	30504	f
Bárrio, Ponte de Lima	8510	160735	f
Foz do Sabor	8511	40903	f
Seixas, VNFC	8512	91415	f
?, comarca de Trancoso	8513	91317	f
Hospital da Misericórdia	8514	30214	f
Casa de Saúde São João de Deus	8515	30285	f
Vale de porco, Meda	8516	90909	f
Peredo	8517	40813	f
Bárrio, Ponte de Lima	8518	160706	f
Melgaço	8519	490334	f
Naia	8521	30314	f
Poços	8523	30504	f
Alijó	8524	170101	f
São Cosme de Alrote	8525	90618	f
Vilarinho de São Romão	8527	171015	f
Vinha de Meios	8528	30509	f
Candoso, Vila Flor	8529	41003	f
Aldeia	8530	30257	f
Igreja	8531	30257	f
Baixo	8532	30314	f
Gandra	8533	30314	f
Tabuaço	8534	181914	f
Fornos	8535	40401	f
Souto , Guimarães	8536	30862	f
Horta do Douro	8539	91417	f
São Jorge	8540	30502	f
Sebadelhe	8541	91414	f
São Pedro das Ar...	8542	91417	f
Macieira	8543	181508	f
Rua, Sernancelhe	8544	181816	f
Vide, Moimenta	8545	180710	f
Peredo de Chacim	8546	40524	f
Encadada	8547	30504	f
Arnazelo	8548	91406	f
Mós	8549	181508	f
Trevões	8550	181508	f
Vila Nova de Fozcôa	8552	40906	f
Vila Nova de Fozcôa	8553	490414	f
Quintão	8555	30265	f
Cedofeita	8556	131204	f
Vila Nova de Tazem, Gouveia	8558	90621	f
Gouveia	8559	90621	f
Pinhal	8560	40911	f
Pinhal	8561	91017	f
Vilar de Ossos	8562	41235	f
Penafria	8563	40306	f
Faião	8564	180521	f
Faia	8565	180521	f
Ramada	8566	30520	f
Vilarinho da Castanheira	8567	40305	f
Miranda do Douro	8568	40606	f
Vila Flor	8569	41011	f
Comarca de Vila Real	8570	490355	f
Sobreira	8571	170705	f
Pinhal	8572	40304	f
Aguiar da Beira	8573	90106	f
Lugar Novo	8575	30512	f
Bacelo	8576	30504	f
Ferronha	8577	490367	f
Ranhados	8578	181206	f
Torre	8579	30502	f
Serrinha	8581	30508	f
Samil	8582	30510	f
Pereira	8583	30505	f
Mosteiro	8584	130117	f
Couto	8585	30514	f
Carvalhas	8586	160411	f
Sêco	8587	30504	f
Matamá	8588	30522	f
Boavista	8589	30512	f
Boucinha	8590	30522	f
São Romão	8591	30509	f
Outeiro Coelhos	8592	30502	f
Alagoa	8593	41016	f
Ferronha	8594	181206	f
Chavães	8595	181904	f
Grijó de Vale Benfeito	8596	40515	f
Fermil	8597	30511	f
Ordem	8598	130216	f
Balouta	8599	30511	f
Penedono	8600	181206	f
S. Pedro de Vale do Conde	8601	40719	f
Palheiros	8603	170705	f
Marzagão	8604	40309	f
São Salvador	8606	182330	f
Vale de Figueira	8607	181511	f
Casal	8608	30502	f
Capela	8609	30515	f
Ribeiro	8610	30506	f
Portelinha	8611	490413	f
Alcacer	8612	30502	f
Quita das Fontainhas	8613	170505	f
Quinta das Fontainhas	8614	170505	f
Rabalde	8615	30519	f
Outeiro	8616	30331	f
Refontoura	8617	30512	f
Eiras	8618	30514	f
Leira Maior	8619	30515	f
Quinta do Arco	8620	41017	f
Muxões	8621	30522	f
Cabanas de Cima	8622	40903	f
Barcelos	8623	30214	f
Reigada	8624	30519	f
Vimioso	8625	41110	f
cedaínhos	8626	490155	f
S. Lourenço	8627	40811	f
São Paio	8628	161014	f
Campos	8629	170505	f
Sra. Conceição	8630	181801	f
Barrelas	8631	182207	f
Penedo	8632	30410	f
S. Martinho	8633	91017	f
Ferreira	8634	490150	f
vila chã de Cangueiro	8635	490375	f
Samorinha	8636	490151	f
Eivados	9634	490155	f
Brinço	9635	40501	f
Gavião	9636	41013	f
Zava	9638	40810	f
Bouça	9639	30519	f
Urca	9640	30514	f
Paço	9641	130303	f
Lameira	9642	30517	f
Grupilheiras	9644	30504	f
Outeiro	9645	450103	f
Moreira	9647	91317	f
Alagoa	9648	30734	f
Montelongo	9649	30711	f
Tralhariz	9650	40305	f
Bouça	9651	30731	f
Fermil	9652	30514	f
Chãos	9653	90904	f
Vale dos Ladrões	9654	90908	f
vilar	9655	30731	f
Souto	9656	30731	f
Adeganha	9657	40902	f
Rego	9658	30731	f
Pergadas	9659	30731	f
Castanheiros	9660	30731	f
Poço	9661	30731	f
Assento	9662	30731	f
Regadas	9663	30731	f
Tabuaço	9664	160106	f
Pereira	9665	30731	f
Vilardoufe	9666	30731	f
Casa do Telhô	9667	30502	f
Eiras	9668	30517	f
Quinta	9669	30723	f
Cabanelas	9670	30503	f
Vale	10668	30704	f
Vilarinho	11668	30506	f
Cruz	11669	30731	f
Capela	11670	30504	f
Portela	11671	30731	f
Cima do Souto	11672	30731	f
São Paio	11673	30601	f
Aceição	11674	30804	f
Agra	11675	30804	f
Além	11676	30804	f
Amorosa	11677	30804	f
Anjo	11678	30804	f
Arcela	11679	30804	f
Assento	11680	30804	f
Atrás Capuchos	11681	30804	f
Azurem	11682	30804	f
Azurei Baixo	11683	30804	f
Azurei Cima	11684	30804	f
Bargas	11685	30804	f
Barregão	11686	30804	f
Barreira	11687	30804	f
Bem-lhe-vai	11688	30804	f
Boavista	11689	30804	f
Bom Retiro	11690	30804	f
Borges	11691	30804	f
Bornaria	11692	30804	f
Branquinha	11693	30804	f
Cadeia	11694	30804	f
Calçada	11695	30804	f
Calçada Santa Luzia	11696	30804	f
Calçada Sezil	11697	30804	f
Campo	11698	30804	f
Campo Salvador	11699	30804	f
Cancela	11700	30804	f
Cano	11701	30804	f
Cano das Gafas	11702	30804	f
Cano de Baixo	11703	30804	f
Cano de Cima	11704	30804	f
Capitão	11705	30804	f
Casa Capuchos	11706	30804	f
Casa Capuchos	11707	30804	f
Casa Nova	11708	30804	f
Casa Salvador	11709	30804	f
Casal Amorosa	11710	30804	f
Casal Boaventura	11711	30804	f
Casal Bornária	11712	30804	f
Casal Ceição	11713	30804	f
Casal Eira	11714	30804	f
Casal Entre Vinhas	11715	30804	f
Casal Fonte Dourada	11716	30804	f
Casal Mata Clérigos	11717	30804	f
Casal Paço	11718	30804	f
Casal Veiga	11719	30804	f
Castanheiros	11720	30804	f
Cegueira	11721	30804	f
Conceição	11722	30804	f
Cruz	11723	30804	f
Cruz Pedra	11724	30804	f
Doirada	11725	30804	f
Eira	11726	30804	f
Eira Forno	11727	30804	f
Entre os Gatos	11728	30804	f
Entre os Regatos	11729	30804	f
Entre Vinhas	11730	30804	f
Entrevinhas	11731	30804	f
Espinhosa	11732	30804	f
Feijoeira	11733	30804	f
Fonte	11734	30804	f
Fonte Arcada	11735	30804	f
Fonte Dourada	11736	30804	f
Fonte Pipa	11737	30804	f
Igreja	11738	30804	f
Largo São Sebastião	11739	30804	f
lugar Branquinha	11740	30804	f
Lugar da Pegada	11741	30804	f
Madre Deus	11742	30804	f
Madroa	11743	30804	f
Margaride	11744	30804	f
Monte	11745	30804	f
Monte Largo	11746	30804	f
Montinho	11747	30804	f
Oleiros São Vicente	11748	30804	f
Outeirinho	11749	30804	f
Outeirinho	11750	30804	f
Paço	11751	30804	f
Pedreira	11752	30804	f
Pedrosa	11753	30804	f
Pegada	11754	30804	f
Pegada Baixo	11755	30804	f
Pegada Cima	11756	30804	f
Penedo	11757	30804	f
Pinheirais	11758	30804	f
Pipa	11759	30804	f
Pombal	11760	30804	f
Ponte	11761	30804	f
Ponte Nova	11762	30804	f
Ponte Santa Luzia	11763	30804	f
Porta Garrida	11764	30804	f
Porta Nova	11765	30804	f
Porta Santo António	11766	30804	f
Portela	11767	30804	f
Portelada	11768	30804	f
Porteladinha	11769	30804	f
Pousada	11770	30804	f
Quintã	11771	30804	f
Quinta Pousada	11772	30804	f
Quinta Salvador	11773	30804	f
Quinta Torre	11774	30804	f
Rato	11775	30804	f
Ribeira	11776	30804	f
Rio	11777	30804	f
Rio Castanheiros	11778	30804	f
Rua Além Cano	11779	30804	f
Rua Cano Baixo	11780	30804	f
Rua de Santa Luzia	11781	30804	f
São Torcato	11782	30804	f
Sezil	11783	30804	f
Sezulfe	11784	30804	f
Souto Pousa	11785	30804	f
Taíde	11786	30804	f
Trás Gaia	11787	30804	f
Valé	11788	30804	f
Vargas	11789	30804	f
Veiga	11790	30804	f
Veiga Cima	11791	30804	f
Veiga Fora	11792	30804	f
Verdelho	11793	30804	f
Alvim	11794	30812	f
Azenha	11795	30812	f
Berredo	11796	30812	f
Berredo de baixo	11797	30812	f
Bessadas	11798	30812	f
Bessadas de baixo	11799	30812	f
Bessadas de cima	11800	30812	f
Boavista	11801	30812	f
Bouça	11802	30812	f
Bouça da cruz	11803	30812	f
Bouças	11804	30812	f
Calçada	11805	30812	f
Caldeiroa	11806	30812	f
Camajam	11807	30812	f
Campo da feira	11808	30812	f
Campos	11809	30812	f
Campos dos frades	11810	30812	f
Campos novos dos frades	11811	30812	f
Cantonha	11812	30812	f
Carvalhal	11813	30812	f
Casa nova	11814	30812	f
Casal de azenha	11815	30812	f
Casal do prado	11816	30812	f
Casas de Sta ana	11817	30812	f
Casas novas	11818	30812	f
Devesa	11819	30812	f
Esparis	11820	30812	f
Flores	11821	30812	f
Fonte s.roque	11822	30812	f
Formiga	11823	30812	f
Fundelo	11824	30812	f
Golpilhães	11825	30812	f
Lagares	11826	30812	f
Lavradeira	11827	30812	f
Lugares	11828	30812	f
Lugarinho	11829	30812	f
Lugarito	11830	30812	f
Margaride	11831	30812	f
Matos	11832	30812	f
Monte	11833	30812	f
Montinho	11834	30812	f
Mosteiro	11835	30812	f
Mouchica	11836	30812	f
Moutinho	11837	30812	f
Pansos	11838	30812	f
Parede	11839	30812	f
Passos	11840	30812	f
Pé de cão	11841	30812	f
Pedalão	11842	30812	f
Pinheiro	11843	30812	f
Pontido	11844	30812	f
Quinta azenha	11845	30812	f
Quinta santa ana	11846	30812	f
Residencia	11847	30812	f
Rio	11848	30812	f
Rua gatos	11849	30812	f
Santa Catarina da Serra	11850	30812	f
Santa cruz	11851	30812	f
São Mamede	11852	30812	f
São Paio	11853	30812	f
São Roque	11854	30812	f
Senhor do Seródio	11855	30812	f
Sub costa	11856	30812	f
Vilar	11857	30812	f
Além dos mortos	11858	30813	f
Além Rio	11859	30813	f
Alto da bandeira	11860	30813	f
Alto da cruz de pedra	11861	30813	f
Alto do monte	11862	30813	f
Amarilhas	11863	30813	f
Arrufina	11864	30813	f
Assento	11865	30813	f
Assento de Baixo	11866	30813	f
Atouguia	11867	30813	f
Atrás dos fornos	11868	30813	f
Barroca	11869	30813	f
Beco da trasgaia	11870	30813	f
Boavista	11871	30813	f
Bouças	11872	30813	f
Calçada	11873	30813	f
Calçada de Rabiços	11874	30813	f
Campo da Feira	11875	30813	f
Campo da vinha	11876	30813	f
Carrazeda	11877	30813	f
Carriço	11878	30813	f
Casas do monte	11879	30813	f
Casas novas	11880	30813	f
Casas Novas de Cima	11881	30813	f
Casas Novas de Rabiços	11882	30813	f
Casas Térreas	11883	30813	f
Casas Terreiras	11884	30813	f
Casas Terreiras da Cruz de Pedra	11885	30813	f
Castanheiro	11886	30813	f
Codeçal	11887	30813	f
Codeceira	11888	30813	f
Costeado	11889	30813	f
Cruz de Argola	11890	30813	f
Cruz de Cima	11891	30813	f
Cruz de Pedra	11892	30813	f
Dardos	11893	30813	f
Devesa	11894	30813	f
Eido	11895	30813	f
Eira de Cima	11896	30813	f
Eirado	11897	30813	f
Eirado de S. Lázaro	11898	30813	f
Eiras	11899	30813	f
Eiras de Baixo	11900	30813	f
Eiras de Cima	11901	30813	f
Esperança	11902	30813	f
Estrada	11903	30813	f
Estrada Nova	11904	30813	f
Estrepão	11905	30813	f
Fonte	11906	30813	f
Fonte Nova	11907	30813	f
Fontinha	11908	30813	f
Fornos	11909	30813	f
Honra	11910	30813	f
Honra de baixo	11911	30813	f
Honra de Cima	11912	30813	f
Jogo	11913	30813	f
Laços	11914	30813	f
Lages	11915	30813	f
Lages do Rio Selho	11916	30813	f
Lameiras	11917	30813	f
Lameiras	11918	30813	f
Largo da Cruz de Pedra	11919	30813	f
Largo de S. Lázaro	11920	30813	f
Leira	11921	30813	f
Lugar da fábrica	11922	30813	f
Lugar da fábrica da igreja	11923	30813	f
Lugar da fábrica do miradouro	11924	30813	f
Lugar de tranquilhos	11925	30813	f
Lugar dos Salgados	11926	30813	f
Lugar dos tranquilhos	11927	30813	f
Madroa	11928	30813	f
Mexas	11929	30813	f
Miradouro	11930	30813	f
Miradouro de baixo	11931	30813	f
Miradouro de Cima	11932	30813	f
Miradouro do Paço	11933	30813	f
Molianas	11934	30813	f
Monte	11935	30813	f
Moucos	11936	30813	f
Outeiro	11937	30813	f
Paço	11938	30813	f
Paço de cima	11939	30813	f
Pedras Alveiras	11940	30813	f
Pinheiro	11941	30813	f
Pinheiro de cima	11942	30813	f
Pisca	11943	30813	f
Pombais	11944	30813	f
Ponte	11945	30813	f
Ponte de Selho	11946	30813	f
Ponte do Carriço	11947	30813	f
Ponte Velha	11948	30813	f
Pucariça	11949	30813	f
Rabiços	11950	30813	f
Reidevides	11951	30813	f
Ribeira	11952	30813	f
Ribeira de Baixo	11953	30813	f
Ribeira de Cima	11954	30813	f
Rio de Selho	11955	30813	f
Robalo	11956	30813	f
Rua D. João I	11957	30813	f
Rua da Alegria	11958	30813	f
Rua da Caldeiroa	11959	30813	f
Rua da Estrada Nova	11960	30813	f
Rua das Pedras Alveiras	11961	30813	f
Rua de Camões	11962	30813	f
Rua de Couros	11963	30813	f
Rua de Gatos	11964	30813	f
S. Lázaro	11965	30813	f
S. Miguel	11966	30813	f
S. Miguel de Baixo	11967	30813	f
S. Miguel de Cima	11968	30813	f
S. Paio	11969	30813	f
S. Sebastião	11970	30813	f
Sabacho	11971	30813	f
Salgueiral	11972	30813	f
Selho	11973	30813	f
Souto dos Mortos	11974	30813	f
Sta. Luzia	11975	30813	f
Sto. André	11976	30813	f
Tapado	11977	30813	f
Torre	11978	30813	f
Trasgaia	11979	30813	f
Tulha	11980	30813	f
Vendas	11981	30813	f
Abelhas	11982	30815	f
Abelheiras	11983	30815	f
aguaça	11984	30815	f
Aguaça	11985	30815	f
Assento	11986	30815	f
Atouguia	11987	30815	f
Bacoreira	11988	30815	f
Bairro	11989	30815	f
Bairro de Baixo	11990	30815	f
Bairro de Cima	11991	30815	f
Barroca	11992	30815	f
Boavista	11993	30815	f
Bouça	11994	30815	f
Bouro de Baixo	11995	30815	f
Brinzel	11996	30815	f
Calçada	11997	30815	f
Calçada	11998	30815	f
Calçada de Baixo	11999	30815	f
Calçada de Cima	12000	30815	f
Caneiros	12001	30815	f
Cano	12002	30815	f
Cano de Baixo	12003	30815	f
Cano de cima	12004	30815	f
Capela	12005	30815	f
Carreira	12006	30815	f
Cãs	12007	30815	f
Cãs de Baixo	12008	30815	f
Casa Nova	12009	30815	f
Casal de Baixo	12010	30815	f
Casal Velho	12011	30815	f
Casas Novas	12012	30815	f
Castro	12013	30815	f
Certã	12014	30815	f
Chamusca	12015	30815	f
Chapada	12016	30815	f
Conceição	12017	30815	f
Conceição de Baixo	12018	30815	f
Conceição de Cima	12019	30815	f
Covilhã	12020	30815	f
Covilhã de Baixo	12021	30815	f
Covilhã de Cima	12022	30815	f
Curadeiras	12023	30815	f
Estrada	12024	30815	f
Estrada Nova	12025	30815	f
Fervenças	12026	30815	f
Fonte	12027	30815	f
Igreja	12028	30815	f
Laço	12029	30815	f
Lágea	12030	30815	f
Lágea de Baixo	12031	30815	f
Lágea de Cima	12032	30815	f
Lemos	12033	30815	f
Lemos de Cima	12034	30815	f
Loureiro	12035	30815	f
Loureiro Novo	12036	30815	f
Loureiro Velho	12037	30815	f
Mata	12038	30815	f
Mateduços	12039	30815	f
Melreira	12040	30815	f
Minotes	12041	30815	f
Moinhos	12042	30815	f
Moinhos da Covilhã	12043	30815	f
Moinhos de Caneiros	12044	30815	f
Moinhos de Castro	12045	30815	f
Moinhos de Esquerdo	12046	30815	f
Olival	12047	30815	f
Oliveiras	12048	30815	f
Outeiro	12049	30815	f
Paço	12050	30815	f
Paço de Baixo	12051	30815	f
Paço de Cima	12052	30815	f
Palheira	12053	30815	f
Palheiros	12054	30815	f
Pedra da Calçada	12055	30815	f
Penasol	12056	30815	f
Penedo	12057	30815	f
Pereiras	12058	30815	f
Pinheiro	12059	30815	f
Poça	12060	30815	f
Poço de Baixo	12061	30815	f
Ponte	12062	30815	f
Portela	12063	30815	f
Portelo	12064	30815	f
Primanças	12065	30815	f
Pulo	12066	30815	f
Quintãs	12067	30815	f
Ramada	12068	30815	f
Remolha	12069	30815	f
Ribeirinha	12070	30815	f
Roldes	12071	30815	f
Rua Vila Flor	12072	30815	f
S. Caetano	12073	30815	f
S. Gens	12074	30815	f
Selho	12075	30815	f
Selho de Baixo	12076	30815	f
selho de Cima	12077	30815	f
Sertã	12078	30815	f
Sezite	12079	30815	f
Sezite	12080	30815	f
Silveira	12081	30815	f
Souto	12082	30815	f
Toris	12083	30815	f
Tougeira	12084	30815	f
Trandes	12085	30815	f
Trandes de Baixo	12086	30815	f
Trapezido	12087	30815	f
Varanda	12088	30815	f
Varzea	12089	30815	f
Veiga	12090	30815	f
Venda da Conceição	12091	30815	f
Venda de Caneiros	12092	30815	f
Vinha	12093	30815	f
Vista Alegre	12094	30815	f
Adeganha	12095	30830	f
Adeganha	12096	30830	f
Adeganha de Baixo	12097	30830	f
Adeganha de Cima	12098	30830	f
Aldão	12099	30830	f
Aldão de Cima	12100	30830	f
Alto	12101	30830	f
Alvim	12102	30830	f
Arieiro	12103	30830	f
Assento	12104	30830	f
Azenha	12105	30830	f
Baceiro	12106	30830	f
Bairro	12107	30830	f
Barreiro	12108	30830	f
Barroca	12109	30830	f
Beganha	12110	30830	f
Belos Ares	12111	30830	f
Berredo	12112	30830	f
Berredo de Baixo	12113	30830	f
Bessados	12114	30830	f
Bessados de Baixo	12115	30830	f
Bessados de Cima	12116	30830	f
Boavista	12117	30830	f
Borralheiro	12118	30830	f
Bouça	12119	30830	f
Bouça	12120	30830	f
Calçada	12121	30830	f
Campo	12122	30830	f
Campo de Cima	12123	30830	f
Campo de Liro	12124	30830	f
Campo de Sino	12125	30830	f
Campo Grande	12126	30830	f
Campos Novos dos Frades	12127	30830	f
Cantanha	12128	30830	f
Cantanha	12129	30830	f
Cantonho	12130	30830	f
Carreira	12131	30830	f
Carvalhal	12132	30830	f
Carvalheira	12133	30830	f
Casa Nova	12134	30830	f
Casa Nova do Reguengo	12135	30830	f
Casas de Santa Ana	12136	30830	f
Casas Novas	12137	30830	f
Cavados	12138	30830	f
Codeceira	12139	30830	f
Covelinhas	12140	30830	f
Covelo	12141	30830	f
Covelos	12142	30830	f
Covelos de Cima	12143	30830	f
Cruz D´Argola	12144	30830	f
Cruzeiro	12145	30830	f
Cudeceira	12146	30830	f
Devesa	12147	30830	f
Encados	12148	30830	f
Encados de dentro	12149	30830	f
Espariz	12150	30830	f
Fofe	12151	30830	f
Fofe de Baixo	12152	30830	f
Fofe de Cima	12153	30830	f
Fofe de Riba	12154	30830	f
Fofe do Meio	12155	30830	f
Fonte	12156	30830	f
Fonte de S. Roque	12157	30830	f
Formiga	12158	30830	f
Gupilhães	12159	30830	f
Herdade	12160	30830	f
Herdade de Baixo	12161	30830	f
Herdade de Cima	12162	30830	f
Jugueiros	12163	30830	f
Lagares	12164	30830	f
Lage	12165	30830	f
Lage de Além	12166	30830	f
Lamajam	12167	30830	f
Laminhos	12168	30830	f
Logarengo	12169	30830	f
Lugarinho	12170	30830	f
Mainças	12171	30830	f
Margaride	12172	30830	f
Margaride	12173	30830	f
Margaride de Cima	12174	30830	f
Matos	12175	30830	f
Montinho	12176	30830	f
Morgado de Baixo	12177	30830	f
Mortório de Cima	12178	30830	f
Mosteiro	12179	30830	f
Mosteiro de Baixo	12180	30830	f
Mosteiro de Cima	12181	30830	f
Outeiro	12182	30830	f
Outeiro	12183	30830	f
Outeiro das Vinhas	12184	30830	f
Outeiro de Baixo	12185	30830	f
Outeiro de Cima	12186	30830	f
Outeiro de Paçó	12187	30830	f
Outeiro de Serviães	12188	30830	f
Outeiro de Sidrães	12189	30830	f
Outeiro do Telhado	12190	30830	f
Paçó	12191	30830	f
Paçó	12192	30830	f
Paçó de Baixo	12193	30830	f
Paçó de Cima	12194	30830	f
Paço de Covelos	12195	30830	f
Passo	12196	30830	f
Pé do Chão	12197	30830	f
Pedreira	12198	30830	f
Pedreira	12199	30830	f
Perlonga	12200	30830	f
Pinheiral	12201	30830	f
Pinheiro	12202	30830	f
Portela	12203	30830	f
Portela da Carreira	12204	30830	f
Portinha	12205	30830	f
Postela do Craveiro	12206	30830	f
Pousada	12207	30830	f
Prelonga	12208	30830	f
Prolonguinha	12209	30830	f
Quinta	12210	30830	f
Quinta	12211	30830	f
Quinta Baixa	12212	30830	f
Quinta da Azenha	12213	30830	f
Quinta da Torre	12214	30830	f
Quinta de Baixo	12215	30830	f
Quinta de Serviães	12216	30830	f
Quinta do Velhado	12217	30830	f
Reguengo	12218	30830	f
Ribeira	12219	30830	f
Ribeiro	12220	30830	f
Sairrão	12221	30830	f
Salgueirais	12222	30830	f
Salgueiral	12223	30830	f
Santa Ana	12224	30830	f
Santa Catarina	12225	30830	f
Santa Marinha da Costa	12226	30830	f
São Mamede	12227	30830	f
São Martinho	12228	30830	f
São Roque	12229	30830	f
Senhora da Oliveira	12230	30830	f
Serviães	12231	30830	f
Sidrães	12232	30830	f
Souto	12233	30830	f
Souto Novo	12234	30830	f
Subcosta	12235	30830	f
Telhado	12236	30830	f
Torre	12237	30830	f
Transportela	12238	30830	f
Valé	12239	30830	f
Veiga	12240	30830	f
Veiguinha	12241	30830	f
Venda	12242	30830	f
Venda da Cruz D'Argola	12243	30830	f
Venda Nova	12244	30830	f
Vilar	12245	30830	f
Vinha Velha	12246	30830	f
Vinhas	12247	30830	f
Açoutados	12248	30834	f
Além	12249	30834	f
Arco	12250	30834	f
Barreiros	12251	30834	f
Boavista	12252	30834	f
Boticas	12253	30834	f
Bringel	12254	30834	f
Calçada	12255	30834	f
Caldeiroa	12256	30834	f
Campo D. Afonso Henriques	12257	30834	f
Campo da Feira	12258	30834	f
Campo Longo	12259	30834	f
Cano	12260	30834	f
Cano de Baixo	12261	30834	f
Cano de Cima	12262	30834	f
Canto	12263	30834	f
Carrapatosa	12264	30834	f
Casa dos Contos	12265	30834	f
Casas Novas	12266	30834	f
Castanheiro	12267	30834	f
Cedofeita	12268	30834	f
Covide	12269	30834	f
Eirado do Forno	12270	30834	f
Fato	12271	30834	f
Fonte	12272	30834	f
Fonte do Abade	12273	30834	f
Fonte Santiago	12274	30834	f
Fonte Senhora Guia	12275	30834	f
Fornos	12276	30834	f
Fraga	12277	30834	f
Gado	12278	30834	f
Garcia	12279	30834	f
Gatos	12280	30834	f
Granja	12281	30834	f
Gulfilhães	12282	30834	f
Hortas	12283	30834	f
Igreja da N.Srª Oliveira	12284	30834	f
Lages	12285	30834	f
Laranjais	12286	30834	f
Largo da Misericórdia	12287	30834	f
Largo da Oliveira	12288	30834	f
Largo de São Bento	12289	30834	f
Largo do Carmo	12290	30834	f
Largo do Quintal	12291	30834	f
Largo Francisco Castelo Branco	12292	30834	f
Largo Luís de Camões	12293	30834	f
Largo Martins Sarmento	12294	30834	f
Largo Monte Trás	12295	30834	f
Largo Nossa Senhora da Guia	12296	30834	f
Leiras	12297	30834	f
Lugar Couto	12298	30834	f
Lugar da Bouça	12299	30834	f
Lugar das Eiras	12300	30834	f
Lugar Falperra	12301	30834	f
Madroa	12302	30834	f
Mano	12303	30834	f
Mercadores	12304	30834	f
Misericórdia	12305	30834	f
Molianas	12306	30834	f
Mortandeiros	12307	30834	f
Olival	12308	30834	f
Oliveiras	12309	30834	f
Oliveiras do Salvador	12310	30834	f
Paço	12311	30834	f
Paraíso	12312	30834	f
Pasteleiros	12313	30834	f
Picoto	12314	30834	f
Poço	12315	30834	f
Poço Arco	12316	30834	f
Pombal	12317	30834	f
Porta da Garrida	12318	30834	f
Porta da Vila	12319	30834	f
Porta de Santa Luzia	12320	30834	f
Porta Nossa Senhora da Graça	12321	30834	f
Portal	12322	30834	f
Portas de Santo António	12323	30834	f
Portel	12324	30834	f
Portelo das Hortas	12325	30834	f
Postigo	12326	30834	f
Praça da Oliveira	12327	30834	f
Praça de Santiago	12328	30834	f
Praça do Peixe	12329	30834	f
Praça Grande	12330	30834	f
Praça Pequena	12331	30834	f
Pupa	12332	30834	f
Pupa de Baixo	12333	30834	f
Pupa de Cima	12334	30834	f
Quinta	12335	30834	f
Rama	12336	30834	f
Regatos	12337	30834	f
Retiro	12338	30834	f
Ribeiros	12339	30834	f
Rio	12340	30834	f
Roma	12341	30834	f
Rua Conde D. Henrique	12342	30834	f
Rua d Farpão	12343	30834	f
Rua D.Luís I	12344	30834	f
Rua da Arcela	12345	30834	f
Rua da Cadeia	12346	30834	f
Rua da Costa	12347	30834	f
Rua da Hera	12348	30834	f
Rua da Infesta	12349	30834	f
Rua da Rainha	12350	30834	f
Rua da Sapateira	12351	30834	f
Rua da Travessa	12352	30834	f
Rua das Flores	12353	30834	f
Rua das Lamelas	12354	30834	f
Rua das Mostardeiras	12355	30834	f
Rua das Taipas	12356	30834	f
Rua das Trinas	12357	30834	f
Rua de Cima	12358	30834	f
Rua de Donães	12359	30834	f
Rua de Moutadas	12360	30834	f
Rua de S. Dâmaso	12361	30834	f
Rua de S. Paio	12362	30834	f
Rua de Santa Catarina	12363	30834	f
Rua de Santa Cruz	12364	30834	f
Rua de Santa Inês	12365	30834	f
Rua de Santa Luzia	12366	30834	f
Rua de Santa Margarida	12367	30834	f
Rua de Santa Maria	12368	30834	f
Rua de Santa Tecla	12369	30834	f
Rua de São Salvador	12370	30834	f
Rua de Trás do Muro	12371	30834	f
Rua de Valdedonas	12372	30834	f
Rua do Castelo	12373	30834	f
Rua do Direito	12374	30834	f
Rua do Espírito Santo	12375	30834	f
Rua do Muro	12376	30834	f
Rua do Padre António Caldas	12377	30834	f
Rua do Poço	12378	30834	f
Rua do Sarralho	12379	30834	f
Rua do Trespasse	12380	30834	f
Rua dos Trigais	12381	30834	f
Rua Dr. José Sampaio	12382	30834	f
Rua Escura	12383	30834	f
Rua Nova	12384	30834	f
Rua Nova	12385	30834	f
Rua Nova do Carmo	12386	30834	f
Rua Nova do Comércio	12387	30834	f
Rua Nova do Muro	12388	30834	f
Sabugal	12389	30834	f
Sardoal	12390	30834	f
Seara	12391	30834	f
Terreiro	12392	30834	f
Terreiro da Cadeia	12393	30834	f
Terreiro de Santa Clara	12394	30834	f
Terreiro do Mestre Escola	12395	30834	f
Terreiro Golias	12396	30834	f
Torre dos Cães	12397	30834	f
Travessa da Cadeia	12398	30834	f
Travessa Monte	12399	30834	f
Travessa Monte Pio	12400	30834	f
Tulha	12401	30834	f
Viela Rego	12402	30834	f
Outeiro	12403	30838	f
Alfândega	12404	30860	f
Atrás da Igreja de S. Paio	12405	30860	f
Atrás da Misericórdia	12406	30860	f
Atrás de S. Paio	12407	30860	f
Atrás de Santa Luzia	12408	30860	f
Atrás do Mosteiro	12409	30860	f
Beco das Hortas	12410	30860	f
Beco dos Bimbais	12411	30860	f
Benlhevei	12412	30860	f
Bimbais	12413	30860	f
Bimbal de Santa Luzia	12414	30860	f
Calçada	12415	30860	f
Calçada de Santa Luzia	12416	30860	f
Campo do Toural	12417	30860	f
Convento de S. Domingos	12418	30860	f
Eirado	12419	30860	f
Eirado do Forno	12420	30860	f
Feijoeira	12421	30860	f
Fonte Nova	12422	30860	f
Hortas	12423	30860	f
Hortas de Santa luzia	12424	30860	f
Junto à Igreja	12425	30860	f
Junto à Misericórdia	12426	30860	f
Largo de S. Domingos	12427	30860	f
Largo de S. Paio	12428	30860	f
Largo de Santa Luzia	12429	30860	f
Largo do Gaiteiro	12430	30860	f
Largo do Requeixo	12431	30860	f
Largo dos Quarteis	12432	30860	f
Lugar das Aldeias	12433	30860	f
Lugar do Miradouro	12434	30860	f
Misericórdia	12435	30860	f
Palheiros	12436	30860	f
Porta da Vila	12437	30860	f
Porta de S. Paio	12438	30860	f
Porta de Santa Luzia	12439	30860	f
Postigo de S. Paio	12440	30860	f
Praça do Mercado	12441	30860	f
Praça do Toural	12442	30860	f
Praça Nova	12443	30860	f
Quinta do Proposto	12444	30860	f
Rua D. João I	12445	30860	f
Rua da Ferraria	12446	30860	f
Rua da Fonte Nova	12447	30860	f
Rua da Igreja	12448	30860	f
Rua da Porta Nova	12449	30860	f
Rua da Rainha	12450	30860	f
Rua da Torre Nova	12451	30860	f
Rua da Torre Velha	12452	30860	f
Rua da Tulha	12453	30860	f
Rua das Cortes	12454	30860	f
Rua de Alcobaça	12455	30860	f
Rua de Arrochela	12456	30860	f
Rua de Couros	12457	30860	f
Rua de Entre os Regatos	12458	30860	f
Rua de S. António	12459	30860	f
Rua de S. Bárbara	12460	30860	f
Rua de S. Dâmaso	12461	30860	f
Rua de S. Domingos	12462	30860	f
Rua de S. Lázaro	12463	30860	f
Rua de S. Paio	12464	30860	f
Rua de S. Sebastião	12465	30860	f
Rua de Santa cruz	12466	30860	f
Rua de Santa Luzia	12467	30860	f
Rua de São Paio	12468	30860	f
Rua do Anjo	12469	30860	f
Rua do Comércio	12470	30860	f
Rua do Mosteiro	12471	30860	f
Rua do Olival de Cima	12472	30860	f
Rua do Picoto	12473	30860	f
Rua do Postigo	12474	30860	f
Rua do Triunfo	12475	30860	f
Rua dos Açougues	12476	30860	f
Rua dos Gatos	12477	30860	f
Rua Francisco Agra	12478	30860	f
Rua Gil Vicente	12479	30860	f
Rua Nova	12480	30860	f
Rua Nova de S. António	12481	30860	f
Rua Nova de Santa Luzia	12482	30860	f
Rua Nova do Comércio	12483	30860	f
Rua Nova do Muro	12484	30860	f
Rua Paio Galvão	12485	30860	f
Terreiro de S. Paio	12486	30860	f
Terreiro do Paço	12487	30860	f
Travessa do Picoto	12488	30860	f
Alegria	12489	30863	f
Além Rio	12490	30863	f
Alfândega	12491	30863	f
Alvim	12492	30863	f
Areal	12493	30863	f
Atrás da Alfândega	12494	30863	f
Atras de São Sebastião	12495	30863	f
Atrás do Muro	12496	30863	f
Atrás dos Oleiros	12497	30863	f
Atrás Rio	12498	30863	f
Av. Camões	12499	30863	f
Av. Comércio	12500	30863	f
Av. Indústria	12501	30863	f
Barroca	12502	30863	f
Campo	12503	30863	f
Campo Cima	12504	30863	f
Campo de S. Francisco	12505	30863	f
Campo do Toural	12506	30863	f
Campo Feira	12507	30863	f
Cancela	12508	30863	f
Capuchos	12509	30863	f
Carrapatosa	12510	30863	f
Carvalhas de São Francisco	12511	30863	f
Centro	12512	30863	f
Convento de São Francisco	12513	30863	f
Gatos	12514	30863	f
Guardal	12515	30863	f
Hortas	12516	30863	f
Hospital São Roque	12517	30863	f
Lages	12518	30863	f
Lages São Francisco	12519	30863	f
Lages São Sebastião	12520	30863	f
Lages Toural	12521	30863	f
Lajes do Toural	12522	30863	f
Largo Campo Feira	12523	30863	f
Largo Carvalhas	12524	30863	f
Largo Cidade	12525	30863	f
Largo Condado	12526	30863	f
Largo D. Afonso Henriques	12527	30863	f
Largo da Igreja	12528	30863	f
Largo Pelourinho	12529	30863	f
Largo Ramada	12530	30863	f
Largo São Sebastião	12531	30863	f
Largo Terceiros	12532	30863	f
Largo Trovador	12533	30863	f
Madroa	12534	30863	f
Maina	12535	30863	f
Moinho	12536	30863	f
Molianas	12537	30863	f
Olival	12538	30863	f
Ordem Terceira São Francisco	12539	30863	f
Paços de Sousa	12540	30863	f
Picoto	12541	30863	f
Praça de D. Afonso Henriques	12542	30863	f
Quinta Vila Fria	12543	30863	f
Rego	12544	30863	f
Relho	12545	30863	f
Rua d Alcobaça	12546	30863	f
Rua da Avenida	12547	30863	f
Rua da Caldeiroa	12548	30863	f
Rua da Ponte	12549	30863	f
Rua da Ramada	12550	30863	f
Rua da Travessa	12551	30863	f
Rua das Carvalhas São Dâmaso	12552	30863	f
Rua das Pretas	12553	30863	f
Rua de 120	12554	30863	f
Rua de Couros	12555	30863	f
Rua de Fetos	12556	30863	f
Rua de Oleiros	12557	30863	f
Rua de Oliveiras	12558	30863	f
Rua de Pardelhas	12559	30863	f
Rua de Santa Rosa Lima	12560	30863	f
Rua de São Dâmaso	12561	30863	f
Rua de São Francisco	12562	30863	f
Rua de São Miguel Castelo	12563	30863	f
Rua de São Sebastião	12564	30863	f
Rua de Selho	12565	30863	f
Rua de Soalhães	12566	30863	f
Rua de Terceiros	12567	30863	f
Rua de Vila Flor	12568	30863	f
Rua de Vila Pouca	12569	30863	f
Rua de Vila Verde	12570	30863	f
Rua de Vilares	12571	30863	f
Rua do Arquinho	12572	30863	f
Rua do Bairro	12573	30863	f
Rua do Quartel	12574	30863	f
Rua do Quintal	12575	30863	f
Rua Nova das Oliveiras	12576	30863	f
Rua Nova de Camões	12577	30863	f
Rua Nova de S. Sebastião	12578	30863	f
Rua Nova de São Francisco	12579	30863	f
Terreiro São Francisco	12580	30863	f
Torre	12581	30863	f
Toural	12582	30863	f
Travessa de Camões	12583	30863	f
Travessa Dominicas	12584	30863	f
Travessa Hortas	12585	30863	f
Travessa Pretas	12586	30863	f
Vila Verde	12587	30863	f
Viscaias	12588	30863	f
Acima Maina	12589	30871	f
Adeias de Baixo	12590	30871	f
Aldeias	12591	30871	f
Aldeias	12592	30871	f
Aldeias Baixo	12593	30871	f
Aldeias de Baixo	12594	30871	f
Aldeias de Cima	12595	30871	f
Aldeias Melo	12596	30871	f
Aldeias Parede	12597	30871	f
Areal	12598	30871	f
Arquinho	12599	30871	f
Assento	12600	30871	f
Banhadouro	12601	30871	f
Barroca	12602	30871	f
Bica	12603	30871	f
Boavista	12604	30871	f
Bom Jesus	12605	30871	f
Bom Retiro	12606	30871	f
Bom Viver	12607	30871	f
Borreiros	12608	30871	f
Bouça	12609	30871	f
Boucinha	12610	30871	f
Bravo	12611	30871	f
Cabo	12612	30871	f
Cachada	12613	30871	f
Cães Pedra	12614	30871	f
Cal	12615	30871	f
Caldeiroa	12616	30871	f
Campo	12617	30871	f
Canto	12618	30871	f
Carreira	12619	30871	f
Casa da Presa	12620	30871	f
Casa do Salgado	12621	30871	f
Casa Velha	12622	30871	f
Casas Novas	12623	30871	f
Castanheiro	12624	30871	f
Cavalinho	12625	30871	f
Cerca	12626	30871	f
Costeiras	12627	30871	f
Couros	12628	30871	f
Covas	12629	30871	f
Covas Amaral	12630	30871	f
Covas de Baixo	12631	30871	f
Covas de Cima	12632	30871	f
Entre Vinhas	12633	30871	f
Estrada	12634	30871	f
Estrada Nova	12635	30871	f
Ferreiro	12636	30871	f
Fontaínhas	12637	30871	f
Fonte Santa	12638	30871	f
Fonte Santa de Baixo	12639	30871	f
Fonte Santa de Cima	12640	30871	f
Fonte São Gualter	12641	30871	f
Fundo de Vila	12642	30871	f
Herdade	12643	30871	f
Herdade Reguengua	12644	30871	f
Igreja	12645	30871	f
Jogo	12646	30871	f
Lagar	12647	30871	f
Lage	12648	30871	f
Lage de Dentro	12649	30871	f
Lage de Fora	12650	30871	f
Lapa	12651	30871	f
Lugarinho	12652	30871	f
Madroa	12653	30871	f
Maina	12654	30871	f
Meira	12655	30871	f
Meta	12656	30871	f
Minhotinho	12657	30871	f
Minhoto	12658	30871	f
Molianas	12659	30871	f
Molianas ao Rego	12660	30871	f
Monte	12661	30871	f
Montinho	12662	30871	f
Outeiro	12663	30871	f
Outeiro Cal	12664	30871	f
Outeiro de Vila Flor	12665	30871	f
Paço	12666	30871	f
Paço de Baixo	12667	30871	f
Paço de Cima	12668	30871	f
Paço do Meio	12669	30871	f
Parede	12670	30871	f
Pedra	12671	30871	f
Penanrique	12672	30871	f
Poça	12673	30871	f
Pombal	12674	30871	f
Ponte São Gualter	12675	30871	f
Portela	12676	30871	f
Portinha	12677	30871	f
Presa	12678	30871	f
Privilégio	12679	30871	f
Propriedades	12680	30871	f
Rego Caldeiroa	12681	30871	f
Remédios	12682	30871	f
Rola	12683	30871	f
Rola	12684	30871	f
Rola Cima	12685	30871	f
Rola Meio	12686	30871	f
Sabacho	12687	30871	f
Salgado	12688	30871	f
Santo André	12689	30871	f
São Roque	12690	30871	f
Sardoal	12691	30871	f
Serdã	12692	30871	f
Souto Franco	12693	30871	f
Souto Novo	12694	30871	f
Torre	12695	30871	f
Trofas	12696	30871	f
Vaca Negra	12697	30871	f
Vale Novo	12698	30871	f
Venda	12699	30871	f
Verde	12700	30871	f
Vila Chã	12701	30871	f
Vila Flor	12702	30871	f
Vila Nova	12703	30871	f
Vila Verde	12704	30871	f
Vila Verde Cima	12705	30871	f
Vilela	12706	30871	f
Peneda da Beira	12707	181206	f
São Lázaro	12708	450102	f
Almagreira	12709	460102	f
Almagreira - Almagreira de Baixo	12710	460102	f
Almagreira - Almagreira de Cima	12711	460102	f
Almagreira - Caminho Novo	12712	460102	f
Almagreira - Cruz da Almagreira	12713	460102	f
Almagreira - Grota dos Fiéis de Deus	12714	460102	f
Almagreira - Touril	12715	460102	f
Ribeira do Meio	12716	460102	f
Ribeira do Meio - Estrada Regional	12717	460102	f
Ribeira do Meio - Fiéis de Deus	12718	460102	f
Ribeira do Meio - Ribeira do Meio	12719	460102	f
Ribeira do Meio - Rua de S. Sebastião	12720	460102	f
Ribeira do Meio - Rua dos Castanhos	12721	460102	f
Silveira	12722	460102	f
Silveira - Caminho de Baixo	12723	460102	f
Silveira - Caminho Velho	12724	460102	f
Silveira - Canada de Ana de Vargas	12725	460102	f
Silveira - Canada de Domingos Vieira	12726	460102	f
Silveira - Canada do Ajudante	12727	460102	f
Silveira - Canada do Mato	12728	460102	f
Silveira - Estrada Regional	12729	460102	f
Silveira - Grota da Silveira	12730	460102	f
Silveira - Ribeira do Cabo	12731	460102	f
Silveira - S. Bartolomeu	12732	460102	f
Silveira - Soldão	12733	460102	f
Terras	12734	460102	f
Terras - Estrada Regional	12735	460102	f
Terras - Terras	12736	460102	f
Vila	12737	460102	f
Vila - Ria do Saco	12738	460102	f
Vila - Rua da Amoreira	12739	460102	f
Vila - Rua da Conceição	12740	460102	f
Vila - Rua da Ladeira	12741	460102	f
Vila - Rua da Pesqueira	12742	460102	f
Vila - Rua de S. Francisco	12743	460102	f
Vila - Rua de S. Pedro	12744	460102	f
Vila - Rua Direita	12745	460102	f
Vila - Rua do Espírito Santo	12746	460102	f
Vila - Rua do Paço	12747	460102	f
Vila - Rua do Passal	12748	460102	f
Vila - Rua do Poço	12749	460102	f
Vila - Rua dos Biscoitos	12750	460102	f
Assento	12751	30504	f
Borralheiras	12752	30504	f
Pinha	12753	30504	f
Muro	12754	30516	f
Convento de Santa Clara	12755	131628	f
Bouça	12756	30502	f
Vau	12757	30504	f
Rua dos Sapateiros	12758	30307	f
Covinho	12759	30827	f
Rua dos Palheiros	12760	30834	f
Vilar de Vacas	12761	30731	f
Alagoa	12762	30507	f
Gode	12763	30731	f
Casadela	12764	30722	f
Casal	12765	30521	f
Lamelas	12766	41219	f
Arrabalde	12767	30259	f
S. Veríssimo	12769	130133	f
Rua de S. Tiago	12770	160919	f
Rua de Altamira	12771	160919	f
Rua de São Sebastião	12772	160919	f
Rua de S. Catarina de Baixo	12773	160919	f
Tulha	12775	30860	f
Assento	12776	30865	f
Terreiro de Santa Luzia	12777	30860	f
São Lourenço	12778	170311	f
Chacim	12779	30414	f
Portela	12780	160919	f
Balasar	12781	131305	f
Afife	12782	160901	f
Portuzelo	12784	160928	f
Lavradas	12787	160735	f
Rua do loureiro	12788	160919	f
TRAVESSA  do Gandano	12789	160919	f
rua do padre pedro martins	12790	160919	f
rua s. sebastião	12791	160919	f
junto do mosteiro s. domingos	12792	160919	f
em casa de Sebastião Afonso	12793	160919	f
Rua dos Manjovos	12794	160919	f
Rua de Santana	12795	160931	f
Rua da Piedade	12796	160931	f
Dormes	12799	160432	f
Rua de Paulo Jorge	12803	160931	f
Rua de São Sebastião	12813	160919	f
Outeiro de Cima	12814	30857	f
Convento de Nossa Senhora do Carmo	12815	30834	f
Rua de Santa Catarina	12816	160931	f
Rua do Espírito Santo	12817	160931	f
S. Marinha - Barcelos	12818	490340	f
Cheda	12819	30721	f
Calcões	12820	30721	f
Gilheande	12821	30721	f
Ribeiras	12822	30721	f
Queimadela	12823	30721	f
Paradela	12824	31358	f
Argande	12825	30721	f
Cortegaça	12826	30724	f
Luilhas	12827	30717	f
Vila Franca	12828	30721	f
Monte de Trasgaia	12829	30813	f
Fábrica	12830	30813	f
Meixedo	12831	30721	f
Apocalipse	12832	30813	f
Agro	12833	30807	f
Além	12834	30807	f
Arca	12835	30807	f
Valdante	12836	30807	f
Bouça	12837	30807	f
Cabanelas	12838	30807	f
Cabanhas	12839	30807	f
Capela	12840	30807	f
Carreira de Tiro	12841	30807	f
Carulho	12842	30807	f
Carvalho	12843	30807	f
Casal do Carvalho	12844	30807	f
Casal do Fojo	12845	30807	f
Casas Novas de Pena	12846	30807	f
Casebre	12847	30807	f
Caserna	12848	30807	f
Castelo	12849	30807	f
Castelo	12850	30807	f
Ceselho	12851	30807	f
Ceselo	12852	30807	f
Chamado	12853	30807	f
Chanças	12854	30807	f
Chouças	12855	30807	f
Chousos	12856	30807	f
Costa	12857	30807	f
Couto	12858	30807	f
Cruz	12859	30807	f
Cruzeiro	12860	30807	f
Estrada	12861	30807	f
Fonte	12862	30807	f
Granja	12863	30807	f
Laje	12864	30807	f
Lameira	12865	30807	f
Légua do Couto	12866	30807	f
Moutilo	12867	30807	f
Outeiro	12868	30807	f
Paço	12869	30807	f
Pardelhas	12870	30807	f
Patos	12871	30807	f
Pena	12872	30807	f
Penedinho	12873	30807	f
Penedo	12874	30807	f
Pica	12875	30807	f
Ponte	12876	30807	f
Pontilhões	12877	30807	f
Quintães	12878	30807	f
Quintãs	12879	30807	f
Relíquia	12880	30807	f
Ribeira	12881	30807	f
Ribeirinho	12882	30807	f
Ribeiro	12883	30807	f
Ribeiro Baixo	12884	30807	f
Ribeiro Cima	12885	30807	f
Salgueiral	12886	30807	f
Séquito	12887	30807	f
Souto	12888	30807	f
Repulo	12889	30721	f
Santa Cruz	12890	30721	f
Cabanas	12891	30721	f
Moinho	12893	30816	f
Barroca	12894	30840	f
Couto de Vimieiro	12895	30306	f
Chousas	12896	30807	f
Riba da Ave	12897	30807	f
Seara	12898	30807	f
Paço	12899	30854	f
Agra	12900	30840	f
Agra Maior	12901	30840	f
Agrinha	12902	30840	f
Aldeia	12903	30840	f
Aldeia Nova	12904	30840	f
Além	12905	30840	f
Além do Rio	12906	30840	f
Algoso	12907	30840	f
Almas	12908	30840	f
Alto Chozende	12909	30840	f
Anha S. Tiago	12910	30840	f
Anjos	12911	30840	f
Arcela	12912	30840	f
Arieiro	12913	30840	f
Assento	12914	30840	f
Avenida	12915	30840	f
Avenida da Repúiblica	12916	30840	f
Azenha	12917	30840	f
Azenha da Cabada	12918	30840	f
Azenha da Cachada	12919	30840	f
Azenha da Serquinha	12920	30840	f
Bairrinho	12921	30840	f
Bairro	12922	30840	f
Bairro Alto	12923	30840	f
Baixo	12924	30840	f
Baralha	12925	30840	f
Barreiro	12926	30840	f
Barro	12927	30840	f
Barrosas	12928	30840	f
Basto	12929	30840	f
Belas	12930	30840	f
Bente	12931	30840	f
Bica	12932	30840	f
Boavista	12933	30840	f
Bouça	12934	30840	f
Bouça de Chozende	12935	30840	f
Bouça rio	12936	30840	f
Boucinha	12937	30840	f
Breia	12938	30840	f
Cabada	12939	30840	f
Cabanelas	12940	30840	f
Cabo de Vila	12941	30840	f
Cachada	12942	30840	f
Caide	12943	30840	f
Calçada	12944	30840	f
Caneiro	12945	30840	f
Cartas	12946	30840	f
Casa	12947	30840	f
Casa Nova	12948	30840	f
Casais	12949	30840	f
Cavada	12950	30840	f
Cerdeiras	12951	30840	f
Cerquinha	12952	30840	f
Charmeiras	12953	30840	f
Chozende	12954	30840	f
Cima	12955	30840	f
Corvite	12956	30840	f
Couto	12957	30840	f
Covelo	12958	30840	f
Cruz	12959	30840	f
Dentro	12960	30840	f
Devesa	12961	30840	f
Eirado	12962	30840	f
Ermida	12963	30840	f
Ferreiro	12964	30840	f
Fonte	12965	30840	f
Formão	12966	30840	f
Fornos	12967	30840	f
Frio	12968	30840	f
Gandra	12969	30840	f
Gimonde	12970	30840	f
Gimonde de Baixo	12971	30840	f
Gremil	12972	30840	f
Igreja	12973	30840	f
Lagea	12974	30840	f
Lata	12975	30840	f
Leitões	12976	30840	f
Lourinha	12977	30840	f
Mata	12978	30840	f
Mesao	12979	30840	f
Mesão Frio	12980	30840	f
Mogada	12981	30840	f
Mogege	12982	30840	f
Moinho de Assis	12983	30840	f
Monte	12984	30840	f
Monte Queimados	12985	30840	f
Mourisca	12986	30840	f
Mourisco	12987	30840	f
Nova	12988	30840	f
Oleiros	12989	30840	f
Olival	12990	30840	f
Oliveira	12991	30840	f
Ortas	12992	30840	f
Ouca	12993	30840	f
Ouce	12994	30840	f
Outeirinho	12995	30840	f
Outeiro	12996	30840	f
Outeiro Cima	12997	30840	f
Outeiro de Baixo	12998	30840	f
Outeiro de Cima	12999	30840	f
Pedrosa	13000	30840	f
Pedroso	13001	30840	f
Poça	13002	30840	f
Pole	13003	30840	f
Pule	13004	30840	f
Quartas	13005	30840	f
Queimado	13006	30840	f
Quinta	13007	30840	f
Quintanis	13008	30840	f
Quintas	13009	30840	f
Quintela	13010	30840	f
Quintela de Baixo	13011	30840	f
Quintela de Cima	13012	30840	f
Quintelo	13013	30840	f
Rego	13014	30840	f
Repiade	13015	30840	f
Requeixo	13016	30840	f
Ribadave	13017	30840	f
Rio	13018	30840	f
Romãos	13019	30840	f
São Miguel	13020	30840	f
Serdeira	13021	30840	f
Serquinha	13022	30840	f
Sobrado	13023	30840	f
Soutinho	13024	30840	f
Souto	13025	30840	f
Souto de Chozende	13026	30840	f
Travesselos	13027	30840	f
Várzea	13028	30840	f
Velha	13029	30840	f
Venda da Ladra	13030	30840	f
Vinha	13031	30840	f
Vinha Velha	13032	30840	f
Trás Carreira	13033	30807	f
Gandarela	13034	30849	f
Loureiro	13035	30807	f
Assento	13036	30807	f
Trás do Rio	13037	30849	f
Assento	13038	30702	f
Soutelo	13039	30732	f
Fornelo	13040	30735	f
Sever	13041	30858	f
Rocha	13042	30858	f
Cancela	13043	30855	f
Delgado	13044	30816	f
Souto	13045	30858	f
Laje	13046	30868	f
Montinho	13047	30807	f
Sernadelo	13048	30736	f
Relique	13049	30807	f
Monte	13050	30717	f
Labruge	13051	30872	f
Outeiro	13052	30816	f
Riba de Ave	13053	30868	f
Vila Meã	13054	30807	f
Arneiros	13055	40912	f
Igreja	13056	30721	f
Casal do Pombal	13057	31404	f
Assento	13058	30838	f
Castro	13059	31241	f
Berence	13060	30836	f
Brito	13061	30807	f
Borrecos	13062	30873	f
Outeiro	13063	30843	f
Passo	13064	30833	f
Anteportas	13065	30310	f
Carvalheira	13066	30807	f
Passo	13067	30807	f
Olival	13068	31241	f
Bouça	13069	30873	f
Mourilhe	13070	30868	f
Beledo	13071	31404	f
Vila de Baixo	13072	30808	f
Carreira	13073	30807	f
Caserma	13074	30807	f
Remelhe	13075	30310	f
Senães	13076	30868	f
Pontido	13078	30721	f
Corvite	13079	30838	f
Carrapitos	13080	30808	f
Fonte Cova	13081	30838	f
Cortes	13082	30838	f
Ribeira	13083	160931	f
Covilhã	13084	30872	f
Cima da Vila	13085	30872	f
Lagiela	13086	30733	f
Figueiredo	13087	30816	f
Casal de Senra	13088	30733	f
Aldeia	13089	30717	f
Cabeceiros	13090	30708	f
Penedo	13091	30844	f
Anta	13092	30816	f
Carvalho	13093	30854	f
Rama	13094	30816	f
Vizela	13095	30733	f
Turio	13096	30810	f
Várzea	13097	30857	f
Sepielos	13098	30816	f
Granja	13099	30868	f
Antas	13100	30873	f
Tojais	13102	30838	f
Lugar do Rio	13103	30834	f
Casal de Estime	13105	30717	f
Arcos de Valdevez	13108	490332	f
Cadeia	13109	30834	f
Pedra Furada	13110	30807	f
Recolhimento das Trinas	13111	30834	f
Santo Amaro	13112	30829	f
Recolhimento do Anjo	13113	30834	f
Serrado	13114	30816	f
Fojo	13115	30807	f
Ermo	13116	30708	f
Moinho	13117	30807	f
Monção	13118	490335	f
Monção	13119	160433	f
Correlhã	13120	160716	f
Ponte de Lima	13121	490338	f
Rua da Bandeira	13122	160931	f
Frazidela	13123	40714	f
Fradizela	13124	40714	f
Louredo	13125	30724	f
Agrelos	13126	30838	f
Água Levada	13127	30838	f
Aguadilha Cima	13128	30838	f
Aguardilha	13129	30838	f
Além Ponte	13130	30838	f
Alto	13131	30838	f
Arnaldo	13132	30838	f
Arrabalde	13133	30838	f
Azenha	13134	30838	f
Azevedo	13135	30838	f
Bacelinho	13136	30838	f
Bacelo	13137	30838	f
Bacelo Baixo	13138	30838	f
Bacorim	13139	30838	f
Bairro	13140	30838	f
Bairro Alto	13141	30838	f
Baixo	13142	30838	f
Barreiro	13143	30838	f
Bixalne	13144	30838	f
Boavista	13145	30838	f
Borrego	13146	30838	f
Bouça	13147	30838	f
Boucinha	13148	30838	f
Bruxal	13149	30838	f
Cachadinha	13150	30838	f
Campelos	13151	30838	f
Campo Novo	13152	30838	f
Cancelas	13153	30838	f
Cantinho	13154	30838	f
Capela	13155	30838	f
Carreira	13156	30838	f
Casa Cima	13157	30838	f
Casa da Ribeira	13158	30838	f
Casa Monte	13159	30838	f
Casa Nova	13160	30838	f
Casa Nova Baixo	13161	30838	f
Casa Nova Cima	13162	30838	f
Casais	13163	30838	f
Carrais	13164	30838	f
Casal	13165	30838	f
Casas	13166	30838	f
Cascos	13167	30838	f
Castelães	13168	30838	f
Castelães Além	13169	30838	f
Castelães Baixo	13170	30838	f
Castelães Cima	13171	30838	f
Cavelas Baixo	13172	30838	f
Chã	13173	30838	f
Chapas	13174	30838	f
Cheira	13175	30838	f
Cima Vila	13176	30838	f
Corrais	13177	30838	f
Corveira	13178	30838	f
Courelas	13179	30838	f
Courelas Baixo	13180	30838	f
Courelas Cima	13181	30838	f
Coutinho	13182	30838	f
Couto	13183	30838	f
Couto Cima	13184	30838	f
Cova	13185	30838	f
Cova Baixo	13186	30838	f
Cova Cima	13187	30838	f
Covelas	13188	30838	f
Covelas Baixo	13189	30838	f
Covelas Cima	13190	30838	f
Cruzeiro	13191	30838	f
Dazenha	13192	30838	f
Deveza	13193	30838	f
Domingos	13194	30838	f
Espinheiro	13195	30838	f
Estrada	13196	30838	f
Estremadouro	13197	30838	f
Faroeiro	13198	30838	f
Feijoal	13199	30838	f
Feiria	13200	30838	f
Ferreito	13201	30838	f
Fetinha	13202	30838	f
Fonte	13203	30838	f
Fonte Boa	13204	30838	f
Fontelos	13205	30838	f
Fontinha	13206	30838	f
Fundo	13207	30838	f
Guardeilho	13208	30838	f
Guardilhe	13209	30838	f
Hermeiro	13210	30838	f
Igreja	13211	30838	f
Lage	13212	30838	f
Lamas	13213	30838	f
Lameiras	13214	30838	f
Latada	13215	30838	f
Levada	13216	30838	f
Liginio	13217	30838	f
Mata	13218	30838	f
Mato	13219	30838	f
Miogo	13220	30838	f
Monte Baixo	13221	30838	f
Montinho	13222	30838	f
Montinho Baixo	13223	30838	f
Montinho Cima	13224	30838	f
Outeiro Baixo	13225	30838	f
Outeiro Cima	13226	30838	f
Outeiro do Miogo	13227	30838	f
Paço	13228	30838	f
Paço Baixo	13229	30838	f
Paço Cima	13230	30838	f
Pedenido	13231	30838	f
Penardufe	13232	30838	f
Penarelho	13233	30838	f
Penedo	13234	30838	f
Poça Ribeiro	13235	30838	f
Poço	13236	30838	f
Poço Baixo	13237	30838	f
Poço Cima	13238	30838	f
Pomardufe	13239	30838	f
Ponte	13240	30838	f
Pontelo	13241	30838	f
Pontuzela	13242	30838	f
Porta	13243	30838	f
Pousa	13244	30838	f
Pouve	13245	30838	f
Povoa	13246	30838	f
Quinta	13247	30838	f
Remanso	13248	30838	f
Reveza	13249	30838	f
Ribeira	13250	30838	f
Ribeira de Baixo	13251	30838	f
Ribeira Cima	13252	30838	f
Ribeiro	13253	30838	f
Ribeiro Cima	13254	30838	f
Ribeiro Cima	13255	30838	f
Rio	13256	30838	f
Roca	13257	30838	f
São Caetano	13258	30838	f
São Gemil	13259	30838	f
Segural	13260	30838	f
Senra	13261	30838	f
Senra Baixo	13262	30838	f
Senra Cima	13263	30838	f
Serrado	13264	30838	f
Silva	13265	30838	f
Silveira	13266	30838	f
Sobreiro	13267	30838	f
Soutinho	13268	30838	f
Souto	13269	30838	f
Souto Cima	13270	30838	f
Sub-Carreira	13271	30838	f
Sub-Deveza	13272	30838	f
Talho	13273	30838	f
Tetinha	13274	30838	f
Trás Outeiro	13275	30838	f
Trás Veiga	13276	30838	f
Veiga	13277	30838	f
Veiga Cima	13278	30838	f
Vendas	13279	30838	f
Ventozela	13280	30838	f
Vinha	13281	30838	f
Ribeiro	13282	30854	f
Verdial	13283	30807	f
Rua de São Pedro	13285	160931	f
Tojeira	13286	30873	f
Rua do Cais	13287	160931	f
Lamas	13288	30708	f
Priorado	13289	30834	f
Assento	13290	30724	f
Outeirinho	13291	30807	f
Sub-Carreira	13292	31219	f
Souto dos Frades	13293	30873	f
Paço	13294	30833	f
Ponte	13295	30841	f
Formigosa	13296	30868	f
Requião	13297	30868	f
Lorvão	13298	30868	f
Destros	13299	30868	f
Paço	13300	30868	f
Fontelo	13301	30868	f
Gandras	13302	30868	f
Baralha	13303	30868	f
Mourilhes	13304	30868	f
Curveira	13305	30868	f
Agrela	13306	30868	f
Soutelo	13307	30862	f
Corujeira	13308	30868	f
Viende	13309	30868	f
Assento da Igreja	13310	30721	f
Sinais	13311	30868	f
Ardoins	13312	30868	f
Costa	13313	30868	f
Casola	13314	30868	f
Penacova	13315	30868	f
Sendelo	13316	30868	f
Picouto	13317	30807	f
Assento	13318	30868	f
Murça	13319	30868	f
Bacelo	13320	30925	f
Moirinha	13321	30868	f
Soalhais	13322	30868	f
Carvalho	13323	30868	f
Escada	13324	30868	f
Seidões	13325	30731	f
Leiras	13326	30868	f
Queimadela-Cacho	13327	30721	f
Reguengo	13328	30724	f
Cabo	13329	30713	f
Ardão	13330	30868	f
Eido além Queimadela	13331	30721	f
Golpilhães	13332	30868	f
Lardosa	13333	130722	f
S. Fins	13334	30733	f
Barrinhas	13335	30733	f
Ferreirinhos	13336	30868	f
Portela	13337	160931	f
Rua do Hospital	13338	160931	f
Rua da Salgada	13339	160931	f
Salvador do Souto	13341	31014	f
Torre d'Além	13342	30868	f
Escadinha	13343	30868	f
S. Salvador	13344	160603	f
S. Martinho	13345	490332	f
S. Martinho	13346	160120	f
Igreja	13347	30717	f
)	13348	30868	f
Candoso (S. Martinho)	13349	30868	f
Leis	13350	30708	f
Crujeiro	13351	30868	f
Pias	13352	490334	f
Ribeiro	13353	160727	f
Paradança	13356	170504	f
São. Pedro	13358	160933	f
Teixugueira	13359	30868	f
Zenha	13360	30868	f
Bouça	13361	30868	f
Campinho	13362	30868	f
Boucinhas	13363	30868	f
Barranha	13364	30855	f
Lamego	13365	180501	f
Rua dos Caleiros	13366	160931	f
Rua da Gramática	13367	160931	f
Cacho	13368	30724	f
Vilarinho de Cima	13369	30925	f
Rua Pedro de Melo	13370	160931	f
Rua Nova de São Bento	13371	160931	f
Campo do Forno	13372	160931	f
Rua dos Pelames	13373	30307	f
Quintela	13375	171429	f
Torre	13376	30868	f
Igreja-Outeiro	13377	30717	f
Igreja (Eira)	13378	30717	f
Aldeia de S. Miguel	13379	30717	f
São Paio	13380	30831	f
Rua de São Sebastião	13381	160931	f
Outeiro	13382	30521	f
Rua Grande	13383	160931	f
Sardoeira	13384	30868	f
Corvite (Santa Maria)	13385	30872	f
Rua Nova	13386	160931	f
Vila Mou	13387	160937	f
Capareiros	13388	160906	f
Rua do Cachucho	13389	160931	f
Porta da Ribeira	13390	160931	f
Rua da Igreja Grande	13391	160931	f
Rua da Picota	13392	160931	f
Rua da Palha	13393	160931	f
Praça do Pão	13394	160931	f
Felgueiras	13395	30310	f
Praça do Peixe	13396	160931	f
Rua dos Sequeiros	13397	160931	f
Rio	13398	30803	f
Costa	13399	131419	f
Ribeiro	13400	30850	f
Carreira	13401	30501	f
Adro	13402	30850	f
Assento ?	13403	30850	f
Ponte da Mansa	13404	30854	f
Outeiro	13405	30850	f
Vila de Punhe - Barcelos	13406	160919	f
Quinta da Veiga	13407	30521	f
Ribeira	13408	30854	f
Rua do Postigo	13409	160931	f
Senra	13410	30850	f
Carvalho	13411	30821	f
Souto	13412	30850	f
Grelos	13413	30850	f
Rua da Praça	14409	160931	f
Rua da Ribeira	14410	160931	f
Assento	14411	30833	f
Gamilo	14412	30857	f
Quintães	14413	30826	f
Venda Nova	14414	30216	f
Soalheira	14415	30854	f
Reguengo	14416	30816	f
Pinhel	14417	30808	f
Rua das Flores	14418	160931	f
Ribeirinhas	14419	30807	f
Vessada	14420	30872	f
Samoça	14421	30826	f
Laje	14422	30848	f
São Paio	14423	30844	f
Rocha	14424	30848	f
Devesa	14425	30873	f
Outeiro Levado	14426	30850	f
Fundevila	14427	30516	f
Novegilde	14428	30850	f
Picouto	14429	30872	f
Paço de Cima	14430	30866	f
Casal	14431	170501	f
Rua dos Fornos	14432	160931	f
São Tiago	14433	160727	f
Postigo Novo	14434	160931	f
Outeiro	14435	30839	f
Rua de São Bento	14436	160931	f
Ribeira	14437	30503	f
Rua de S. João	14438	160931	f
Rua das Correias	14439	160931	f
Rua Direita	14440	160931	f
Rua da Videira	14441	160931	f
Rua do Salgado	14442	160931	f
Lisboa	14443	490254	f
Rua do Tourinho	14444	160931	f
S.João da Ribeira, Ponte de Lima	14445	160931	f
Quelhas	14446	160931	f
Meadela	14447	160917	f
Rua da Porta da Ribeira	14448	160931	f
Rua de Pedro de Melo	14449	160931	f
Almedinha	14450	130507	f
Covelas	14451	30906	f
Vilar	14452	30907	f
Pereira	14453	30853	f
Boavista	14454	30835	f
Campo do Moinho	14455	30835	f
Mourão	14456	30835	f
Paço	14457	30866	f
Hospital da misericórdia	14458	30804	f
Vinha	14459	30854	f
Leiras	14460	30854	f
Coimbra	14462	490174	f
Vila Fria	14463	160936	f
Nossa Senhora do Vale	14464	160149	f
Arcos de Valdevez	14465	160149	f
Braga	14466	490137	f
Aveiro	14467	490106	f
S. Romão da Gandra do Neiva	14468	160923	f
Rua do Poço	14469	160931	f
Chaves	14470	490344	f
S, João de Parada	14471	160126	f
São Martinho	14472	160726	f
Jolda	14473	160142	f
Caminha	14475	490333	f
Santa Maria de Insalde	14477	160511	f
Louredo	14478	31108	f
Santa Maria	14483	160201	f
Rua de Trás da Igreja (São Paio)	14484	30860	f
Fonte	14485	30867	f
Rua do Forno	14486	160931	f
Rendufe	14487	30406	f
Cabreira	14488	30505	f
Bouça	14489	30506	f
Bouça	14490	30509	f
Lamelas	14491	30518	f
Lage	14492	30509	f
Caselhos	14493	30509	f
Cerdeirinhas	14494	30516	f
São Tiago do Castelo	14495	160919	f
Perre	14496	30509	f
Casais	14497	30506	f
Bastelo	14498	30734	f
Paredes	14499	170626	f
Portela	14500	30511	f
Barrega	14501	30503	f
Agrelos	14502	131113	f
Cabo	14503	130116	f
Porto	14504	30516	f
Raposeira	14505	30521	f
Amaro	14506	30521	f
Sobreiro	14507	30509	f
Fundevila	14508	30509	f
Telhado	14509	170626	f
Oleiros	14510	30416	f
Igreja	14511	30509	f
Bugalha	14512	30509	f
portela	14513	160919	f
Matriz	14514	160931	f
Rua da Parenta	14515	160931	f
Carreira	14516	30925	f
Requeixo	14517	30733	f
Lampassas	14518	30509	f
Fraga	14519	30521	f
Praça Velha	14520	160931	f
Marvão	14521	30509	f
Lameiro	14522	30519	f
Redondo	14523	30518	f
Pinheiro	14524	30521	f
Fundevila	14525	30506	f
Aveia	14526	30519	f
Rua de Trás de S. Bento	14527	160931	f
Porta	14528	30848	f
Travessa de S. João	14529	160931	f
Praça	14531	30514	f
Rua dos Seitães	14532	160931	f
Rua da Alamega	14533	160931	f
Rua de Manuel Ribeiro	14534	160931	f
Rua de Gonçalo Ferreira	14535	160931	f
Rua de João Velho	14536	160931	f
Postigo Velho	14537	160931	f
Cabido da Bandeira	14538	160931	f
Rua do Eirado	14539	160931	f
Rua de Pedro Gomes	14541	160931	f
Figueiredo	14542	30509	f
Ribeira	14543	30414	f
Robalde	14544	30507	f
Adro da Igreja Velha	14545	160931	f
Rua das Padeiras	14546	160931	f
Rua da Misericórdia	14547	160931	f
Rua de Santo António	14549	160931	f
Fontainhas	14550	30512	f
Pouso	14551	30514	f
Requeixo	14552	30521	f
Rua da Liberdade	14553	30863	f
Rua do Tojo	14554	160931	f
Vila ra Raia- São Paio	14555	490360	f
Armado	14556	490355	f
Rua Nova de Santana	14557	160931	f
Rua do Loureiro	14558	160931	f
Sapardos	14559	490146	f
Bairro	14560	31113	f
Paço	14561	30520	f
Quintela	14562	30520	f
Encusturas	14563	30406	f
Roussas	14564	160316	f
Santa Maria	14565	160316	f
Sequeiros	14567	30903	f
Mogo de Ansiães	14568	40310	f
Póvoa	14569	40902	f
Chacim	14570	40509	f
Francelos	14571	31342	f
Muscoso	14572	30415	f
Eirô	14573	30415	f
Outeiro	14574	30511	f
Rua de Pedro Soares	14575	160931	f
Rua de João Portela	14576	160931	f
Cepeda	14577	30521	f
Paço	14578	30506	f
Quintela	14579	30514	f
Perre	14580	160926	f
Lugar da Rua	14582	160140	f
São Lourenço	14584	490174	f
Peneda	14585	130140	f
Porto	14586	490291	f
Várzeas	14587	30907	f
Santiago da Ribeira de Alhariz	14588	171221	f
Veiga	14590	30726	f
Gandra	14591	30502	f
São Martinho	14592	160937	f
Paços	14593	130324	f
São Salvador	14595	160934	f
Granja	14596	30805	f
Aldeia	14597	30827	f
Assento	14598	30827	f
Barranca	14599	30827	f
Barroca	14600	30827	f
Boavista	14601	30827	f
Bouça	14602	30827	f
Carreira	14603	30827	f
Carvalhal	14604	30827	f
Casal	14605	30827	f
Casinhas	14606	30827	f
Cheira	14607	30827	f
Costa	14608	30827	f
Devesa	14609	30827	f
Escrita	14610	30827	f
Esmoriz	14611	30827	f
Fojo	14612	30827	f
Fornos	14613	30827	f
Fundegos	14614	30827	f
Galego	14615	30827	f
Gandarela	14616	30827	f
Grijó	14617	30827	f
Herdeira	14618	30827	f
Loureiro	14619	30827	f
Lugarinho	14620	30827	f
Magro	14621	30827	f
Medos	14622	30827	f
Mouriçó	14623	30827	f
Murteira	14624	30827	f
Oleiros	14625	30827	f
Ordem	14626	30827	f
Outeiro	14627	30827	f
Outeiro da Laje	14628	30827	f
Outeiro de Oleiros	14629	30827	f
Pedrais	14630	30827	f
Pedras	14631	30827	f
Pena	14632	30827	f
Picoto	14633	30827	f
Quintã	14634	30827	f
Real	14635	30827	f
Redondo	14636	30827	f
Reguenga	14637	30827	f
Rio	14638	30827	f
Ruela	14639	30827	f
São Martinho	14640	30827	f
Serrazinho	14641	30827	f
Sobrado	14642	30827	f
Sobreiral	14643	30827	f
Talho	14644	30827	f
Telhado	14645	30827	f
Torás	14646	30827	f
Venda da Falperra	14647	30827	f
Vendas	14648	30827	f
Vergadela	14649	30827	f
varzea	14650	40103	f
Agro Monte	14651	160519	f
Alvares	14652	160519	f
Barrio	14653	160519	f
Boavista	14654	160519	f
Borbolegão	14655	160519	f
Botica	14656	160519	f
Boucinha	14657	160519	f
Buonosares	14658	160519	f
Cachada	14659	160519	f
Cachouceira	14660	160519	f
Capardos	14661	160519	f
Casa Grande	14662	160519	f
Cascalhal	14663	160519	f
Casuso	14664	160519	f
Cerdedelo	14665	160519	f
Condessosa	14666	160519	f
Corga	14667	160519	f
Cortinhal	14668	160519	f
Costado	14669	160519	f
Cova Vale	14670	160519	f
Devesa	14671	160519	f
Figueira	14672	160519	f
Francisco	14673	160519	f
Giestal	14674	160519	f
Lombinho	14675	160519	f
Madalena	14676	160519	f
Meijoeiro	14677	160519	f
Morufe	14678	160519	f
Outeiral	14679	160519	f
Pedrouço	14680	160519	f
Picoto	14681	160519	f
Pisco	14682	160519	f
Poça	14683	160519	f
Pousado	14684	160519	f
Presinha	14685	160519	f
Rapido	14686	160519	f
Redondo	14687	160519	f
Refoios	14688	160519	f
Riba	14689	160519	f
Santa Maria	14690	160519	f
Santa Marinha	14691	160519	f
São Cipriano	14692	160519	f
São Cosme	14693	160519	f
São Martinho Coura	14694	160519	f
São Paio Agoalonga	14695	160519	f
Veiga Monte	14696	160519	f
Venda	14697	160519	f
Caldeira de Baixo	14698	450103	f
Caldeira de Baixo	14699	450103	f
Caldeira de Cima	14700	450103	f
Caminho	14701	450103	f
Caminho da Bica	14702	450103	f
Caminho da Fonte	14703	450103	f
Caminho da Igreja	14704	450103	f
Caminho da Ribeira	14705	450103	f
Caminho de São Batolomeu	14706	450103	f
Caminho Novo	14707	450103	f
Carregado	14708	450103	f
Cruzes	14709	450103	f
Eira	14710	450103	f
Fajã da Caldeira	14711	450103	f
Fajã do Belo	14712	450103	f
Fajã dos Bodes	14713	450103	f
Fajã dos Cubres	14714	450103	f
Fajã dos Tijolos	14715	450103	f
Fajã dos Vimes	14716	450103	f
Fajã Redonda	14717	450103	f
Gança	14718	450103	f
Latina	14719	450103	f
Lomba	14720	450103	f
Loural	14721	450103	f
Miradouro	14722	450103	f
Morro	14723	450103	f
Pojal	14724	450103	f
Portal	14725	450103	f
Relvinha	14726	450103	f
Rua Acima	14727	450103	f
Rua da Pedra	14728	450103	f
Rua de Baixo	14729	450103	f
Rua de Baixo	14730	450103	f
Sanguinhal	14731	450103	f
Silveira	14732	450103	f
Tendas	14733	450103	f
Travessas	14734	450103	f
Assumada	14735	460101	f
Boca da Canada	14736	460101	f
Caminho de Cima	14737	460101	f
Caminho Largo	14738	460101	f
Canada da Calheta	14739	460101	f
Canada da Igreja	14740	460101	f
Canada da Saúde	14741	460101	f
Cruz da Calheta	14742	460101	f
Foros	14743	460101	f
Lugar da Baía	14744	460101	f
Lugar da Calheta	14745	460101	f
Lugar da Igreja	14746	460101	f
Lugar das Canadas	14747	460101	f
Lugar dos Poços	14748	460101	f
Miradouro	14749	460101	f
Outeiro	14750	460101	f
Outeiro do Grilo	14751	460101	f
Rua do Mar	14752	460101	f
Terreiro da Calheta	14753	460101	f
Acima da Fortaleza	14754	460102	f
Almagreira - Canada Ana de Vargas	14755	460102	f
Almagreira Baixo	14756	460102	f
Almagreira Cima	14757	460102	f
Bairro Fernão Álvaro Evangelho	14758	460102	f
Base Aérea nº4	14759	460102	f
Boca do Caminho Novo	14760	460102	f
Caminho Baixo	14761	460102	f
Caminho das Terras	14762	460102	f
Canada Agueda de Brum	14763	460102	f
Canada Ana Monteiro	14764	460102	f
Canada das Cruzes	14765	460102	f
Canada de Domingos Vargas	14766	460102	f
Canada de Maria de Vargas	14767	460102	f
Canada Domingas Pereira	14768	460102	f
Canada Nova	14769	460102	f
Cimo da Ladeira	14770	460102	f
Estrada Nacional	14771	460102	f
Grota	14772	460102	f
Grota da Ribeira	14773	460102	f
Grota de Ana Monteiro	14774	460102	f
Gruta de Ana Monteiro	14775	460102	f
Ladeira	14776	460102	f
Ladeira dos Ferreiros	14777	460102	f
Largo General Francisco Soares Lacerda Machado	14778	460102	f
Largo S. Pedro	14779	460102	f
Largo Vigário Gonçalo de Lemos	14780	460102	f
Lugar dos Biscoitos	14781	460102	f
Lugar dos Fiéis de Deus	14782	460102	f
Lugar S. Sebastião	14783	460102	f
Outeiro dos Castanhos	14784	460102	f
Passos	14785	460102	f
Pé da Ladeira	14786	460102	f
Praça da Vila	14787	460102	f
Ramal	14788	460102	f
Ribeira	14789	460102	f
Ribeira de Baixo	14790	460102	f
Ribeira de Fernandes Alves	14791	460102	f
Ribeira de João Valim	14792	460102	f
Ribeira do Fundo dos Altares	14793	460102	f
Rua Capitão-Mor Garcia Gonçalves Madruga	14794	460102	f
Rua Conde Ávila	14795	460102	f
Rua Conde de Ávila	14796	460102	f
Rua D. João Paulino Azevedo Castro	14797	460102	f
Rua D. Maria Adelaide da Silva	14798	460102	f
Rua da Alogoa	14799	460102	f
Rua da Barra	14800	460102	f
Rua da Vila	14801	460102	f
Rua de Baixo	14802	460102	f
Rua de Maria Nunes	14803	460102	f
Rua de Miragaia	14804	460102	f
Rua de S. Sebastião	14805	460102	f
Rua do Biscoito	14806	460102	f
Rua do Castelo	14807	460102	f
Rua do Conselheiro José de Ávila Almeida	14808	460102	f
Rua do Engenheiro Falcão	14809	460102	f
Rua do Vale	14810	460102	f
Rua Dona Maria Adelaide Silva	14811	460102	f
Rua dos Castanhos	14812	460102	f
Rua dos Ferreiros	14813	460102	f
Rua dos Sapateiros	14814	460102	f
Rua Dr. José Machado Serpa	14815	460102	f
Rua Engenheiro Arantes de Oliveira	14816	460102	f
Rua Engenheiro Falcão	14817	460102	f
Rua General Carmona	14818	460102	f
Rua Grota do Rossio	14819	460102	f
Rua José de Almeida Ávila	14820	460102	f
Rua Manuel Paulino de Azevedo	14821	460102	f
Rua Manuel Vieira Soares	14822	460102	f
Rua Nova	14823	460102	f
Rua Nova da Pesqueira	14824	460102	f
Rua Padre Manuel José Lopes	14825	460102	f
Rua Padre Xavier Madruga	14826	460102	f
Rua S. João de Deus	14827	460102	f
Rua S. Sebastião	14828	460102	f
Rua Serpa Pinto	14829	460102	f
Rua Visconde Borges da Silva	14830	460102	f
S. João	14831	460102	f
S. Jorge	14832	460102	f
S. Miguel	14833	460102	f
S. Pedro	14834	460102	f
S. Pedro	14835	460102	f
S. Sebastião	14836	460102	f
S. Silvestre	14837	460102	f
Santa Maria	14838	460102	f
Soldão	14839	460102	f
Vila - Rua de Olivença	14840	460102	f
Vila - Rua Miragaia	14841	460102	f
Altamora	14842	460103	f
Calhau	14843	460103	f
Caminho Biscoitos	14844	460103	f
Caminho Cima	14845	460103	f
Caminho da Faia	14846	460103	f
Caminho da Igreja	14847	460103	f
Caminho da Manhenha	14848	460103	f
Caminho da Ribeirinha	14849	460103	f
Caminho de Baixo	14850	460103	f
Caminho do Mato	14851	460103	f
Caminho Largo	14852	460103	f
Caminho Novo	14853	460103	f
Canada do Cabeço	14854	460103	f
Canadas	14855	460103	f
Cruz	14856	460103	f
Cruz do Redondo	14857	460103	f
Cruzeiro	14858	460103	f
Curral da Pedra	14859	460103	f
Faias	14860	460103	f
Fetais	14861	460103	f
Foros	14862	460103	f
Junto da Igreja	14863	460103	f
Ladeira do Barro	14864	460103	f
Lugar da Baixa	14865	460103	f
Lugar da Igreja	14866	460103	f
Lugar do Império	14867	460103	f
Miradouro	14868	460103	f
Passos Novos	14869	460103	f
Passos Velhos	14870	460103	f
Ponta da Ilha	14871	460103	f
Portal do Cabeço	14872	460103	f
Relvinha	14873	460103	f
Terra Alta	14874	460103	f
Arrife	14875	460104	f
Calçada	14876	460104	f
Caminho Baixo	14877	460104	f
Caminho Cima	14878	460104	f
Canada da Areia	14879	460104	f
Canada Santa Cruz	14880	460104	f
Canto	14881	460104	f
Cruz	14882	460104	f
Grotão	14883	460104	f
Ladeira de Santa Cruz	14884	460104	f
Laranjal	14885	460104	f
Mancilhas	14886	460104	f
Outeiro	14887	460104	f
Pontas Negras	14888	460104	f
Portal do Vale	14889	460104	f
Porto de Santa Cruz	14890	460104	f
Ribeira Grande	14891	460104	f
Ribeira Seca	14892	460104	f
Ribeiras	14893	460104	f
Rua de Cima	14894	460104	f
Rua do Lameiro	14895	460104	f
Santa Bárbara	14896	460104	f
Santa Cruz	14897	460104	f
Terreiro	14898	460104	f
Almagreira	14899	460106	f
Bargada	14900	460106	f
Pesqueiro da Cruz	14901	460106	f
Ponta	14902	460106	f
S. Sebastião	14903	460106	f
Silveira	14904	460106	f
Terra do Pão	14905	460106	f
Boa-Nova	14906	460201	f
Cabeço do Chão	14907	460201	f
Cachorro	14908	460201	f
Canada de Santo	14909	460201	f
Canada do Cais	14910	460201	f
Canada do Mar	14911	460201	f
Estrada do Mistério	14912	460201	f
Estrada Nacional	14913	460201	f
Farrobo	14914	460201	f
Furna da Água	14915	460201	f
Igreja	14916	460201	f
Lage	14917	460201	f
Lagido	14918	460201	f
Miragaia	14919	460201	f
Tambor	14920	460201	f
Alto	14921	460202	f
Arrabalde/Monte	14922	460202	f
Biscoito	14923	460202	f
Cabeço Ruivo	14924	460202	f
Cabeço/Ribeira	14925	460202	f
Cabo Branco	14926	460202	f
Calhau	14927	460202	f
Campo Baixo	14928	460202	f
Campo Cima	14929	460202	f
Campo Raso	14930	460202	f
Canada Calhau	14931	460202	f
Canada Nova	14932	460202	f
Canada Souto	14933	460202	f
Casas Altas	14934	460202	f
Cruz	14935	460202	f
Eira	14936	460202	f
Estrada	14937	460202	f
Estrada Nova	14938	460202	f
Fátima	14939	460202	f
Furna	14940	460202	f
Guindaste	14941	460202	f
Igreja	14942	460202	f
Mirateca	14943	460202	f
Monte	14944	460202	f
Monte Alto	14945	460202	f
Monte Baixo	14946	460202	f
Monte Cima	14947	460202	f
Monte Queimado	14948	460202	f
Outeiro	14949	460202	f
Picoto	14950	460202	f
Pocinho	14951	460202	f
Povoação	14952	460202	f
Ribeira	14953	460202	f
Rua Alto	14954	460202	f
Rua Belvos	14955	460202	f
Rua Biscoitos	14956	460202	f
Rua Cruz	14957	460202	f
Rua Eira	14958	460202	f
Rua Horta	14959	460202	f
Rua Igreja	14960	460202	f
Rua Nova	14961	460202	f
Rua Outeiro	14962	460202	f
Rua Poço	14963	460202	f
Rua S. José	14964	460202	f
Rua Santo	14965	460202	f
Saial	14966	460202	f
Abaixo do Cabeço	14967	460204	f
Alto	14968	460204	f
Areia Longa	14969	460204	f
Avelar	14970	460204	f
Barca	14971	460204	f
Bicadas	14972	460204	f
Biscoitos	14973	460204	f
Cabo Branco	14974	460204	f
Carmo	14975	460204	f
Colégio	14976	460204	f
Conceição	14977	460204	f
Direita	14978	460204	f
Ermida	14979	460204	f
Estrela	14980	460204	f
Juncalinho	14981	460204	f
Ladeira do Foderno	14982	460204	f
Matriz	14983	460204	f
Porto	14984	460204	f
Rua 5 de Outubro	14985	460204	f
Rua Conselheiro Terra Pinheiro	14986	460204	f
Rua das Dores	14987	460204	f
Rua de Cima	14988	460204	f
Rua do Castelo	14989	460204	f
Rua do Sabão	14990	460204	f
Rua Ouvidor Medeiros	14991	460204	f
Rua Sete Cidades	14992	460204	f
Santa Ana	14993	460204	f
Sertão	14994	460204	f
Terra do Pão	14995	460204	f
Toledos	14996	460204	f
Vale Louro	14997	460204	f
Valverde	14998	460204	f
Vila	14999	460204	f
Caminho do Meio	15000	460205	f
Bagaços	15001	460206	f
Baixo	15002	460206	f
Boavista	15003	460206	f
Cabeços	15004	460206	f
Caldeirões	15005	460206	f
Calheta	15006	460206	f
Caminho de Baixo	15007	460206	f
Caminho de Cima	15008	460206	f
Canada da Igreja	15009	460206	f
Canada da Prainha	15010	460206	f
Canada das Fontes	15011	460206	f
Canada do Mistério	15012	460206	f
Canada José Correia	15013	460206	f
Cruz das Almas	15014	460206	f
Gingeira	15015	460206	f
Grota	15016	460206	f
Igreja	15017	460206	f
Lages	15018	460206	f
Mistério	15019	460206	f
Porto	15020	460206	f
Relvas	15021	460206	f
Ribeira Grande	15022	460206	f
Terra do Pão	15023	460206	f
Travessa das Fontes	15024	460206	f
Travessa Nova	15025	460206	f
Vasco da Gama	15026	460206	f
Alto da Bonança	15027	460302	f
Caminho abaixo da Igreja	15028	460302	f
Caminho da Cruz	15029	460302	f
Caminho da Igreja	15030	460302	f
Caminho da Ossada	15031	460302	f
Caminho de baixo	15032	460302	f
Caminho de Cima	15033	460302	f
Caminho de Cima para a Ribeira	15034	460302	f
Caminho do Corvo	15035	460302	f
Caminho do Lagido	15036	460302	f
Caminho do Lagido de Baixo	15037	460302	f
Caminho do Mistério	15038	460302	f
Caminho dos Feitais	15039	460302	f
Canada do Alcaide	15040	460302	f
Canada do Branco	15041	460302	f
Canto do Mistério	15042	460302	f
Estrada	15043	460302	f
Fetais	15044	460302	f
Figueiras	15045	460302	f
Igreja	15046	460302	f
Lagido	15047	460302	f
Lagido do Meio	15048	460302	f
Loiro	15049	460302	f
Miragaia	15050	460302	f
Mistério	15051	460302	f
Ossada	15052	460302	f
Ribeira	15053	460302	f
Ribeira Nova	15054	460302	f
Rua abaixo da Igreja	15055	460302	f
Rua acima da Igreja	15056	460302	f
Rua da Cruz	15057	460302	f
Rua de Branco	15058	460302	f
Rua de Cima	15059	460302	f
Rua de Cima da Ribeira	15060	460302	f
Rua de Cima do Cemitério	15061	460302	f
Rua do Carro	15062	460302	f
Assento	15063	460303	f
Caminho/Rua de Cima	15064	460303	f
Canada da Maré	15065	460303	f
Canada das Almas	15066	460303	f
Canada do Atalho	15067	460303	f
Canada Nova	15068	460303	f
Pesqueiro Alto	15069	460303	f
Rochão	15070	460303	f
Rua da Igreja	15071	460303	f
Rua de Baixo	15072	460303	f
Rua dos Biscoitos	15073	460303	f
Terra Alta	15074	460303	f
Terras Limpas	15075	460303	f
Vale Frio/Terra Alta	15076	460303	f
Almas	15077	460304	f
Amoreiras	15078	460304	f
Areal	15079	460304	f
Bacelinhos	15080	460304	f
Biscoitos	15081	460304	f
Bragada	15082	460304	f
Cabeço	15083	460304	f
Cabeço das Queimadas	15084	460304	f
Caminho das Amoreiras	15085	460304	f
Caminho de Baixo	15086	460304	f
Caminho de Santana	15087	460304	f
Canada da Bragada	15088	460304	f
Canada da Castelhana	15089	460304	f
Canada da Tronqueira	15090	460304	f
Canada das Almas	15091	460304	f
Canada das Amoreiras	15092	460304	f
Canada de Santana	15093	460304	f
Canada de São Vicente	15094	460304	f
Canada do Atalho	15095	460304	f
Canada do Mar	15096	460304	f
Canada do Paúl	15097	460304	f
Canada do Torres	15098	460304	f
Castelhana	15099	460304	f
Cruz	15100	460304	f
Cruz das Almas	15101	460304	f
Eira	15102	460304	f
Eira do Cabeço	15103	460304	f
Fazenda	15104	460304	f
Furna	15105	460304	f
Ginjal	15106	460304	f
Ladeira	15107	460304	f
Ladeira de Ângela	15108	460304	f
Lagidinho	15109	460304	f
Lugar da Igreja	15110	460304	f
Pedreira	15111	460304	f
Poço	15112	460304	f
Poço da Tumba	15113	460304	f
Queimadas	15114	460304	f
Retiro	15115	460304	f
Rua da Igreja	15116	460304	f
Rua de Baixo	15117	460304	f
Rua de Cima	15118	460304	f
Rua de Santo António	15119	460304	f
Rua Direita	15120	460304	f
Santana	15121	460304	f
São Vicente	15122	460304	f
Tronqueiras	15123	460304	f
Baía do Mistério	15124	460305	f
Biscoitos da Rua de Cima	15125	460305	f
Cais	15126	460305	f
Caminho de Baixo	15127	460305	f
Caminho de Cima	15128	460305	f
Caminho Novo	15129	460305	f
Canada das Terras	15130	460305	f
Canada de Diogo Alves	15131	460305	f
Canada de José das Neves	15132	460305	f
Canada do Cais	15133	460305	f
Canada do Capitão-Mor	15134	460305	f
Canto	15135	460305	f
Canto de Cima	15136	460305	f
Lagidinho	15137	460305	f
Laranjal	15138	460305	f
Lugar da Calçada	15139	460305	f
Lugar do Couto	15140	460305	f
Lugar do Extremo	15141	460305	f
Lugar do Ferreiro	15142	460305	f
Lugar do Laranjal	15143	460305	f
Outeiro	15144	460305	f
Outeiro da Rua de Cima	15145	460305	f
Pedras Grandes	15146	460305	f
Praça da Vila de São Roque	15147	460305	f
Quintãs	15148	460305	f
Ribeira da Fonte	15149	460305	f
Ribeira de São Lázaro	15150	460305	f
Ribeira dos Moinhos	15151	460305	f
Ribeira Seca	15152	460305	f
Ribeirinha	15153	460305	f
Rua da Barrela	15154	460305	f
Rua da Calçada	15155	460305	f
Rua da Igreja	15156	460305	f
Rua da Matriz	15157	460305	f
Rua da Misericórdia	15158	460305	f
Rua da Praça	15159	460305	f
Rua da Rocha	15160	460305	f
Rua de Cima	15161	460305	f
Rua de São Francisco	15162	460305	f
Rua do Capitão-Mor	15163	460305	f
Rua do Lagidinho	15164	460305	f
Rua do Lameiro	15165	460305	f
Rua do Laranjal	15166	460305	f
Rua do Meio	15167	460305	f
Rua do Passo	15168	460305	f
Rua do Poço	15169	460305	f
Rua dos Biscoitos	15170	460305	f
Rua dos Moinhos	15171	460305	f
São Miguel Anjo	15172	460305	f
Terreiro do Cais	15173	460305	f
Canto da Igreja	15174	470101	f
Lugar ao pé da Igreja	15175	470101	f
Lugar ao pé do Cruzeiro	15176	470101	f
Lugar da Canada do Biscoito	15177	470101	f
Lugar da Igreja	15178	470101	f
Lugar da Praia	15179	470101	f
Lugar da Praia do Norte	15180	470101	f
Lugar da Ribeira do Cabo	15181	470101	f
Lugar do Canto	15182	470101	f
Lugar do Capelo	15183	470101	f
Lugar do Cimo da Igreja	15184	470101	f
Lugar do Cruzeiro	15185	470101	f
Lugar do Norte	15186	470101	f
Lugar do Norte Pequeno	15187	470101	f
Lugar do Outeiro dos Cavacos	15188	470101	f
Lugar do Sul	15189	470101	f
Lugar dos Trupes	15190	470101	f
Rua do Alto dos Cavacos	15191	470101	f
Sítio do Comprido???	15192	470101	f
Varadouro	15193	470101	f
Caldeirão	15194	470103	f
Calhau	15195	470103	f
Carapeta	15196	470103	f
Cascalho	15197	470103	f
Cascalho de Cima	15198	470103	f
Cascalho/Fonte de Baixo	15199	470103	f
Covões	15200	470103	f
Cruz	15201	470103	f
Fonte	15202	470103	f
Miragaia	15203	470103	f
Pé da Lomba	15204	470103	f
Ribeira de Joana Pires	15205	470103	f
Ribeira Funda	15206	470103	f
Rua de Cima	15207	470103	f
Salão	15208	470103	f
Rua da Atalaia	15209	470104	f
Rua da Cruz	15210	470104	f
Rua da Fonte do Rego	15211	470104	f
Rua da Granja	15212	470104	f
Rua da Igreja	15213	470104	f
Rua da Lajinha	15214	470104	f
Rua da Portela	15215	470104	f
Rua das Amoreirinhas	15216	470104	f
Rua das Canadinhas	15217	470104	f
Rua das Courelas	15218	470104	f
Rua das Grotas	15219	470104	f
Rua de São Pedro	15220	470104	f
Rua do Algar	15221	470104	f
Rua do Cimo da Granja	15222	470104	f
Rua do Cimo de São Pedro	15223	470104	f
Rua do Ferrobim	15224	470104	f
Rua do Ferrobim do Norte	15225	470104	f
Rua do Ferrobim do Sul	15226	470104	f
Rua do Lameiro Grande	15227	470104	f
Rua do Poceirão	15228	470104	f
Rua do Rego	15229	470104	f
Rua dos Quinhões	15230	470104	f
Travessa da Atalaia	15231	470104	f
Travessa de São Pedro	15232	470104	f
Travessa do Ferrobim	15233	470104	f
Travessa do Pedregulho	15234	470104	f
Canada de Porto Pim	15235	470106	f
Canada do Gonçalves	15236	470106	f
Canada do Passinho	15237	470106	f
Canada do Pedregulho	15238	470106	f
Castelo de Santa Cruz	15239	470106	f
Castelo de São Sebastião	15240	470106	f
Eira de Santa Bárbara	15241	470106	f
Monte da Guia	15242	470106	f
Monte Queimado	15243	470106	f
Passinho do Beliago	15244	470106	f
Portão do Porto Pim	15245	470106	f
Porto Pim	15246	470106	f
Rua Capelo Ivens	15247	470106	f
Rua da Areinha Velha	15248	470106	f
Rua da Igreja	15249	470106	f
Rua da Ladeira	15250	470106	f
Rua da Rampa do Portão	15251	470106	f
Rua da Rosa	15252	470106	f
Rua da Rosa - Casa nº 3	15253	470106	f
Rua das Angústias	15254	470106	f
Rua das Dutras	15255	470106	f
Rua de Borratem	15256	470106	f
Rua de Nossa Senhora das Angústias	15257	470106	f
Rua de Porto Pim	15258	470106	f
Rua de Santa Bárbara	15259	470106	f
Rua de Santa Cruz	15260	470106	f
Rua de São Francisco	15261	470106	f
Rua do Cais	15262	470106	f
Rua do Castelo	15263	470106	f
Rua do Conde de Ávila	15264	470106	f
Rua do Conselheiro Medeiros	15265	470106	f
Rua do Conselheiro Terra Pinheiro	15266	470106	f
Rua do Cônsul Dabney	15267	470106	f
Rua do Meio	15268	470106	f
Rua do Meio do Porto Pim	15269	470106	f
Rua do Pasteleiro	15270	470106	f
Rua Nova	15271	470106	f
Rua Nova de Porto Pim	15272	470106	f
Rua Travessa do Portão	15273	470106	f
Rua Vasco da Gama	15274	470106	f
Santa Bárbara	15275	470106	f
Travessa da Areinha	15276	470106	f
Travessa da Areinha Velha	15277	470106	f
Travessa da Rua Nova	15278	470106	f
Travessa de Porto Pim	15279	470106	f
À roda Igreja	15280	470107	f
Cabo da Praia	15281	470107	f
Calçada da Conceição	15282	470107	f
Calçada da Paiva	15283	470107	f
Caminho para a Volta	15284	470107	f
Caminho para S. Lourenço	15285	470107	f
Castelo Novo	15286	470107	f
Facho	15287	470107	f
Farrobo	15288	470107	f
Ladeira do Pilar	15289	470107	f
Ladeira para o Pilar	15290	470107	f
Lagoa	15291	470107	f
Lomba	15292	470107	f
Pilar	15293	470107	f
Ribeira	15294	470107	f
Rua acima da Igreja	15295	470107	f
Rua da Areia	15296	470107	f
Rua da Conceição	15297	470107	f
Rua da Igreja	15298	470107	f
Rua Direita	15299	470107	f
Rua do Atafoneiro	15300	470107	f
Rua do Bom Jesus	15301	470107	f
Rua do Cano	15302	470107	f
Rua Velha	15303	470107	f
Sto.Amaro	15304	470107	f
Travessa da Ribeira	15305	470107	f
Travessa de Trás da Igreja	15306	470107	f
Volta	15307	470107	f
Volta	15308	470107	f
Volta para a Lomba	15309	470107	f
Volta para os Flamengos	15310	470107	f
Calçada da Paiva	15311	470108	f
Caminho do Fundo	15312	470108	f
Canada da Pólvora	15313	470108	f
Canada do Armazém	15314	470108	f
Hospital da Misericórdia	15315	470108	f
Ladeira	15316	470108	f
Ladeira do Relógio	15317	470108	f
Largo do Bispo D. Alexandre	15318	470108	f
Largo do Colégio	15319	470108	f
Largo do Infante D. Luís	15320	470108	f
Largo do Marquês de Ávila	15321	470108	f
Lugar da Boavista	15322	470108	f
Lugar do Caminho do Fundo	15323	470108	f
Lugar do Quartel do Carmo	15324	470108	f
Nossa Senhora do Livramento	15325	470108	f
Rua acima do armazem da pólvora	15326	470108	f
Rua acima do Livramento	15327	470108	f
Rua D. Pedro IV	15328	470108	f
Rua da Alameda da Glória	15329	470108	f
Rua da Areia	15330	470108	f
Rua da Fonte	15331	470108	f
Rua da Ladeira de Santo António	15332	470108	f
Rua da Misericórdia	15333	470108	f
Rua da Praça	15334	470108	f
Rua da Roda	15335	470108	f
Rua das Dutras	15336	470108	f
Rua de Baixo	15337	470108	f
Rua de Cima	15338	470108	f
Rua de Cima de Santo António	15339	470108	f
Rua de Jesus	15340	470108	f
Rua de Nossa Senhora do Carmo	15341	470108	f
Rua de Santa Ana	15342	470108	f
Rua de Santo Elias	15343	470108	f
Rua de Santo Inácio	15344	470108	f
Rua de São Bento	15345	470108	f
Rua de São Francisco	15346	470108	f
Rua de São Paulo	15347	470108	f
Rua de São Pedro	15348	470108	f
Rua de Serpa Pinto	15349	470108	f
Rua Direita	15350	470108	f
Rua do Campo	15351	470108	f
Rua do Carmo	15352	470108	f
Rua do Colégio	15353	470108	f
Rua do Duque de Bragança	15354	470108	f
Rua do Livramento	15355	470108	f
Rua do Mar	15356	470108	f
Rua do Meio	15357	470108	f
Rua do Mercado	15358	470108	f
Rua do Ministro Ávila	15359	470108	f
Rua do Mosteiro	15360	470108	f
Rua do Paço	15361	470108	f
Rua do Pasteleiro	15362	470108	f
Rua do Paul	15363	470108	f
Rua do Saco	15364	470108	f
Rua dos Enjeitados	15365	470108	f
Rua Ladeira da Matriz Velha	15366	470108	f
Rua Ladeira de São João	15367	470108	f
Rua Médico Avelar	15368	470108	f
Rua Nova	15369	470108	f
Rua por detrás do Relógio	15370	470108	f
Rua São João	15371	470108	f
Rua Velha	15372	470108	f
Rua Visconde de Santa Ana	15373	470108	f
Sítio do Monte Carneiro	15374	470108	f
Trás do Muro das Religiosas	15375	470108	f
Travessa da Boa Viagem	15376	470108	f
Travessa da Cadeia	15377	470108	f
Travessa da Glória	15378	470108	f
Travessa da Misericórdia	15379	470108	f
Travessa da Vista Alegre	15380	470108	f
Travessa de Santo António	15381	470108	f
Travessa de São Bento	15382	470108	f
Travessa de São Francisco	15383	470108	f
Travessa do Carmo	15384	470108	f
Travessa do Monteiro	15385	470108	f
Travessa do Porto Novo	15386	470108	f
Travessa para o Mirante	15387	470108	f
Ao pé da Ponte	15388	470109	f
Cabeço Redondo	15389	470109	f
Calvário	15390	470109	f
Caminho da Cidade	15391	470109	f
Caminho da Igreja	15392	470109	f
Caminho Velho	15393	470109	f
Canada	15394	470109	f
Canada das Areias	15395	470109	f
Canada do Lagido	15396	470109	f
Canada do Lagido	15397	470109	f
Detrás da Ladeira	15398	470109	f
Estrada Real	15399	470109	f
Grota Funda	15400	470109	f
Ladeira	15401	470109	f
Muros	15402	470109	f
Rua da Arrochela	15403	470109	f
Rua da Boavista	15404	470109	f
Rua da Grota Funda	15405	470109	f
Rua de Miragaia	15406	470109	f
Rua Doutor Avelar	15407	470109	f
Rua Velha	15408	470109	f
Atalho da Velha	15409	470110	f
Caminho da Areia	15410	470110	f
Caminho da Fernandega	15411	470110	f
Caminho da Igreja	15412	470110	f
Caminho da Ladeira	15413	470110	f
Caminho da Ladeira da Praia	15414	470110	f
Caminho da Lomba	15415	470110	f
Caminho da Lomba da Esplamaça	15416	470110	f
Caminho da Lomba do Facho	15417	470110	f
Caminho da Ramada do Chão Frio	15418	470110	f
Caminho da Relva	15419	470110	f
Caminho da Ribeira	15420	470110	f
Caminho da Rocha Vermelha	15421	470110	f
Caminho das Largas	15422	470110	f
Caminho de Trás da Igreja	15423	470110	f
Caminho do Chão Frio	15424	470110	f
Caminho do Facho	15425	470110	f
Caminho do Pouço do Concelho	15426	470110	f
Caminho dos Moinhos da Lomba	15427	470110	f
Caminho Novo	15428	470110	f
Canada da Lomba	15429	470110	f
Canada da Ribeira	15430	470110	f
Canada das Largas	15431	470110	f
Canada do Pouço do Concelho	15432	470110	f
Estrada da Fernandega	15433	470110	f
Estrada Nova da Fernandega	15434	470110	f
Fundo da Areia	15435	470110	f
Fundo da Praça	15436	470110	f
Fundo da Praia	15437	470110	f
Ladeira da Praia	15438	470110	f
Largo da Igreja	15439	470110	f
Lomba	15440	470110	f
Lomba da Esplamaça	15441	470110	f
Lomba da Praia	15442	470110	f
Lomba do Facho	15443	470110	f
Lugar da Fernandega	15444	470110	f
Lugar da Ribeira	15445	470110	f
Lugar da Ribeira do Chão Frio	15446	470110	f
Lugar de Chão Frio	15447	470110	f
Lugar do Chão Frio	15448	470110	f
Poço	15449	470110	f
Praia	15450	470110	f
Ramada da Estrada Nova	15451	470110	f
Ramada do Chão Frio	15452	470110	f
Ramal da Estrada Nova	15453	470110	f
Rocha Vermelha	15454	470110	f
Rua Atrás da Igreja	15455	470110	f
Rua da Areia	15456	470110	f
Rua da Igreja	15457	470110	f
Rua do Canto da Areia	15458	470110	f
Rua do Chão Frio	15459	470110	f
Rua do Major António José de Ávila	15460	470110	f
Rua do Meio	15461	470110	f
Rua do Vigário Silva Reis	15462	470110	f
Capelo	15463	470111	f
Arramada dos Espalhafatos	15464	470112	f
Calço	15465	470112	f
Caminho Novo	15466	470112	f
Caminho Velho	15467	470112	f
Canada da Barba feita	15468	470112	f
Canada da Bárbara	15469	470112	f
Canada da Bem Calada	15470	470112	f
Canada da Terça	15471	470112	f
Canada do Adro	15472	470112	f
Canada do Ambrósio Dutra	15473	470112	f
Canada do Arrendamento	15474	470112	f
Canada do Carlos	15475	470112	f
Canada do Concelho	15476	470112	f
Canada do Farol	15477	470112	f
Canada do Ferreira	15478	470112	f
Canada do José Alexandre	15479	470112	f
Canada do Matias	15480	470112	f
Canada do Pascoal	15481	470112	f
Canada dos Ramos	15482	470112	f
Canadinha	15483	470112	f
Canto	15484	470112	f
Chão da Cruz	15485	470112	f
Cruz	15486	470112	f
Entre as Casas	15487	470112	f
Lomba	15488	470112	f
Lugar da Ribeirinha	15489	470112	f
Lugar da Ribeirinha - Caminho Velho	15490	470112	f
Lugar da Ribeirinha - Estrada Real	15491	470112	f
Relvinha	15492	470112	f
Ribeira dos Ovos	15493	470112	f
Ribeira Funda	15494	470112	f
Ribeiro Seco	15495	470112	f
Rua da Igreja	15496	470112	f
Rua de Cima	15497	470112	f
Rua de Entre as Casas	15498	470112	f
Rua Direita	15499	470112	f
Rua do jogo	15500	470112	f
Rua do Valado	15501	470112	f
Casa Nova	15502	30817	f
Outeirinho	15503	30831	f
Ponte do Porto	15504	30117	f
Santa Maria de Ferreiros	15505	30101	f
Góis	15506	60604	f
S. João da Ribeira	15507	160735	f
Couto	15508	160728	f
Rua de Gonçalo Afonso	15509	160931	f
Couto	15510	160716	f
Santa Maria	15512	160119	f
Canada do Maroiço	15513	490101	f
Canto da Barroca	15514	490101	f
Canto da Rua do Rego	15515	490101	f
Canto da Travessa da Rua do Rego	15516	490101	f
Rua da Fonte	15517	490101	f
Rua da Fornina	15518	490101	f
Rua da Matriz	15519	490101	f
Rua da Vigia	15520	490101	f
Rua das Pedras	15521	490101	f
Rua do Maranhão	15522	490101	f
Rua do Mirouço	15523	490101	f
Rua do Outeiro	15524	490101	f
Rua do Porto da Casa	15525	490101	f
Rua do Rego	15526	490101	f
Rua do Ribeirão	15527	490101	f
Travessa da Rua da Matriz	15528	490101	f
Travessa da Rua do Porto das Casas	15529	490101	f
Travessa da Rua do Rego	15530	490101	f
Travessa do Maroiço	15531	490101	f
Fontão	15533	160721	f
Soeima	15534	40102	f
São Tiago	15535	160721	f
Santa Marta	15536	160928	f
S. Pedro de Vela	15537	10403	f
Padroso	15538	130320	f
São Bento das Freiras	15539	490291	f
Várzea do Douro	15540	181513	f
Igreja	15541	131110	f
Rua dos Biscainhos	15542	30352	f
Rua do Campo	15543	30352	f
Figueiredo	15544	30926	f
Lavandeira	15545	130504	f
Sobreira	15546	130504	f
Porta da Sé	15547	30352	f
Rua do Espírito Santo	15548	171423	f
Rua do Jazigo	15549	171423	f
Pedra da Costa	15550	130326	f
Rua da Cónega	15551	30352	f
Outeiro	15552	30730	f
Belver	15553	40310	f
S. Tiago	15554	30307	f
Santa Maria	15555	160737	f
S. Lourenço	15556	160920	f
São Pedro	15557	160932	f
S. Romão da Ucha	15558	31342	f
S, Tiago	15559	160519	f
Rubiães	15560	490338	f
São Pedro	15561	160520	f
S. Martinho	15562	160605	f
S. João	15563	160411	f
Santo Estevão	15564	160729	f
Cambuge	15566	490313	f
Boussas	15567	490291	f
Couviães	15570	490136	f
Brunhoso	15571	40804	f
São Veríssimo	15572	31342	f
São Tiago de Sande	15573	41235	f
Santo Estevão	15574	160718	f
Ovelha do Marão	15575	130133	f
Pinheiro	15576	30914	f
Medim	15577	171107	f
Outeiro	15578	171107	f
Quinta de Aldão	15579	30801	f
São Salvador	15580	161004	f
Bouro	15582	30856	f
Travassos	15583	31221	f
Rua dos Chãos	15584	30307	f
Agros	15585	160929	f
Areosa de Baixo	15586	160929	f
Vilarinho de baixo	15587	30925	f
Santa Marinha	15588	131630	f
S. Cosme	15589	131722	f
Viana do Castelo (Monserrate)	15590	160931	f
Rebordelo	15591	41219	f
Figueira	15592	490156	f
São Gonçalo	15593	130133	f
Santa Maria	15594	30286	f
São Pedro	15595	160906	f
São Tomé	15596	160716	f
São Salvador	15597	160602	f
Areias	15598	40301	f
Azenha	15599	30868	f
Santa Maria	15600	160909	f
Manadas	15601	450206	f
São Paio	15602	160520	f
São Pedro Velho	15603	40727	f
Barral	15604	160621	f
Sampaio	15605	41011	f
Cachão	15606	171216	f
Boavista	15607	30868	f
Soeima	15608	40114	f
Manadas	15609	450201	f
Rua Nova de Bento de Melo	15610	160931	f
Abaim	15611	160217	f
Avenida	15612	160217	f
Barrosa	15613	160217	f
Bebedouros	15614	160217	f
Caído	15615	160217	f
Calçada	15616	160217	f
Calvário	15617	160217	f
Campo do Castelo	15618	160217	f
Caniço	15619	160217	f
Carreira Velha	15620	160217	f
Carvoeiro	15621	160217	f
Castelo	15622	160217	f
Chão	15623	160217	f
Costa	15624	160217	f
Cruzeiro	15625	160217	f
Cubal	15626	160217	f
Erva Verde	15627	160217	f
Estação	15628	160217	f
Figueiras	15629	160217	f
Figueiras de Baixo	15630	160217	f
Figueiras de Cima	15631	160217	f
Forte da Lagarteira	15632	160217	f
Foz	15633	160217	f
Lagarteira	15634	160217	f
Lages	15635	160217	f
Lameira	15636	160217	f
Lomba	15637	160217	f
Louroso	15638	160217	f
Lousedo	15639	160217	f
Moureiro	15640	160217	f
Rocha	15641	160217	f
Sandia	15642	160217	f
Santo	15643	160217	f
Sobreira	15644	160217	f
Telheira	15645	160217	f
Vilarinho	15646	160217	f
Viso	15647	160217	f
Cabreira	15648	40107	f
São Vítor	15649	30351	f
Beira	15650	450206	f
Corvite	15651	30839	f
Cruz	15652	30868	f
São Julião	15653	160732	f
São Pedro	15654	160516	f
Casa da Quinta	15655	30410	f
Lama de Arcos	15656	170314	f
Lameiros	15657	30873	f
Covo	15658	30807	f
Quintã	15659	31108	f
Saldonha	15660	40110	f
Souto	15661	30906	f
Caldeses	15662	30918	f
Nozelos	15663	40902	f
Cobovila	15664	30506	f
Carvalho	15665	30906	f
Estrada	15666	30346	f
Cerejais	15667	40103	f
São Miguel	15668	160611	f
Possacos	15669	171216	f
Igreja (Porto)	15670	30717	f
Além	15671	30816	f
Igreja (Barreiro)	15672	30717	f
Vale da Madre	15673	40822	f
Vale de Esculca	15674	30506	f
Passos	15675	40724	f
Galegos	15676	31342	f
São Miguel	15677	160718	f
São Miguel	15678	160728	f
Casal de Estime (Carvalhos)	15679	30717	f
Rua D. Vasco	15680	110601	f
Santiago	15682	161013	f
São Paio	15683	160141	f
Igreja (Carreira)	15684	30717	f
Santa Eulália	15685	490338	f
Darque	15686	160911	f
Caminho do Sul	15687	440102	f
Poeiro	15688	30513	f
Cabo	15689	30505	f
Assento	15690	30514	f
Sanfins	15691	130328	f
Rua dos chãos de baixo	15693	30341	f
Rua Nova	15695	160735	f
Covas	15696	490336	f
Rua das Cangostas	15697	131214	f
S. Silvestre	15698	160750	f
Geraz	15699	490340	f
Geraz	15700	160930	f
Vilarinho	15701	160930	f
São Paio	15702	160918	f
Ranhadas	15703	30414	f
Rebuido Moure - Rendufinho	15704	30901	f
Vila Boa	15705	31219	f
Bairro da Corredoura	15706	40916	f
Genísio	15707	40605	f
Souto velho	15708	30925	f
Ferreiros	15709	30521	f
Augueiros	15710	30406	f
São Julião	15711	160813	f
Monteiras	15712	180314	f
Além	15713	30521	f
Mota	15714	30509	f
Sampaio	15715	30509	f
Cadeia da Vila de Torre de Moncorvo	15716	40916	f
zava	15717	490156	f
Zava	15718	490156	f
Figueira	15719	40810	f
Tronco	15720	170340	f
Gimonde	15721	40216	f
Sra. do Rosário - Matriz	15722	490403	f
Tamanhos	15723	91321	f
Igreja Matriz de Torre de Moncorvo	15724	40916	f
Ribamondego	15725	90614	f
S. Vicente de Areias	15726	31308	f
Mata de Lobos	15727	90410	f
Ligares	15728	40404	f
Alvarelhos	15729	171202	f
Cidadelhe	15730	91007	f
Casa da Misericordia de Torre de Moncorvo	15731	40916	f
S. Martinho	15732	490336	f
Igreja (Tuda)	15733	30717	f
Quinta da Laranjeira	15734	40916	f
Alvações do Corgo	15735	171101	f
Peso da Régua	15736	170807	f
Vinhais	15737	41235	f
Pombares	15738	40231	f
Linhares	15739	40308	f
Capela do Espirito Santo	15740	40916	f
Vimioso	15741	41114	f
Passos	15742	31113	f
Torre	15743	30903	f
Bainhos - Monde	15744	490416	f
Outeiro	15745	30925	f
São Miguel	15746	131018	f
São Pedro	15747	160147	f
Santa Comba	15748	160742	f
Rua Nova	15749	40916	f
Rua dos Sapateiros	15750	40916	f
Sampaio	15751	30522	f
Paçô	15752	30518	f
Rua do Espirito Santo	15753	40916	f
Rua da Rapadoura	15754	40916	f
Rua das Barreiras	15755	40916	f
Rua da Fonte do Concelho	15756	40916	f
Rua Direita	15757	40916	f
Rua do Outeiro	15758	40916	f
Sé	15759	30307	f
Rua da Salgada	15760	40916	f
Rua da Boavista	15761	40916	f
Casa de Ambrosio de Arosa	15762	40916	f
Rua do Cabo	15763	40916	f
Atães	15764	30511	f
Escoivo	15765	30522	f
Peneireiros	15766	30522	f
Rio Mel	15767	91316	f
Rio de Mel	15768	91316	f
Senhora dos Anjos	15770	420101	f
São Tomé	15771	160624	f
São Vicente	15772	160143	f
São Martinho	15773	30521	f
São Pedro	15774	60504	f
Rua do Poço	15775	40916	f
São Salvador	15776	160744	f
Cortiços	15777	40510	f
Riodades	15778	181507	f
Ponte	15779	40916	f
Ribeira	15780	40916	f
Hospital	15781	40916	f
Vilar de Fonte Arcada	15782	490360	f
Senhora. do Rosário	15783	420101	f
Renda	15784	30807	f
S.Tiago de Boubão	15785	160810	f
ErErmida de Santo Homem Bom	15786	160919	f
Ermida de Santo Homem Bom	15787	160919	f
Bragança	15788	40242	f
Igreja (Lage)	15790	30717	f
Fonte do Carvalho	15791	40916	f
Pegarinhos	15792	170108	f
Rua do Corredio	15793	160931	f
Bouça	15794	30832	f
Freixiel	15795	41005	f
Barrais	15796	40916	f
Guarda	15797	490225	f
Couto de Aboim	15798	490337	f
Portela	15799	40909	f
Senhora da Encarnação	15800	490333	f
S. Miguel de Roriz	15801	31342	f
Borbão	15802	160810	f
Santa Comba	15803	160150	f
São Julião	15804	160921	f
Mogo de Malta	15805	40310	f
São Domingos	15806	160931	f
Rua de Francisco Enes Bravo	15807	160931	f
S. Salvador	15808	160311	f
Rua Cega	15809	160931	f
São Miguel	15811	160805	f
Porta da Piedade	15812	160931	f
Rebordãos	15815	40236	f
Roios	15816	41009	f
Samaiões	15817	170326	f
Santa Comba	15818	41012	f
Loivos	15819	170315	f
Nossa Senhora Nova	15820	91302	f
Rua do Pombal	15821	160931	f
Souto	15822	30333	f
Assento	15823	30333	f
Rua	15824	30333	f
Burgo	15825	30855	f
S. Cibrão	15826	171224	f
Rua do Trigo	15827	160931	f
Santa Eulália	15828	160737	f
São Pedro	15829	160703	f
Porta de Santiago	15830	160931	f
Santas Marinha	15831	130708	f
Martim	15832	170701	f
Martim	15833	160205	f
Finisterra	15835	490175	f
Vila Longa Viseu	15836	181712	f
Rua da Lamega	15838	160931	f
Fonte do Mato	15839	440103	f
Caminho da Lagoa	15840	440103	f
Lamego	15841	490360	f
Lagoa	15842	440103	f
Rua da Eira	15843	160931	f
Bobadela	15844	170304	f
Lugar de Bobadela	15845	170304	f
Cruzeiro	15846	30868	f
Fornos	15847	490344	f
Tornadouro	15848	30506	f
Felgueiras	15849	130324	f
Casal	15850	30854	f
Igreja (Cima do Caminho)	15852	30717	f
Caminho do Barreiro	15854	440103	f
Marmeleiro	15855	40916	f
Carlão	15856	170103	f
Rua de António Colaço	15857	160931	f
São Silvestre	15858	31108	f
Quinta de Santo António	15859	30402	f
Mogadouro	15860	490156	f
Rua Direita	15862	440103	f
Caminho da Fonte do Mato	15863	440103	f
Em sua casa	15864	40916	f
Pedras Brancas	15865	440103	f
Senhora das Neves	15867	160906	f
Souto	15868	160744	f
Alfama	15869	490254	f
Frechas	15870	40716	f
S. Paio	15871	11313	f
São João do Souto	15872	30341	f
S. Paio	15873	30235	f
Santa Marinha	15874	30831	f
São Lourenço	15875	160314	f
S. João de Arcos	15876	490136	f
S. Estevão	15877	160718	f
Caminho de Miguel Pereira	15878	440103	f
Madalena	15879	160119	f
Cordoaria	15880	131204	f
São Miguel	15881	160939	f
Esteiro	15882	30717	f
Pedroso	15883	30517	f
Celeiro	15884	30868	f
Quelha de Roque Gomes	15885	160931	f
Debaixo da ponte do Sabor	15886	40916	f
S. Romão	15887	160923	f
Vale	15888	30717	f
Carmo Velho	15889	160931	f
Quelha das Laranjeiras	15890	160931	f
Assento	15891	30873	f
Vilar de Maçada	15892	170118	f
Cancela	15893	30717	f
Igreja	15894	30807	f
Recolhimento de Santo António ou de S. NIcolau	15895	40916	f
Rua de João Loução	15896	160931	f
Regadas	15897	30709	f
Santa Maria da Palmeira	15898	490413	f
Mogadouro	15899	40825	f
Pevidém	15900	30854	f
Alemparte	15901	30514	f
Breia	15902	30514	f
Moreira	15903	30521	f
Santa Maria	15905	490330	f
Santa Maria de Paços	15906	490332	f
São João	15907	160924	f
Loreto	15908	490254	f
S. Mamede do Coronado	15909	131215	f
São Paio	15910	160427	f
Abelheira	15911	160931	f
Santa da Vila	15912	420101	f
Souto	15913	420101	f
Sra. dos Anjos	15914	420101	f
S. Salvador	15915	160750	f
Quintã	15916	30509	f
Penaformosa	15917	170903	f
Felgueiras	15919	30807	f
Felgueiras	15920	40907	f
Torre	15921	30518	f
Linhares-Celorico da Beira	15922	90308	f
Paradinha	15923	180712	f
Quinta de Mendel	15924	40916	f
Recolhimento de Santo Antonio do Sacramento / S. Nicolau	15925	40916	f
Corredoura	15926	40916	f
R. do Corredio	15927	160919	f
Outeiro	15928	450201	f
Caminho Bom	15929	450201	f
Caminho da Fajã	15930	450201	f
Carviçais	15931	40908	f
Açoreira	15932	40908	f
Torre de Moncorvo	15933	40908	f
Caminho das Ribeiras	15934	450201	f
Chaves	15935	170333	f
Ribeira dos Terreiros	15936	450201	f
Freixo de Espada Cinta	15937	40402	f
Larinho	15938	40916	f
Caminho Grande	15939	450201	f
Terras	15940	450201	f
Canada do Jogo	15941	450201	f
Cruz das Ladeiras	15942	450201	f
Penedo do Cão	15943	450201	f
Canada da Ermida	15944	450201	f
Barbaria (Magreb)	15945	160919	f
Santa Luzia	15946	30506	f
Lage	15947	170501	f
R. das Rosas	15948	160919	f
Travessa Garcia Lopes	15949	160919	f
Bairro de S. Catarina	15950	160919	f
Campo da Penha de França	15951	160919	f
Canal	15952	160919	f
Canal (da Mancha ?)	15953	160919	f
R. Pedro de Melo	15954	160919	f
Ribeira	15955	30520	f
Peitimão	15956	30520	f
Calheta, Calheta, São Jorge (R.A.A)	15957	450101	f
Relva	15958	420315	f
Calheta	15959	450101	f
Velas	15960	450206	f
Ilha S. Cristóvão	15961	160919	f
Br. - Baía	15962	160919	f
Brasil	15963	160919	f
Rua direita de Santa Catarina	15964	160919	f
No mar num Galeão do Rei	15965	160919	f
Caminha	15966	160919	f
Ribeira de Viana	15967	160919	f
Reguengos	15968	30521	f
R. da Lama	15969	160919	f
No mar em viagem p/ Baía	15970	160919	f
Lugar de Almeida	15971	450204	f
Rio Sabor	15972	40916	f
Quelha da Água	15973	160919	f
S. Domingos	15974	160919	f
R. das Vacas ou  R. da Esperança	15975	160919	f
Rua de  Santa Catarina	15976	160919	f
Rua Francisco Enes Bravo	15977	160919	f
São Tomé	15978	160919	f
Costa do Brasil	15979	160919	f
Santo Homem Bom	15980	160919	f
Santo António	15981	450202	f
Monserrate	15982	160919	f
R. do Trigo	15983	160919	f
Casas do Marquês	15984	160919	f
Robaleira	15985	160919	f
Monserrate	15986	160931	f
India	15987	160919	f
carviçais	15988	40907	f
Felgueiras	15989	40905	f
R. São Teotónio	15990	160919	f
Deocriste	15991	160913	f
R. do Eirado Santo Homem Bom	15992	160919	f
Vila Franca do Lima	15993	160919	f
De trás S. Domingos	15994	160919	f
R. do Tourinho	15995	160919	f
R. Pedro Martins	15996	160919	f
Eirado de S. Domingos	15997	160919	f
Silves	15998	160411	f
Ermida de S. Tiago	15999	160919	f
Travessa do Marquês	16000	160919	f
Santiago	16001	160919	f
De trás S. Catarina	16002	160919	f
Junto a S. Domingos	16003	160919	f
No Rio Lima	16004	160919	f
Quelha de S. Domingos	16005	160919	f
Lagoa	16006	30701	f
Quelha do Borralho	16007	160919	f
No mar, vindo de Pernambuco	16008	160919	f
Penadono	16009	490378	f
Meda	16010	90912	f
R. Bento de Melo	16011	160919	f
Rua do Robim	16012	160919	f
??	16013	160919	f
Junto Santo Homem Bom	16014	160919	f
Quelha do Miranda	16015	160919	f
R. do Loureiro	16016	160919	f
R. do Mata Quatro	16017	160919	f
Porta da Ribeira	16018	160919	f
Em cas de Domingos Martins, pasteleiro	16019	160919	f
Frente S. Domingos	16020	160919	f
Cruzeiro S. Domingos	16021	160919	f
Souto de Velha	16022	40908	f
Ao cruzeiro S. Domingos	16023	160919	f
Vivia no Castelo	16024	160919	f
No Castelo	16025	160919	f
Lg. Subarribeira	16026	160919	f
Travessa do Miranda	16027	160919	f
Torre da Roqueta	16028	160919	f
Junto a S. Catarina	16029	160919	f
São Cristóvão	16030	160729	f
Travessa do Robim	16031	160919	f
Santa Luzia	16032	160919	f
Rua Bento de Melo	16033	160931	f
Ribeira da Areia	16034	450202	f
porta da Igreja Matriz	16035	160931	f
Junto Igr. Monserrate	16036	160919	f
Santa Marinha	16037	160704	f
R. S. Catarina defronte do calhau	16038	160919	f
No Mar vinda da Baía - Br.	16039	160919	f
Quelha do Penedo	17026	160919	f
Defronte Casa do Marquês	17027	160919	f
3º arco Travessa da Água	17028	160919	f
R. do Salgueiro	17029	160919	f
Carreira	17030	160931	f
3.º Arco de Amaro Afonso	17031	160919	f
R. dos Tanoeiros	17032	160919	f
Passagem	17033	30511	f
Lamas	17034	130411	f
Gramido	17035	130411	f
Giesta	17036	130411	f
Granja	17037	131203	f
Pinheiro de Além	17039	130411	f
Ancede	17040	131003	f
Lagoa	17041	130411	f
Travessa S. Domingos	17042	160919	f
Cancelos	17043	30723	f
Frente Cruzeiro S. Catarina	17044	160919	f
Veiga	17045	30521	f
Queirões	17046	30506	f
Cozinha	17047	30717	f
Galiza	17048	160919	f
Rua de S. António	17049	160931	f
Caminho do Forno	17050	160931	f
Fonte Pedrinha	17051	130411	f
Guarda	17052	490228	f
Lama	17053	30520	f
S. Catarina indo p/ castelo	17054	160919	f
Travessa Bento de Melo	18047	160919	f
EiEirado de Santo Homem Bom	18048	160919	f
R. do Souto	18049	160919	f
Junto casas do Gandano	18050	160919	f
Pedraído	18051	30873	f
Quinteiro	18052	30840	f
Frente Igr. Monserrate	18053	160919	f
1.º arco de frente S. Homem Bom	18054	160919	f
3.º arco S. Catarina	18055	160919	f
Peirão de Santa Catarina	18056	160919	f
Beco do Salgueiro	18057	160919	f
R. Santo Homem Bom	18058	160919	f
Travessa do Caminhão	18059	160919	f
R. Grande	18060	160919	f
Travessa Pedro Gonçalves Barbosa	18061	160919	f
Travessa do Carvalho	18062	160919	f
R. Paulo Jorge	18063	160919	f
Carvalhal	18064	130326	f
Travessa de Santa Clara	19047	160919	f
Baiona	19048	160931	f
Travessa do Mata quatro	19049	160919	f
Arco de Amaro Afonso	19050	160919	f
De trás de Monserrate	19051	160919	f
Recolhimento de Santiago	19052	160919	f
Na Sua Quinta	19053	160919	f
Loja de  Maria Martins	19054	160919	f
Loja de Maria Martins	19055	160919	f
R. dos Crúzios	19056	160919	f
De fronte ao Cruzeiro S. Domingos	19057	160919	f
Junto à casa do Marquês	19058	160919	f
Travessa do Rabeador	19059	160919	f
Rua Santa Luzia	19060	160919	f
Fonte dos Manjovos	19061	160919	f
Convento dos Crúzios	19062	160919	f
Gatão	19063	130102	f
Fortunhos	19064	30516	f
Quelha do Padre Monteiro	19065	160919	f
No mar vindo de Lisboa	19066	160919	f
Quelha dos Gouveias	19067	160931	f
Porta de São João	19068	160931	f
Fajã do Negro	19069	450201	f
Pico dos Alhos	19071	440103	f
Rua da Lama	19072	160919	f
Valpaços	19073	171228	f
Rua da Francesa	19074	160931	f
Biscoitos	19075	450101	f
Arquipélago de Cabo Verde	19076	160931	f
Moinhos de Pondres	19077	30721	f
Colmeais	19078	40102	f
Rua de S. Vicente	19079	160931	f
Castelo S. Tiago da Barra	19080	160919	f
Rua de Martim Velho	19081	160931	f
Ribeirinha	19082	430104	f
Praça das Hortaliças	19083	160931	f
Estremoz	19084	70403	f
Manuel Ribeiro	89858	160931	f
Cabada Domingos Vieira	89859	460102	f
Bemposta	89860	40802	f
Rossadas	89861	30416	f
Prado	89862	30509	f
Bouça	89863	30516	f
Eiras	89864	30509	f
Rua de Darque	89865	160931	f
Burgo	89866	182006	f
R. de Altamira	89867	160919	f
São Miguel	89868	490174	f
Chaves	89869	170330	f
Vilarelhe	89870	30732	f
Vilar	89871	30520	f
Vales	89872	40116	f
Praça das Couves	89873	160931	f
Caminho do Meio	89874	440103	f
Rua Paulo Jorge	89875	160931	f
Cimo de Vila	89876	30519	f
Pinhó	89877	30521	f
Oliveiras	89878	30511	f
Barrozinho	89879	30520	f
São Martinho	89880	130123	f
Caminho de Manuel Gaspar	89881	440101	f
Caminho de Cima	89882	440102	f
Carvalhal	89883	30509	f
Quinta do Travelo, Estevais	89884	40902	f
Terra-Chã	89885	430104	f
Caminho das Pedras Brancas	89886	440102	f
Vila cortes	89887	90619	f
Cortinhas	89888	30807	f
Caminho do Pontal	89889	440101	f
De frente cruzeiro S. Domingos	89890	160919	f
Frente a S. Catarina	89891	160919	f
R. S. Catarina de baixo	89892	160919	f
Cabreira	89893	90206	f
Rua dos Crúzios	89894	160919	f
De fronte Penha de França	89895	160919	f
Varzielas	89896	30925	f
Carmo	89897	160931	f
Ponte	89898	30903	f
Gandra	89899	30868	f
Arco de Santo Homem Bom	89900	160919	f
R. S. Catarina de Cima	89901	160919	f
Rapido	89902	30721	f
Rua dos Torneiros	89903	160919	f
Rua dos Tanoeiros	89904	160919	f
Quelha do Ordones	89905	160919	f
Rua da Piedade	89906	160919	f
Rua dos Tanoeiros	89907	160931	f
Travessa de Paredes	89908	160919	f
Guimarães	89909	30863	f
Rua Martim Velho, Darque	89910	160931	f
Rua da Picota	89911	160919	f
Rua de Santa Catarina, junto às casas do Marquês	89912	160919	f
Valdante	89913	30807	f
Quinta de Capareiros	89914	160906	f
Gebelim	89915	40106	f
Souto	89916	181209	f
Outeiro	89917	30721	f
Rua da Porta da Ribeira	89918	160919	f
Moinho do Barreiro	89919	30721	f
Rua de São Tomé com Santa Catarina	89920	160919	f
Penedo da Rua do Loureiro	89921	160919	f
R. do Miranda	89922	160919	f
Meio da Barra de Viana	89923	160919	f
Queimadela - Portelo	89924	30721	f
R. do Loureiro-Trav. do Penedo	89925	160919	f
Portelinha	89926	30520	f
Abaixo de Manjovos	89927	160919	f
Adiante Santo Homem Bom	89928	160919	f
assento	89929	30872	f
Rua de Seitãs	89930	160931	f
No mar afogado num navio que deu à costa	89931	160919	f
De fronte S. Homem Bom	89932	160919	f
Quelha do Brochado	89933	160919	f
Travessa do Salgueiros	89934	160919	f
Travessa de Roque Gomes	89935	160919	f
Rua da Ribeira	89936	160919	f
Subaribeira	89937	160919	f
Pinhel	89938	91017	f
Rua Nova de S. Amaro	89939	160931	f
Argaçosa	89940	160917	f
Canada das Almas	89941	450201	f
Em casa de Inácio Dias	89942	160919	f
Ribeira do jogo	89943	450201	f
Terreiros	89944	450201	f
Caminho da Ermida	89945	450201	f
Caminho da Igreja	89946	450201	f
Fortaleza Santiago da Barra	89947	160919	f
Moirama	89948	160919	f
Quelha de Gontim	89949	160931	f
De trás S. Clara	89950	160919	f
Em casa de Manuel Lopes Coelho	89951	160919	f
Cimo da Costa de S. Gregório	89952	40902	f
Quinta da Póvoa	89953	40902	f
Travessa Roque de Barros	89954	160931	f
Gandra	89955	31110	f
Quinta dos Nozelos	89956	40902	f
Caminho das Pias	89957	450201	f
R. do Marquês	89958	160919	f
Ribeira adiante do Arco	89959	160919	f
R. de Santiago	89960	160919	f
Caminho das Ladeiras	89961	450201	f
R. S. Sebastião	89962	160919	f
R. do Malho	89963	160919	f
De trás Santo Homem Bom	89964	160919	f
R. de Altamira	89965	160931	f
Frente a Santiago	89966	160919	f
Rua que vai para o castelo	89967	160919	f
Condeixa - Coimbra	89968	160919	f
Fontelas	89969	40902	f
Casa da Torre	89970	160211	f
Lugar da Aldeia	89971	160211	f
Lugar da Anta	89972	160211	f
Lugar da Cancela	89973	160211	f
Lugar da Estação	89974	160211	f
Lugar da Fonte	89975	160211	f
Lugar da Graça	89976	160211	f
Lugar da Ramalhosa	89977	160211	f
Lugar da Roda	89978	160211	f
Lugar da Roda	89979	160211	f
Lugar da Vacariça	89980	160211	f
Lugar das Eiras	89981	160211	f
Lugar das Escalenhas	89982	160211	f
Lugar das Escalenhas	89983	160211	f
Lugar das Fontainhas	89984	160211	f
Lugar das Lages	89985	160211	f
Lugar de Bacelos	89986	160211	f
Lugar de Marrocos	89987	160211	f
Lugar de Marrocos	89988	160211	f
Lugar do Couto	89989	160211	f
Lugar do Covelo	89990	160211	f
Lugar do Esqueiro	89991	160211	f
Lugar do Pereiro	89992	160211	f
Lugar do Sobreiro	89993	160211	f
Regueiro	89994	160211	f
Lugar de Coura	89995	160215	f
Arga	89996	160202	f
Ausente	89997	160202	f
Barziela	89998	160202	f
Calzinha	89999	160202	f
Campo da Velha	90000	160202	f
Campo do vale	90001	160202	f
Casa Nova	90002	160202	f
Castelo	90003	160202	f
Castelo	90004	160202	f
Castinheira	90005	160202	f
Corga	90006	160202	f
Cortinha	90007	160202	f
Coutada	90008	160202	f
Covelo	90009	160202	f
Covelo	90010	160202	f
Eirado	90011	160202	f
Eirinha	90012	160202	f
Figueira	90013	160202	f
Figueiras	90014	160202	f
Fochaquinho	90015	160202	f
Fora	90016	160202	f
Gamozal	90017	160202	f
Ganzal	90018	160202	f
Ganzal	90019	160202	f
Giesteira	90020	160202	f
Lapeira	90021	160202	f
Leirado	90022	160202	f
Lombada	90023	160202	f
Lombinho	90024	160202	f
Marco	90025	160202	f
Meijão	90026	160202	f
Meijãozinho	90027	160202	f
Pedra	90028	160202	f
Penedo	90029	160202	f
Penedo	90030	160202	f
Pontelhinha	90031	160202	f
Presas	90032	160202	f
Rio de Abutres	90033	160202	f
Sabugueiro	90034	160202	f
Sobral	90035	160202	f
Solheirinho	90036	160202	f
Sub a Veiga	90037	160202	f
Real	90038	161004	f
Felgueiras	90039	160204	f
Santo Aginha	90040	160204	f
Afogado	90041	160210	f
Agrobom	90042	160210	f
Alentejo	90043	160210	f
Assassinada	90044	160210	f
Avareira	90045	160210	f
Avelheira de Dem	90046	160210	f
Barreiros	90047	160210	f
Carejos	90048	160210	f
Carotes	90049	160210	f
Carvalho de Dem	90050	160210	f
Casal	90051	160210	f
Castanheiros	90052	160210	f
Cerejeira	90053	160210	f
Charco	90054	160210	f
Codessal	90055	160210	f
Costinha	90056	160210	f
Cruzeiro	90057	160210	f
Cruzes	90058	160210	f
Dem	90059	160210	f
Favelho	90060	160210	f
Fora	90061	160210	f
Gondar	90062	160210	f
Hospital de Lisboa	90063	160210	f
Hospital Real de Lisboa	90064	160210	f
Laje	90065	160210	f
Lameira	90066	160210	f
Laranjeira	90067	160210	f
Lavegadas	90068	160210	f
Lavercas	90069	160210	f
Loureira	90070	160210	f
Lourido	90071	160210	f
Orbacém	90072	160210	f
Outeiro	90073	160210	f
Painçal de Dem	90074	160210	f
Pé do Homem	90075	160210	f
Poça	90076	160210	f
Pombal de Dem	90077	160210	f
Portela	90078	160210	f
Portelo da Veiga	90079	160210	f
Portos	90080	160210	f
Presa	90081	160210	f
Quelha	90082	160210	f
Rua	90083	160210	f
Rua de Dem	90084	160210	f
São Gonçalo	90085	160210	f
Sobreirinho	90086	160210	f
Valado	90087	160210	f
Vieiro	90088	160210	f
Viso	90089	160210	f
Vizinho-Dem	90090	160210	f
Boi Morto	90091	160213	f
Boucinha de Dem	90092	160213	f
Pereiro de Dem	90093	160213	f
Vila Verde	90094	160214	f
Tresâncora	90095	160920	f
Hospital de Viana	90096	160931	f
Rua da Misericórdia	90097	160207	f
Rua da Palha	90098	160207	f
Rua do Vau	90099	160207	f
Pereira	90100	160208	f
Porto	90101	160208	f
Afogado	90102	160212	f
Alentejo	90103	160212	f
Assassinado	90104	160212	f
Bairro	90105	160212	f
Barbanços	90106	160212	f
Botão	90107	160212	f
Calvário	90108	160212	f
Cancela	90109	160212	f
Carvalhos	90110	160212	f
Casal	90111	160212	f
Cavada	90112	160212	f
Crasto	90113	160212	f
Cruzeiro	90114	160212	f
Ferro	90115	160212	f
Ferro	90116	160212	f
Fonte	90117	160212	f
Fora	90118	160212	f
Galé	90119	160212	f
Gamoso	90120	160212	f
Gateira	90121	160212	f
Guerra	90122	160212	f
Jugada	90123	160212	f
Junto à Igreja	90124	160212	f
Lages	90125	160212	f
lugar de Fontela	90126	160212	f
Lugar de Santana	90127	160212	f
Lugar do Portinho	90128	160212	f
Monte	90129	160212	f
Piolhosa	90130	160212	f
Prado	90131	160212	f
Presa	90132	160212	f
Regueiro	90133	160212	f
Regueiro	90134	160212	f
Rua da Cancela	90135	160212	f
Rua da Chaminé	90136	160212	f
Rua da Galé	90137	160212	f
Rua da Gateira	90138	160212	f
Rua da Igreja	90139	160212	f
Rua da Jugada	90140	160212	f
Rua da Piolhosa	90141	160212	f
Rua da Presa	90142	160212	f
Rua de Barbanços	90143	160212	f
Rua de Cabanelas	90144	160212	f
Rua do Calvário	90145	160212	f
Rua do Carabunheiro	90146	160212	f
Rua do Carvoeiro	90147	160212	f
Rua do Cruzeiro	90148	160212	f
Rua do Prado	90149	160212	f
Rua do Salgueiro	90150	160212	f
Rua do Sameiro	90151	160212	f
Rua do Tostado	90152	160212	f
Rua Nova	90153	160212	f
Salgueiro	90154	160212	f
Sameiro	90155	160212	f
Sobrado	90156	160212	f
Souto	90157	160212	f
Testado	90158	160212	f
Torre	90159	160212	f
Torre	90160	160212	f
Veiga	90161	160212	f
Barreiros	90162	160218	f
Côrrego	90163	160219	f
São Julião	90164	160732	f
Castanheiros	90165	160202	f
Aldeia	90166	160204	f
Alentejo	90167	160204	f
Ausente	90168	160204	f
Bajunca	90169	160204	f
Castelinho	90170	160204	f
Castelo	90171	160204	f
Cruz Velha	90172	160204	f
Exercito	90173	160204	f
Fora	90174	160204	f
Giesteira	90175	160204	f
Giesteira	90176	160204	f
Giesteira	90177	160204	f
Lugar de Baixo	90178	160204	f
Lugar de Eulália	90179	160204	f
Outeiro	90180	160204	f
Outeiro	90181	160204	f
Outeiro	90182	160204	f
Rio	90183	160204	f
Torre	90184	160204	f
Vale	90185	160204	f
Valescuro	90186	160204	f
Avelheira	90187	160213	f
Dem	90188	160213	f
Castanheirinho	90189	160216	f
Ribeiro	90190	160216	f
Pedrulhos	90191	160920	f
Barreira	90192	161004	f
Ribeira	90193	131213	f
Currais	90194	160201	f
Ausente	90195	160203	f
Bouça	90196	160203	f
Cachada	90197	160203	f
Casamento de Maria Alves	90198	160203	f
Eiradinho	90199	160203	f
Eiradinho	90200	160203	f
Eiradinho	90201	160203	f
Fora	90202	160203	f
Forno	90203	160203	f
Gandra	90204	160203	f
Lages	90205	160203	f
Laje	90206	160203	f
Loureiros	90207	160203	f
Meijão	90208	160203	f
Meijão	90209	160203	f
Recunco	90210	160203	f
Souteiro	90211	160203	f
Souteiro	90212	160203	f
Sub-Outeiro	90213	160203	f
Tojal	90214	160203	f
Torno	90215	160203	f
Orbacém	90216	160209	f
Cerquido	90217	160717	f
Milheiros	90218	160750	f
São Lourenço	90219	160920	f
Abotega	90220	161004	f
Pereira	90221	161004	f
Vilares	90222	161004	f
Vilarinho	90223	161004	f
Vilarinho	90224	161004	f
Pereiro	90225	161012	f
Ramalhal	90226	161012	f
Belide	90227	30707	f
Passo	90228	30707	f
Bouças	90229	30709	f
Bouça	90230	30710	f
Fundo de Vila	90231	30710	f
Paço	90232	30710	f
Quintão	90233	30710	f
Fundevila	90234	30714	f
Barrosa	90235	30726	f
Fonte	90236	30726	f
Pena de Galo	90237	30726	f
Ribeira	90238	30726	f
Carvalhinho	90239	30730	f
Casal	90240	30730	f
Trás do Paço	90241	30730	f
Cancela	90242	30803	f
Sá	90243	30803	f
Souto	90244	30803	f
Agrafonte	90245	30809	f
Assento	90246	30809	f
Cima de Eiriz	90247	30809	f
Venda da Serra	90248	30809	f
Rua Direita da Cruz de Pedra	90249	30813	f
Galhada	90250	30818	f
Galhufe	90251	30818	f
Paço	90252	30818	f
Ribeiro	90253	30818	f
Aldeia	90254	30824	f
Arieiro	90255	30824	f
Assento	90256	30824	f
Baixinha	90257	30824	f
Baluzal	90258	30824	f
Barreiras	90259	30824	f
Barreirinho	90260	30824	f
Barreiro	90261	30824	f
Barreiro de Baixo	90262	30824	f
Barreiro de Cima	90263	30824	f
Barreiro Pica	90264	30824	f
Barreiro Pinheiro	90265	30824	f
Boavista	90266	30824	f
Bom Viver	90267	30824	f
Bouça	90268	30824	f
Bouça da Fonte	90269	30824	f
Bouça da Pupa	90270	30824	f
Bouça do Fojo	90271	30824	f
Boucinhas	90272	30824	f
Bouço	90273	30824	f
Burgueiros	90274	30824	f
Cabo	90275	30824	f
Cano	90276	30824	f
Carreiro	90277	30824	f
Casa Nova	90278	30824	f
Casal	90279	30824	f
Casal do Barreiro	90280	30824	f
Castanheira	90281	30824	f
Castelos	90282	30824	f
Cortes	90283	30824	f
Corujeiras	90284	30824	f
Couro	90285	30824	f
Devesa	90286	30824	f
Devesa de S. Paio	90287	30824	f
Eido Baixo de S. Paio	90288	30824	f
Eido Dentro de S. Paio	90289	30824	f
Eira	90290	30824	f
Faia	90291	30824	f
Ferus	90292	30824	f
Fervença	90293	30824	f
Fojo	90294	30824	f
Fonte	90295	30824	f
Fonte Bouça	90296	30824	f
Fonte Donega	90297	30824	f
Fonte Quinta	90298	30824	f
Freixieiro	90299	30824	f
Gaia	90300	30824	f
Igreja	90301	30824	f
Incido	90302	30824	f
Leira	90303	30824	f
Lido de Baixo	90304	30824	f
Mata	90305	30824	f
Matamá	90306	30824	f
Outeirinho	90307	30824	f
Outeiro	90308	30824	f
Outeiro Baixo	90309	30824	f
Paço	90310	30824	f
Pica	90311	30824	f
Pinheiro	90312	30824	f
Porta	90313	30824	f
Pousadouro	90314	30824	f
Pupa	90315	30824	f
Quinhões	90316	30824	f
Quinteiro	90317	30824	f
Ramada	90318	30824	f
Ramalhada	90319	30824	f
Ranhadouro	90320	30824	f
Redolho	90321	30824	f
Retorta	90322	30824	f
Retorta de Cima	90323	30824	f
Retortinha	90324	30824	f
Ribeiro	90325	30824	f
Rio	90326	30824	f
S. Paio	90327	30824	f
Santa Paula	90328	30824	f
Sebelo	90329	30824	f
Serviçaria	90330	30824	f
Solta	90331	30824	f
Soutinho	90332	30824	f
Souto	90333	30824	f
Temporeira	90334	30824	f
Várzea	90335	30824	f
Velho Sol	90336	30824	f
Vinha	90337	30824	f
Casal da Bouça	90338	30830	f
Casal do Rio	90339	30834	f
Campo da Feira	90340	30863	f
Assento	90341	30864	f
Casal do Carvalho	90342	30864	f
Telhado	90343	30864	f
Leiras	90344	30867	f
Outeiro	90345	30867	f
Carral Fechado	90346	31407	f
Campo da Feira	90347	130133	f
Quinta de Castro	90348	130304	f
Bouça	90349	130323	f
Outeiro	90350	130332	f
Prelada	90351	131211	f
Ferreiros (Santa Maria)	90352	30109	f
Vila Cova (Santa Maria)	90353	30286	f
Outeiro (Santa Maria)	90354	30410	f
Passos (São Sebastião)	90355	30412	f
Roda de Basto	90356	30519	f
Aboim	90357	30701	f
Arieiro da Mós	90358	30701	f
Barbeita	90359	30701	f
Barbeita de Baixo	90360	30701	f
Barbeita de Cima	90361	30701	f
Barreiras de Aboim	90362	30701	f
Cabo da Lagoa	90363	30701	f
Cancela de Figueiró	90364	30701	f
Carvalhas de Mós	90365	30701	f
Carvalho	90366	30701	f
Carvalho de Aboim	90367	30701	f
Casa Nova da Mós	90368	30701	f
Cortinhal de Aboim	90369	30701	f
Ferreiro de Aboim	90370	30701	f
Figueiró	90371	30701	f
Figueiró do Monte	90372	30701	f
Fonte de Mós	90373	30701	f
Forno de Mós	90374	30701	f
Fundevila de Aboim	90375	30701	f
Igreja	90376	30701	f
Laje da Lagoa	90377	30701	f
Lameira de Aboim	90378	30701	f
Lavadouro da Mós	90379	30701	f
Madeiros de Aboim	90380	30701	f
Monte da Lagoa	90381	30701	f
Mós	90382	30701	f
Outeiro	90383	30701	f
Outeiro de Aboim	90384	30701	f
Portela de Aboim	90385	30701	f
Quinteiro de Aboim	90386	30701	f
Residência Paroquial	90387	30701	f
Ribeiro de Mós	90388	30701	f
Rochado de Mós	90389	30701	f
Soterrado de Aboim	90390	30701	f
Roda de Fafe	90391	30709	f
Caldelas (São Tomé)	90393	30808	f
Roda de Guimarães	90394	30834	f
Pinheiro (Divino Salvador)	90395	30836	f
Roda da Póvoa de Lanhoso	90396	30919	f
Campos (São Vicente)	90397	31103	f
Mosteiro (São João Baptista)	90398	31110	f
Pinheiro (Santa Maria)	90399	31112	f
Ruivães (São Martinho)	90400	31114	f
Ventosa (São Martinho)	90401	31119	f
Soutelo (São Miguel)	90402	31352	f
Alentejo	90403	70520	f
Montemor o Novo	90404	70520	f
Montemor_o_Novo	90405	70604	f
Monte Pedral (Lisboa)	90406	110641	f
Cadeia do Limoeiro (Lisboa)	90407	110652	f
Gondar (Santa Maria)	90408	130117	f
Telões (Santo André)	90409	130135	f
Hospital de Bustelo (Penafiel)	90410	131103	f
Nevogilde (São Miguel)	90411	131209	f
Roda do Porto	90412	131214	f
Hospital de Braga	90413	30352	f
Aldeia	90414	30702	f
Aldeia de Baixo	90415	30702	f
Aldeia de Cima	90416	30702	f
Barreiro	90417	30702	f
Boavista	90418	30702	f
Cabo	90419	30702	f
Carvalha dos Passarinhos	90420	30702	f
Carvalhal	90421	30702	f
Chã do Fojo	90422	30702	f
Cunha	90423	30702	f
Eido	90424	30702	f
Eidos	90425	30702	f
Eidos de Baixo	90426	30702	f
Eira	90427	30702	f
Eiras	90428	30702	f
Enxido	90429	30702	f
Esteiro	90430	30702	f
Fojo	90431	30702	f
Fonte	90432	30702	f
Grolonho	90433	30702	f
Grovas	90434	30702	f
Igreja	90435	30702	f
Igrejinha	90436	30702	f
Lajes	90437	30702	f
Outeiro	90438	30702	f
Pires	90439	30702	f
Portela	90440	30702	f
Ribeiro Gonçalo	90441	30702	f
Rua Nova	90442	30702	f
Souto	90443	30702	f
Vinhas	90444	30702	f
Caldelas (Guimarães)	90445	30808	f
Gondomar (Guimarães)	90446	30822	f
Hospital de Guimarães	90447	30834	f
Calvos (Póvoa de Lanhoso)	90448	30904	f
Oliveira (Póvoa de Lanhoso)	90449	30920	f
Serzedelo (Póvoa de Lanhoso)	90450	30924	f
Mosteiro (Vieira do Minho)	90451	31110	f
Pinheiro (Vieira do Minho)	90452	31112	f
Soutelo (Vieira do Minho)	90453	31117	f
Trás os Montes	90454	40242	f
Trás os Montes	90455	40245	f
Hospital de Lisboa	90456	110652	f
Santa Marinha de Pedrosa	90457	131713	f
Vila (Melgaço)	90458	160318	f
Abadões	90459	30703	f
Adonela	90460	30703	f
Assento	90461	30703	f
Bouça	90462	30703	f
Buraco	90463	30703	f
Carvalhal	90464	30703	f
Carvalho	90465	30703	f
Cepeda	90466	30703	f
Certal	90467	30703	f
Cestêlo	90468	30703	f
Coutada	90469	30703	f
Cruz	90470	30703	f
Docim	90471	30703	f
Estriz	90472	30703	f
Folgoso	90473	30703	f
Herdade	90474	30703	f
Macieiro	90475	30703	f
Montinho	90476	30703	f
Outeirinho	90477	30703	f
Outeiro	90478	30703	f
Outeiro Longo	90479	30703	f
Panda	90480	30703	f
Pontido	90481	30703	f
Porinhas	90482	30703	f
Portas	90483	30703	f
Quintã	90484	30703	f
Quintos	90485	30703	f
Ribeira	90486	30703	f
Ribeiro	90487	30703	f
Serrinha	90488	30703	f
Souto	90489	30703	f
Teibães	90490	30703	f
Telhado	90491	30703	f
Vinha	90492	30703	f
Campinho	90493	30705	f
Eidos	90494	30705	f
Lama	90495	30705	f
Outeiro	90496	30705	f
Quintão	90497	30705	f
Retorta	90498	30705	f
Ribadões	90499	30705	f
Souto	90500	30705	f
Almoinha	90501	30707	f
Soutelo	90502	30707	f
Pena Grande	90503	30708	f
Calvelos	90504	30709	f
Castro	90505	30709	f
Feira	90506	30709	f
Ferro	90507	30709	f
Moinhos do Assento	90508	30709	f
Moinhos do Ferro	90509	30709	f
Pardelhas	90510	30709	f
Ponte	90511	30709	f
Ponte Bouças	90512	30709	f
Santo	90513	30709	f
Tojal	90514	30709	f
Cima Vila	90515	30712	f
Casal	90516	30716	f
Barbosa	90517	30718	f
Marinhão	90518	30718	f
Pombal	90519	30719	f
Cruzeiro	90520	30722	f
Docim	90521	30722	f
Eiros	90522	30722	f
Lavandeira	90523	30722	f
Montim	90524	30722	f
Outeiro	90525	30722	f
Pica	90526	30722	f
Portela	90527	30722	f
Ranha	90528	30722	f
Tomada	90529	30722	f
Assento	90530	30725	f
Casal	90531	30725	f
Castro	90532	30725	f
Igreja	90533	30725	f
Alvarinha	90534	30727	f
Boucinha	90535	30727	f
Lama	90536	30727	f
Pinheiros	90537	30727	f
Pousada	90538	30727	f
Torre	90539	30727	f
Valbom	90540	30727	f
Agernide	90541	30728	f
Burgueiros	90542	30728	f
Campo	90543	30728	f
Estramadouro	90544	30728	f
Lajes	90545	30728	f
Povoação	90546	30728	f
Rio	90547	30728	f
Ruivães	90548	30728	f
Souto	90549	30728	f
Tapadinho	90550	30728	f
Vale	90551	30728	f
Valide	90552	30728	f
Vergadela	90553	30728	f
Vilela	90554	30728	f
Campo	90555	30729	f
Casadela	90556	30729	f
Covas	90557	30729	f
Nogueiras	90558	30729	f
Souto	90559	30730	f
Lordelo	90560	130326	f
Candedo (Santa Maria Madalena)	90561	170701	f
Aldeia de Baixo	90562	30704	f
Além	90563	30704	f
Além de Baixo	90564	30704	f
Assento	90565	30704	f
Barroco	90566	30704	f
Barroco da Vinha	90567	30704	f
Cales	90568	30704	f
Cancela	90569	30704	f
Casa da Cancela	90570	30704	f
Casa da Fonte	90571	30704	f
Casa da Portela	90572	30704	f
Casa das Eiras	90573	30704	f
Casa de Além	90574	30704	f
Casa do Cruzeiro	90575	30704	f
Casa do Reguengo	90576	30704	f
Casa do Telhado	90577	30704	f
Casatelhada	90578	30704	f
Castanheirinhos	90579	30704	f
Castanheiros	90580	30704	f
Chão da Porta	90581	30704	f
Cima de Vila	90582	30704	f
Costeira	90583	30704	f
Couto	90584	30704	f
Eiras	90585	30704	f
Fonte	90586	30704	f
Fonte de Cima	90587	30704	f
Fundevila	90588	30704	f
Igreja	90589	30704	f
Navalhos	90590	30704	f
Novo de Além	90591	30704	f
Paço	90592	30704	f
Portela	90593	30704	f
Quinta de Reguengo	90594	30704	f
Reguengo	90595	30704	f
Telhado	90596	30704	f
Toutinhal	90597	30704	f
Toutinhal da Igreja	90598	30704	f
Trás os Vales	90599	30704	f
Vale da Igreja	90600	30704	f
Vales	90601	30704	f
Pinheiro (Santiago)	90602	130314	f
Silvares (São Miguel)	90603	130523	f
Vila Chã (Santo Estêvão)	90604	170116	f
Abragão	90605	30705	f
Agro	90606	30705	f
Albergaria	90607	30705	f
Assento	90608	30705	f
Bacelo	90609	30705	f
Barbeito	90610	30705	f
Barroca	90611	30705	f
Boavista	90612	30705	f
Bouça	90613	30705	f
Boucinha	90614	30705	f
Cabo	90615	30705	f
Cachadinha	90616	30705	f
Carvalhal	90617	30705	f
Carvalheda	90618	30705	f
Casa Nova	90619	30705	f
Casal	90620	30705	f
Casinhas	90621	30705	f
Castanheiro	90622	30705	f
Cortes	90623	30705	f
Cova	90624	30705	f
Devesa	90625	30705	f
Eira	90626	30705	f
Eira Velha	90627	30705	f
Fonte	90628	30705	f
Herdade	90629	30705	f
Laje	90630	30705	f
Lameiro	90631	30705	f
Lamelas	90632	30705	f
Monte	90633	30705	f
Mures	90634	30705	f
Nogueira	90635	30705	f
Outeirinho	90636	30705	f
Paço	90637	30705	f
Pico	90638	30705	f
Pitela	90639	30705	f
Portela	90640	30705	f
Pousadela	90641	30705	f
Profia	90642	30705	f
Raposeira	90643	30705	f
Rego	90644	30705	f
Ribeira Nova	90645	30705	f
Ribeiro	90646	30705	f
Seara	90647	30705	f
Sobrado	90648	30705	f
Soutinho	90649	30705	f
Tapada	90650	30705	f
Vieira	90651	30705	f
Vinha	90652	30705	f
Carvalheira	90653	30501	f
Costa	90654	30501	f
Monte	90655	30501	f
Quintã	90656	30501	f
Santa Eufémia	90657	30501	f
Alvarães	90658	30503	f
Carvalheiras	90659	30503	f
Lugar da Quintela	90660	30503	f
Murgido	90661	30503	f
Gémeos (São Miguel)	90662	30512	f
S. Bartolomeu do Rego	90663	30517	f
Aldeia	90664	30706	f
Aveleira	90665	30706	f
Barrega	90666	30706	f
Campo da Feira	90667	30706	f
Casa da Aldeia	90668	30706	f
Casa da Aveleira	90669	30706	f
Casa da Estrada	90670	30706	f
Casa da Regedoura	90671	30706	f
Casa da Residência Paroquial de Arnozela	90672	30706	f
Casa de Idães	90673	30706	f
Casa de Ribas	90674	30706	f
Casa do Eidinho	90675	30706	f
Casa do Outeiro	90676	30706	f
Eidinho	90677	30706	f
Estalagem do Campo da Feira	90678	30706	f
Estalagem Nova	90679	30706	f
Estrada	90680	30706	f
Feira	90681	30706	f
Fonte Chãs	90682	30706	f
Fragão	90683	30706	f
Fundões	90684	30706	f
Igreja	90685	30706	f
Lata	90686	30706	f
Leiras	90687	30706	f
Loureiro	90688	30706	f
Macedas	90689	30706	f
Outeiro	90690	30706	f
Palhal	90691	30706	f
Regedoura	90692	30706	f
Retiro	90693	30706	f
Ribas	90694	30706	f
Santo Estevão	90695	30706	f
Santo Estevão - Saibro	90696	30706	f
Souto	90697	30706	f
Tárrio	90698	30706	f
Tojal	90699	30706	f
Venda	90700	30706	f
Venda Nova	90701	30706	f
Vila	90702	30706	f
Paço	90703	30723	f
Padrões	90704	30723	f
Santo Estevão	90705	30723	f
Barrosas (Santa Eulália)	90706	31401	f
Aboim (São Pedro)	90707	130102	f
Roda de Amarante	90708	130133	f
Nespereira (São João Evangelista)	90709	130514	f
Castelões de Recezinhos	90710	131107	f
S.Bartolomeu	90711	131205	f
Santo Estêvão da Colegiada de Valença	90712	160815	f
Além	90713	30707	f
Assento	90714	30707	f
Bacelo	90715	30707	f
Bandões	90716	30707	f
Barreirinhas	90717	30707	f
Barroca	90718	30707	f
Boavista	90719	30707	f
Bouçinha	90720	30707	f
Cabo	90721	30707	f
Calçada	90722	30707	f
Cancelo	90723	30707	f
Capela	90724	30707	f
Carreira	90725	30707	f
Carvalha	90726	30707	f
Casalevado	90727	30707	f
Casanova	90728	30707	f
Coutada	90729	30707	f
Cruz	90730	30707	f
Devesinha	90731	30707	f
Fernandes	90732	30707	f
Fonte	90733	30707	f
Igreja	90734	30707	f
Lage	90735	30707	f
Laginhas	90736	30707	f
Lambique	90737	30707	f
Lameira	90738	30707	f
Martins	90739	30707	f
Matinho	90740	30707	f
Moínhos	90741	30707	f
Nogueiras	90742	30707	f
Orrães	90743	30707	f
Outeiro	90744	30707	f
Outezelo	90745	30707	f
Palhais	90746	30707	f
Pereirinha	90747	30707	f
Pombeira	90748	30707	f
Portela	90749	30707	f
Raposeira	90750	30707	f
Regedoura	90751	30707	f
Retorta	90752	30707	f
Retortinha	90753	30707	f
Sampaio	90754	30707	f
Santiago	90755	30707	f
Soeiro	90756	30707	f
Soutinho	90757	30707	f
Souto	90758	30707	f
Tapada	90759	30707	f
Telhado	90760	30707	f
Terreiro	90761	30707	f
Traganhal	90762	30707	f
Trancadas	90763	30707	f
Travessas	90764	30707	f
Vinha	90765	30707	f
Fundevila	90766	30710	f
Soutelo (Vila Verde)	90767	31352	f
Adega	90768	30708	f
Antas	90769	30708	f
Assento	90770	30708	f
Baceiros	90771	30708	f
Bacelo	90772	30708	f
Bairro	90773	30708	f
Barroca	90774	30708	f
Barroca de Quintela	90775	30708	f
Bouça	90776	30708	f
Cabornegas	90777	30708	f
Cancelo	90778	30708	f
Casa da Residência	90779	30708	f
Costa	90780	30708	f
Estrada	90781	30708	f
Feira	90782	30708	f
Fojo	90783	30708	f
Fonte	90784	30708	f
Fundelo	90785	30708	f
Gandra	90786	30708	f
Groiva	90787	30708	f
Herdade	90788	30708	f
Jardim	90789	30708	f
Lamas da Ribeira	90790	30708	f
Leis de Cima	90791	30708	f
Mourisca	90792	30708	f
Mourisca de Baixo	90793	30708	f
Outeiro	90794	30708	f
Outeiro Alto	90795	30708	f
Outeiro de Baixo	90796	30708	f
Outeiro dos Vilares	90797	30708	f
Passos	90798	30708	f
Paulo	90799	30708	f
Pedreira	90800	30708	f
Picoto	90801	30708	f
Portela	90802	30708	f
Portelinha	90803	30708	f
Quintãs	90804	30708	f
Quinteiro	90805	30708	f
Quintela	90806	30708	f
Ribeira	90807	30708	f
São Simão	90808	30708	f
Sargaça	90809	30708	f
Senhora da Ajuda	90810	30708	f
Soutinho	90811	30708	f
Tornadouro	90812	30708	f
Torre	90813	30708	f
Valada	90814	30708	f
Venda Nova	90815	30708	f
Vilares	90816	30708	f
Cadeia da Correição (Guimarães)	90817	30834	f
Ferreiros (São Martinho)	90818	30908	f
Gondar (Amarante)	90819	130117	f
Figueiró	90820	130132	f
Moure (São Salvador)	90821	130311	f
Besteiros (São Paio)	90822	30103	f
Outeiro (Santa Maria Maior)	90823	30410	f
Ponte de Bouças	90824	30709	f
Gémeos (Santa Maria)	90825	30818	f
Lordelo (Santiago)	90826	30828	f
Airão	90827	30853	f
Pentieiros (Santa Eulália)	90828	30869	f
Caldas do Gerês	90829	31003	f
Vila Garcia (Divino Salvador)	90830	130140	f
Friande (São Tomé)	90831	130305	f
Lagares (São Veríssimo)	90832	130308	f
Sendim (Santiago)	90833	130324	f
Gondoriz (Santa Eulália)	90834	160115	f
Dornelas (São Pedro)	90835	170210	f
Arco	90836	30710	f
Areal	90837	30710	f
Assento	90838	30710	f
Bacelos	90839	30710	f
Bage	90840	30710	f
Barroca	90841	30710	f
Barroco	90842	30710	f
Beira da Levada	90843	30710	f
Boavista	90844	30710	f
Bouça das Cabras	90845	30710	f
Cabo	90846	30710	f
Cabo de Queimaterra	90847	30710	f
Cana	90848	30710	f
Carreira	90849	30710	f
Carvalhais	90850	30710	f
Casa Nova	90851	30710	f
Cerquinha	90852	30710	f
Cruz	90853	30710	f
Devesa	90854	30710	f
Eido de Além	90855	30710	f
Eido Novo	90856	30710	f
Eira Velha	90857	30710	f
Estrada	90858	30710	f
Figueira	90859	30710	f
Foz	90860	30710	f
Gandra	90861	30710	f
Granja	90862	30710	f
Herdade	90863	30710	f
Hospital	90864	30710	f
Igreja	90865	30710	f
Lage	90866	30710	f
Lagoas	90867	30710	f
Lama	90868	30710	f
Marco	90869	30710	f
Moinho das Nogueiras	90870	30710	f
Moinhos	90871	30710	f
Moinhos da Casa Nova	90872	30710	f
Moinhos da Igreja	90873	30710	f
Moinhos da Quintã	90874	30710	f
Moinhos de Fundevila	90875	30710	f
Moinhos de Queimaterra	90876	30710	f
Moinhos do Montinho	90877	30710	f
Moinhos do Ribeiro dos Pontidos	90878	30710	f
Moinhos Novos	90879	30710	f
Monte	90880	30710	f
Montinho	90881	30710	f
Oleiros	90882	30710	f
Padrão	90883	30710	f
Palhais	90884	30710	f
Palhaizinhos	90885	30710	f
Penelas	90886	30710	f
Pizões	90887	30710	f
Pombeiro	90888	30710	f
Pontidos	90889	30710	f
Porfia	90890	30710	f
Portela	90891	30710	f
Pousa	90892	30710	f
Queimaterra	90893	30710	f
Rariz	90894	30710	f
Regato	90895	30710	f
Ribeira	90896	30710	f
Ribeira de Além	90897	30710	f
Ribeira do Meio	90898	30710	f
Ribeirinha	90899	30710	f
São João	90900	30710	f
Silvares	90901	30710	f
Soutinho	90902	30710	f
Souto	90903	30710	f
Souto de Silvares	90904	30710	f
Talhos	90905	30710	f
Tibe	90906	30710	f
Torre	90907	30710	f
Vale de Custas	90908	30710	f
Várzea	90909	30710	f
Vinha	90910	30710	f
Vinha da Cana	90911	30710	f
Vinha da Pedra	90912	30710	f
Paraíso (São Miguel)	90913	30821	f
Abação (São Cristóvão)	90914	30864	f
Pentieiros (Santa Eulália)	90915	30864	f
Pentieiros	90916	30869	f
São Vicente de Barrosas	90917	130306	f
Castanheiro	90918	30711	f
Entre as Carreiras	90919	30711	f
Felgueiras	90920	30711	f
Fonte	90921	30711	f
Igreja	90922	30711	f
Lajes	90923	30711	f
Oveira	90924	30711	f
Portela	90925	30711	f
Ribeira	90926	30711	f
Rua Nova	90927	30711	f
Tojal	90928	30711	f
Vale	90929	30711	f
Veiga de Cima	90930	30711	f
Vilar	90931	30711	f
Assento	90932	30712	f
Barroca	90933	30712	f
Calçada	90934	30712	f
Calçada de Paçô	90935	30712	f
Carvalhal	90936	30712	f
Carvalhinhas	90937	30712	f
Casa da Quintã	90938	30712	f
Casa da Torre	90939	30712	f
Casa de Cima de Vila	90940	30712	f
Casal	90941	30712	f
Casas Novas	90942	30712	f
Cima de Vila	90943	30712	f
Corredoura	90944	30712	f
Cruzeiro	90945	30712	f
Eira	90946	30712	f
Entre Vales	90947	30712	f
Espinca	90948	30712	f
Estrada	90949	30712	f
Fervença	90950	30712	f
Figueira	90951	30712	f
Fontelas	90952	30712	f
Fornelo	90953	30712	f
Loureiros	90954	30712	f
Luz	90955	30712	f
Monte	90956	30712	f
Outeiro	90957	30712	f
Outeiro da Figueira	90958	30712	f
Outeiro da Torre	90959	30712	f
Outeiro de Fornelo	90960	30712	f
Outeiro do Casal	90961	30712	f
Paçô	90962	30712	f
Panelada	90963	30712	f
Passal	90964	30712	f
Presa	90965	30712	f
Quintã	90966	30712	f
Quinta da Luz	90967	30712	f
Ribeiro	90968	30712	f
Rielho	90969	30712	f
Telhado	90970	30712	f
Tojal	90971	30712	f
Torre	90972	30712	f
Vale Escuro	90973	30712	f
Várzea	90974	30712	f
Veiga	90975	30712	f
Veigas	90976	30712	f
Viacova	90977	30712	f
Vinhas	90978	30712	f
Lobeira (São Cosme e Damião)	90979	30803	f
Assento	90980	30713	f
Banda de Além	90981	30713	f
Barreiro	90982	30713	f
Batoca	90983	30713	f
Boavista	90984	30713	f
Bouça	90985	30713	f
Bouça do Outeiro Barreiro	90986	30713	f
Cabo da Pereira	90987	30713	f
Cal	90988	30713	f
Cal da Sobreira	90989	30713	f
Cancelos	90990	30713	f
Carvalhal	90991	30713	f
Corvo	90992	30713	f
Costelinha	90993	30713	f
Cruzinha	90994	30713	f
Eirinhas	90995	30713	f
Estrada	90996	30713	f
Estrada de Cima	90997	30713	f
Figueiredo	90998	30713	f
Fonte de Antónia	90999	30713	f
Laje da Pereira	91000	30713	f
Nogueira	91001	30713	f
Nogueira da Pereira	91002	30713	f
Outeiro Alto	91003	30713	f
Outeiro da Panela	91004	30713	f
Paço	91005	30713	f
Padim	91006	30713	f
Padinho	91007	30713	f
Panela	91008	30713	f
Pardieiros	91009	30713	f
Pereira	91010	30713	f
Pereira de Baixo	91011	30713	f
Pereira de Cima	91012	30713	f
Pinheiro	91013	30713	f
Poço	91014	30713	f
Poço de Santo António	91015	30713	f
Portela	91016	30713	f
Quintã	91017	30713	f
Redondo	91018	30713	f
Santo António	91019	30713	f
Sobreira	91020	30713	f
Souto	91021	30713	f
Souto da Batoca	91022	30713	f
Souto da Pereira	91023	30713	f
Tabaçó	91024	30713	f
Tapada	91025	30713	f
Valado	91026	30713	f
Varzinha	91027	30713	f
Vilar	91028	30713	f
Vinha Velha	91029	30713	f
Vizogem	91030	30713	f
Lobeira (Guimarães)	91031	30803	f
Silvares (Guimarães)	91032	30868	f
Friande (Póvoa de Lanhoso)	91033	30911	f
Águas Santas (Maia)	91034	130601	f
Santa Maria da Porta (Melgaço)	91035	160307	f
Vilela (Santiago)	91036	30124	f
Roda de Braga	91037	30352	f
Roda de Cabeceiras de Basto	91038	30406	f
Mar (São Bartolomeu)	91039	30611	f
Adro	91040	30714	f
Assento	91041	30714	f
Bairro	91042	30714	f
Bairro de Cima	91043	30714	f
Barroco	91044	30714	f
Bouça	91045	30714	f
Calvário	91046	30714	f
Calvário da Portelada	91047	30714	f
Calvário de Pequite	91048	30714	f
Campo da Presa	91049	30714	f
Casa Nova	91050	30714	f
Casa Nova do Bairro	91051	30714	f
Casal de Grilo	91052	30714	f
Casal do Regengo	91053	30714	f
Casas da Residência	91054	30714	f
Casas Novas	91055	30714	f
Cimo de Vila	91056	30714	f
Costinha	91057	30714	f
Cruz	91058	30714	f
Devesa	91059	30714	f
Devesa do Souto	91060	30714	f
Eira Vedra	91061	30714	f
Eiras	91062	30714	f
Fonte	91063	30714	f
Fonte Estevão	91064	30714	f
Fontelas	91065	30714	f
Gaia	91066	30714	f
Hospital	91067	30714	f
Igreja	91068	30714	f
Inchido	91069	30714	f
Lameiro	91070	30714	f
Lourido	91071	30714	f
Magurre	91072	30714	f
Moinho da Ponte	91073	30714	f
Moinhos	91074	30714	f
Moinhos da Varziela	91075	30714	f
Moinhos das Eiras	91076	30714	f
Moinhos de Fontelas	91077	30714	f
Moinhos de Pequite	91078	30714	f
Moinhos de Vilar	91079	30714	f
Moinhos do Bairro	91080	30714	f
Moinhos do Barroco	91081	30714	f
Moinhos do Romeu	91082	30714	f
Montinho	91083	30714	f
Noval	91084	30714	f
Outeirinho	91085	30714	f
Outeiro	91086	30714	f
Outeiro da Tapaje	91087	30714	f
Paróquia	91088	30714	f
Pequite	91089	30714	f
Poça	91090	30714	f
Poça do Torto	91091	30714	f
Ponte	91092	30714	f
Ponte das Tábuas	91093	30714	f
Ponte de Bouças	91094	30714	f
Ponte Nova	91095	30714	f
Portela	91096	30714	f
Portelada	91097	30714	f
Portelinha	91098	30714	f
Quintã	91099	30714	f
Quinta da Cruz	91100	30714	f
Quinta da Torre	91101	30714	f
Ramada	91102	30714	f
Referta	91103	30714	f
Reguengo de Varziela	91104	30714	f
Ribeira	91105	30714	f
Ribeiro	91106	30714	f
Romeu	91107	30714	f
Samoça	91108	30714	f
Sangidos	91109	30714	f
Santa Rita	91110	30714	f
Serrinha	91111	30714	f
Soutelinho	91112	30714	f
Souto	91113	30714	f
Souto da Gaia	91114	30714	f
Subaco	91115	30714	f
Subcarreira	91116	30714	f
Subdevesa	91117	30714	f
Tapagem	91118	30714	f
Torre	91119	30714	f
Torto	91120	30714	f
Touril	91121	30714	f
Varziela	91122	30714	f
Verdes	91123	30714	f
Vila Boa	91124	30714	f
Vilar	91125	30714	f
Calvos (São Lourenço)	91126	30809	f
Castelões (São João Baptista)	91127	30810	f
Corvite (Santa Maria)	91128	30838	f
Ponte (São João)	91129	30838	f
Silvares (Santa Maria)	91130	30868	f
Águas Santas (São Martinho)	91131	30901	f
Laje (São Julião)	91132	31323	f
Oleiros (Santa Marinha)	91133	31330	f
Santa Clara (Coimbra)	91134	60316	f
Hospital de Coimbra	91135	60325	f
Águas Santas (N. S. do Ó)	91136	130601	f
Sé (Porto)	91137	131214	f
Agrela (São Pedro)	91138	131401	f
Linhares (Santa Marinha)	91139	160512	f
Celeirós (São Pedro)	91140	171001	f
Nogueira (São Pedro)	91141	171418	f
Alentejo	91142	20509	f
Assento	91143	30715	f
Borrão	91144	30715	f
Cabo	91145	30715	f
Casa do Forno	91146	30715	f
Cerdeira	91147	30715	f
Chã das Eiras	91148	30715	f
Cima de Vila	91149	30715	f
Costa	91150	30715	f
Eira da Marinha	91151	30715	f
Eiras	91152	30715	f
Forno	91153	30715	f
Gontim	91154	30715	f
Igreja	91155	30715	f
Lagoa	91156	30715	f
Lajes	91157	30715	f
Lama	91158	30715	f
Manuel	91159	30715	f
Marinhas	91160	30715	f
Outeiro	91161	30715	f
Outeiro Pequeno	91162	30715	f
Pelame	91163	30715	f
Quelha	91164	30715	f
Quintã	91165	30715	f
Ribeira	91166	30715	f
Salgueiro	91167	30715	f
Vale de Arado	91168	30715	f
São Cosme	91169	30865	f
Oliveira (Santiago)	91170	30920	f
Alentejo	91171	70505	f
Caldelas (Amares)	91172	30106	f
Ascenção	91173	30716	f
Assento	91174	30716	f
Batoca	91175	30716	f
Bouça	91176	30716	f
Boucinha	91177	30716	f
Calçada	91178	30716	f
Canto	91179	30716	f
Capela	91180	30716	f
Carvalhas	91181	30716	f
Carvalhinho	91182	30716	f
Carvalho	91183	30716	f
Casa Nova da Boucinha	91184	30716	f
Corujeira	91185	30716	f
Lagarteira	91186	30716	f
Laje	91187	30716	f
Lameira	91188	30716	f
Maia	91189	30716	f
Medelo	91190	30716	f
Olival	91191	30716	f
Ordem	91192	30716	f
Paredes	91193	30716	f
Pinheiros	91194	30716	f
Queimada	91195	30716	f
Quinteiro	91196	30716	f
Ramada	91197	30716	f
Residência	91198	30716	f
Rielho	91199	30716	f
Rio	91200	30716	f
Rua Nova	91201	30716	f
Rua Nova do Rio	91202	30716	f
Soeiro	91203	30716	f
Souto	91204	30716	f
Sub_Rego	91205	30716	f
Telhado	91206	30716	f
Vale	91207	30716	f
Venda Nova	91208	30716	f
Pombal (Carrazeda de Ansiães)	91209	40314	f
Coração de Jesus (Lisboa)	91210	110614	f
Graça (Lisboa)	91211	110616	f
Santo Estêvão (Lisboa)	91212	110636	f
São Mamede (Lisboa)	91213	110646	f
Pousada (São Paio)	91214	30335	f
Hospital de Braga	91215	30342	f
Aldeia de Baixo de Marinhão	91216	30718	f
Areal	91217	30718	f
Areal de Baixo	91218	30718	f
Areal de Cima	91219	30718	f
Assento	91220	30718	f
Bacelo	91221	30718	f
Bacelo de Barbosa	91222	30718	f
Barbosa das Quintãs	91223	30718	f
Bemposta	91224	30718	f
Bodo	91225	30718	f
Cachada	91226	30718	f
Cancela de Vilela	91227	30718	f
Carvalhais	91228	30718	f
Carvalhais de Marinhão	91229	30718	f
Casa do Foral	91230	30718	f
Chamão	91231	30718	f
Chamão de Barbosa	91232	30718	f
Cortegoso	91233	30718	f
Cortinhas	91234	30718	f
Costa de Marinhão	91235	30718	f
Cotifa	91236	30718	f
Cotifa de Marinhão	91237	30718	f
Digão	91238	30718	f
Digão de Vilela	91239	30718	f
Eira	91240	30718	f
Eira de Onega	91241	30718	f
Espinho de Barbosa	91242	30718	f
Feira	91243	30718	f
Figueiras	91244	30718	f
Figueiras da Bemposta	91245	30718	f
Fontela	91246	30718	f
Foral	91247	30718	f
Foral das Vendas	91248	30718	f
Jardim	91249	30718	f
Monte	91250	30718	f
Monte Alegre	91251	30718	f
Mouro de Vila Pouca	91252	30718	f
Outeiro	91253	30718	f
Outeiro da Barbosa	91254	30718	f
Outeiro de Marinhão	91255	30718	f
Outeiro de Vilela	91256	30718	f
Outeiro Estelo	91257	30718	f
Outeiro Estelo de Vilela	91258	30718	f
Paço de Barbosa	91259	30718	f
Parrainha	91260	30718	f
Parrei	91261	30718	f
Penas	91262	30718	f
Pereiro de Barbosa	91263	30718	f
Portela de Arca	91264	30718	f
Quinta do Bacelo	91265	30718	f
Quintãs	91266	30718	f
Quintãs de Barbosa	91267	30718	f
Quintãs de Vilela	91268	30718	f
Ramada de Barbosa	91269	30718	f
Ramada de Vilela	91270	30718	f
Ribeira	91271	30718	f
Ribeirinho de Barbosa	91272	30718	f
Ribeiro de Barbosa	91273	30718	f
Rua	91274	30718	f
Rua de Barbosa	91275	30718	f
Seara de Marinhão	91276	30718	f
Seixosa	91277	30718	f
Seixosa em Marinhão	91278	30718	f
Sobrado	91279	30718	f
Sorriba	91280	30718	f
Sorriba de Marinhão	91281	30718	f
Soutelo	91282	30718	f
Souto	91283	30718	f
Souto de Cima de Vilela	91284	30718	f
Souto de Eira Donega	91285	30718	f
Souto de Vilela	91286	30718	f
Subrego	91287	30718	f
Subrego de Vilela	91288	30718	f
Suchia	91289	30718	f
Suchia de Marinhão	91290	30718	f
Surrego	91291	30718	f
Tourão	91292	30718	f
Trasvalado	91293	30718	f
Trasvalado de Vilela	91294	30718	f
Tulha	91295	30718	f
Vale	91296	30718	f
Vale da Bicha	91297	30718	f
Valinho	91298	30718	f
Valinho de Vilela	91299	30718	f
Vendas	91300	30718	f
Vila Pouca	91301	30718	f
Vilela	91302	30718	f
Vinharelhos	91303	30718	f
Misericórdia de Guimarães	91304	30834	f
Campos (Vieira do Minho)	91305	31103	f
Hospital de São José (Lisboa)	91306	110645	f
Nogueira (Maia)	91307	130610	f
Hospital Real do Porto	91308	131214	f
Hospital da Chamusca	91309	140701	f
Hospital de Santarém	91310	141620	f
São Paio (Melgaço)	91311	160317	f
Santa Marinha (Ribeira de Pena)	91312	170906	f
Felgueiras (São João)	91313	181305	f
Oliveira (Santa Eulália)	91314	30254	f
Conservatória Registo Civil	91315	30709	f
Abelheira	91316	30719	f
Abelheira de Baixo	91317	30719	f
Abelheira de Cima	91318	30719	f
Adegoiva	91319	30719	f
Adegoiva de Baixo	91320	30719	f
Adegoiva de Cima	91321	30719	f
Ameales	91322	30719	f
Ameales do Bairro	91323	30719	f
Anteadega	91324	30719	f
Areal	91325	30719	f
Assento	91326	30719	f
Bairro	91327	30719	f
Bairro de Lustoso	91328	30719	f
Bairro de Real	91329	30719	f
Bairro do Areal	91330	30719	f
Boavista	91331	30719	f
Boavista da Portela	91332	30719	f
Bouças	91333	30719	f
Cacho	91334	30719	f
Cancela de Lustoso	91335	30719	f
Carizeu	91336	30719	f
Carizeu de Lustoso	91337	30719	f
Carvalhos	91338	30719	f
Carvalhos de Lustoso	91339	30719	f
Casa do Ermo	91340	30719	f
Casa Nova	91341	30719	f
Casais	91342	30719	f
Casal	91343	30719	f
Casal de Cima	91344	30719	f
Castro	91345	30719	f
Castro de Baixo	91346	30719	f
Cima de Vila	91347	30719	f
Cobiça	91348	30719	f
Cobiça de Baixo	91349	30719	f
Cobiça de Cima	91350	30719	f
Costa	91351	30719	f
Cruz	91352	30719	f
Devesa	91353	30719	f
Devesa da Portela	91354	30719	f
Devesa de Lustoso	91355	30719	f
Eido do Tear	91356	30719	f
Eiras	91357	30719	f
Entre Outeiros	91358	30719	f
Ermo	91359	30719	f
Ermo de Baixo	91360	30719	f
Escadinha de Lustoso	91361	30719	f
Fonte do Bairro	91362	30719	f
Fundevila	91363	30719	f
Hospital	91364	30719	f
Lajes	91365	30719	f
Lapa	91366	30719	f
Lata	91367	30719	f
Lustoso	91368	30719	f
Marco	91369	30719	f
Moinhos	91370	30719	f
Moinhos das Eiras	91371	30719	f
Moinhos do Outeirinho	91372	30719	f
Outeirinho	91373	30719	f
Outeiro	91374	30719	f
Ovial	91375	30719	f
Paço	91376	30719	f
Pedra	91377	30719	f
Pedra de Baixo	91378	30719	f
Portela	91379	30719	f
Quinta da Adegoiva	91380	30719	f
Quinta da Portela	91381	30719	f
Real	91382	30719	f
Santa Clara	91383	30719	f
Santa Clara de Lustoso	91384	30719	f
Seixos	91385	30719	f
Tapada	91386	30719	f
Tapada de Lustoso	91387	30719	f
Tear	91388	30719	f
Tear da Eiras	91389	30719	f
Torre	91390	30719	f
Torre do Bairro	91391	30719	f
Vilar	91392	30719	f
Gondomar (São Martinho)	91393	30822	f
Lobeira (São Cosme e Damião)	91394	30865	f
Calvos (São Gens)	91395	30904	f
Friande (Santo André)	91396	30911	f
Valadares (Divino Salvador)	91397	131722	f
Conservatória Registo Civil de Fafe	91398	30709	f
Assento	91399	30720	f
Barras	91400	30720	f
Campo Dianteiro	91401	30720	f
Eira	91402	30720	f
Ermo	91403	30720	f
Fundevila	91404	30720	f
Madeiros	91405	30720	f
Moinhos de Fundevila	91406	30720	f
Moreira	91407	30720	f
Outeirinho	91408	30720	f
Outeiro	91409	30720	f
Pinheiro da Veiga de Baixo	91410	30720	f
Pontido	91411	30720	f
Quintãs	91412	30720	f
Roda	91413	30720	f
São Bento	91414	30720	f
Souto	91415	30720	f
Vale	91416	30720	f
Vale de Baixo	91417	30720	f
Vale de Cima	91418	30720	f
Veiga	91419	30720	f
Veiga de Baixo	91420	30720	f
Veiga de Cima	91421	30720	f
Viacova	91422	30720	f
Passos (Cabeceiras de Basto)	91423	30412	f
Gémeos (Celorico de Basto)	91424	30512	f
Agrelo	91425	30722	f
Aldeia de Docim	91426	30722	f
Assento	91427	30722	f
Barroca de Montim	91428	30722	f
Bouça	91429	30722	f
Bouça de Montim	91430	30722	f
Boucinha	91431	30722	f
Cancela de Montim	91432	30722	f
Cavadas	91433	30722	f
Cima de Vila de Montim	91434	30722	f
Cortegaça	91435	30722	f
Costeira	91436	30722	f
Covelo de Montim	91437	30722	f
Cruzeiro de Docim	91438	30722	f
Eira de Montim	91439	30722	f
Grade	91440	30722	f
Grade	91441	30722	f
Lajes	91442	30722	f
Lajes de Docim	91443	30722	f
Laranjeira	91444	30722	f
Moinhos da Veiga	91445	30722	f
Moinhos de Docim	91446	30722	f
Montim de Cima de Vila	91447	30722	f
Nogueira de Montim	91448	30722	f
Outeirinho	91449	30722	f
Outeirinho da Fonte	91450	30722	f
Outeirinho de Docim	91451	30722	f
Outeiro da Nogueira	91452	30722	f
Outeiro de Docim	91453	30722	f
Paço	91454	30722	f
Passal	91455	30722	f
Penedos	91456	30722	f
Penedos de Montim	91457	30722	f
Pico	91458	30722	f
Ponte	91459	30722	f
Ponte de Docim	91460	30722	f
Pontido	91461	30722	f
Porta de Montim	91462	30722	f
Presa de Montim	91463	30722	f
Quintãs	91464	30722	f
Quintãs de Eirós	91465	30722	f
Ribeirinha	91466	30722	f
Ribeirinhas	91467	30722	f
São João de Docim	91468	30722	f
São Lourenço	91469	30722	f
Sardoal	91470	30722	f
Serrinha	91471	30722	f
Souto	91472	30722	f
Souto das Cales	91473	30722	f
Souto do Outeiro	91474	30722	f
Tapada	91475	30722	f
Torre	91476	30722	f
Valado	91477	30722	f
Veiga	91478	30722	f
Veiga de Docim	91479	30722	f
Vinha	91480	30722	f
Vinha do Assento	91481	30722	f
Nogueira (Santa Cristina)	91482	130516	f
Lordelo (Vila Real)	91483	171414	f
Pinheiro	91484	30711	f
Sendim	91485	30711	f
Abaixo do Rego em Cortinhas	91486	30723	f
Além do Rio	91487	30723	f
Areda	91488	30723	f
Balsa	91489	30723	f
Boucinha	91490	30723	f
Cabo	91491	30723	f
Campo da Eira	91492	30723	f
Carvalheiras	91493	30723	f
Casa do Telhado	91494	30723	f
Contença	91495	30723	f
Cortinhas	91496	30723	f
Devesa	91497	30723	f
Entre Devesas	91498	30723	f
Entre os Vales	91499	30723	f
Fundevila	91500	30723	f
Lameirão	91501	30723	f
Lameirinho	91502	30723	f
Lameiro	91503	30723	f
Lamela	91504	30723	f
Loureiro	91505	30723	f
Lugar Novo	91506	30723	f
Moinho de Ribeiros	91507	30723	f
Monte	91508	30723	f
Outeiro	91509	30723	f
Padrões de Além	91510	30723	f
Pedra Furada	91511	30723	f
Quinta de Padrões	91512	30723	f
Quintela	91513	30723	f
Quintela de Baixo	91514	30723	f
Quintela de Cima	91515	30723	f
Ribeiras	91516	30723	f
Ribeiro	91517	30723	f
Rio	91518	30723	f
Roda de Cortinhas	91519	30723	f
Saibro	91520	30723	f
Saibro de Serdadelo	91521	30723	f
Serdadelo	91522	30723	f
Soutinho	91523	30723	f
Travesselas	91524	30723	f
Ugeira	91525	30723	f
Vale de Cancelas	91526	30723	f
Real (São Salvador)	91527	130127	f
Roda de Felgueiras	91528	130320	f
Figueiredo (São Salvador)	91529	30315	f
Bom Retiro	91530	30724	f
Bouças	91531	30724	f
Canto	91532	30724	f
Canto da Lamela	91533	30724	f
Casa Velha do Canto	91534	30724	f
Casas Novas de Galinhoso	91535	30724	f
Costa	91536	30724	f
Crasto	91537	30724	f
Cruzeiro	91538	30724	f
Eira	91539	30724	f
Eira do Assento	91540	30724	f
Eiras	91541	30724	f
Fores	91542	30724	f
Fularinha	91543	30724	f
Galinhoso	91544	30724	f
Goival	91545	30724	f
Jogo	91546	30724	f
Lamelas	91547	30724	f
Miguel	91548	30724	f
Moinho de Reguengo	91549	30724	f
Não refere a residência	91550	30724	f
Outeirinhos	91551	30724	f
Outeiro Mau	91552	30724	f
Pousadouro	91553	30724	f
Queimadinhas	91554	30724	f
Quintãs	91555	30724	f
Quintãs de Cortegaça	91556	30724	f
Revelhe	91557	30724	f
Riba	91558	30724	f
Sabugal	91559	30724	f
Sanoane	91560	30724	f
Santa Eulália	91561	30724	f
São João	91562	30724	f
São João de Cortegaça	91563	30724	f
São Sebastião	91564	30724	f
Sobradelo	91565	30724	f
Sopico	91566	30724	f
Souto	91567	30724	f
Vale	91568	30724	f
Vale de Cima	91569	30724	f
Vale do Assento	91570	30724	f
Valuzal	91571	30724	f
Serzedelo (São Pedro)	91572	30924	f
Caldas de Vizela	91573	31402	f
Covas (Tábua)	91574	61604	f
Chaves (Santa Maria Maior)	91575	170350	f
Hospital de Chaves	91576	170350	f
Agro	91577	30725	f
Berrance	91578	30725	f
Boavista	91579	30725	f
Campo da Eira	91580	30725	f
Cancelo de Portela	91581	30725	f
Casa da Filgueira	91582	30725	f
Casa de Falcão	91583	30725	f
Casa de Verão	91584	30725	f
Casalermo	91585	30725	f
Castermo	91586	30725	f
Chão	91587	30725	f
Chedelos	91588	30725	f
Cimo de Vila	91589	30725	f
Cotifa	91590	30725	f
Cruz	91591	30725	f
Durão	91592	30725	f
Eido	91593	30725	f
Esporão	91594	30725	f
Falcão	91595	30725	f
Felgueira	91596	30725	f
Fontainhas	91597	30725	f
Grila	91598	30725	f
Herdade	91599	30725	f
Moinhos de Redondelo	91600	30725	f
Outeiro	91601	30725	f
Outeiro de São João	91602	30725	f
Paço	91603	30725	f
Passos	91604	30725	f
Pinheiro	91605	30725	f
Pinheiro de Castro	91606	30725	f
Pinheiro de Cima	91607	30725	f
Poça de Grilo	91608	30725	f
Ponte	91609	30725	f
Ponte de Castermo	91610	30725	f
Ponte de Cima	91611	30725	f
Ponte do Vale	91612	30725	f
Portela	91613	30725	f
Portela de Arca	91614	30725	f
Pulo	91615	30725	f
Quintã	91616	30725	f
Quinta da Filgueira	91617	30725	f
Quinta de Berrance	91618	30725	f
Quinta de Passos	91619	30725	f
Real	91620	30725	f
Reconco	91621	30725	f
Recovelas	91622	30725	f
Redondelo	91623	30725	f
Ribeiro	91624	30725	f
Ribeiro de Castro	91625	30725	f
Sampaio	91626	30725	f
Suchia	91627	30725	f
Torre	91628	30725	f
Torre de Castro	91629	30725	f
Vale	91630	30725	f
Veiga	91631	30725	f
Veiga de Baixo	91632	30725	f
Veiguinhas	91633	30725	f
Verão	91634	30725	f
Vila Meã	91635	30725	f
Soutelo (São João)	91636	31117	f
Santa Eulália de Barrosas	91637	31401	f
Nogueira (Santa Maria)	91638	130610	f
Sanfins (Valpaços)	91639	171218	f
Agrelo	91640	30726	f
Aguiar	91641	30726	f
Aguiarinho	91642	30726	f
Assento	91643	30726	f
Bacelinho	91644	30726	f
Boavista	91645	30726	f
Bouça Nova	91646	30726	f
Boucinha	91647	30726	f
Caminho	91648	30726	f
Capareira	91649	30726	f
Carvalho	91650	30726	f
Casas Novas	91651	30726	f
Castanheiro Talhado	91652	30726	f
Cruz	91653	30726	f
Gaia	91654	30726	f
Herdade	91655	30726	f
Lama	91656	30726	f
Malde	91657	30726	f
Mata	91658	30726	f
Mende	91659	30726	f
Moinho	91660	30726	f
Monte	91661	30726	f
Outeiro	91662	30726	f
Passal	91663	30726	f
Pinhoi	91664	30726	f
Quintã	91665	30726	f
Quinteiro	91666	30726	f
Retorta	91667	30726	f
Ribeira de Além	91668	30726	f
Rio	91669	30726	f
São Pedro	91670	30726	f
Souto Novo	91671	30726	f
Tropeza	91672	30726	f
Valinhas	91673	30726	f
Vila Pouca	91674	30726	f
Vinha	91675	30726	f
Lobeira	91676	30803	f
Ranha	91677	30824	f
Basto (Santa Senhorinha)	91678	30404	f
Misericórdia de Fafe	91679	30709	f
Assento	91680	30727	f
Bouça	91681	30727	f
Bouça Velha	91682	30727	f
Castro	91683	30727	f
Cortinhas	91684	30727	f
Costa	91685	30727	f
Figueira	91686	30727	f
Lama de Além	91687	30727	f
Lama de Cá	91688	30727	f
Molelo	91689	30727	f
Outeiro Longo	91690	30727	f
Paço	91691	30727	f
Paço de Cima	91692	30727	f
Passal	91693	30727	f
Pedregoso	91694	30727	f
Rego	91695	30727	f
Vale	91696	30727	f
Veiga	91697	30727	f
Matamá (Santa Maria)	91698	30824	f
Várzea (São Jorge)	91699	130329	f
Lama (São Miguel)	91700	131411	f
São Jorge (Arcos de Valdevez)	91701	160140	f
Telões (Divino Salvador)	91702	171311	f
Telões (Nossa Senhora das Dores)	91703	171311	f
Hospital de Lamego	91704	180521	f
Glória (Aveiro)	91705	10506	f
Goães (Santiago)	91706	30112	f
Exposto da Roda de Refojos de Basto	91707	30414	f
Freixieiro de Basto	91708	30504	f
Anta	91709	30728	f
Anta da Povoação	91710	30728	f
Assento	91711	30728	f
Assento - Cales	91712	30728	f
Assento - Cerdeira	91713	30728	f
Assento - Costa	91714	30728	f
Assento - Souto das Cales	91715	30728	f
Assento - Vilaboa	91716	30728	f
Bacelar	91717	30728	f
Bairro	91718	30728	f
Bargo	91719	30728	f
Boavista	91720	30728	f
Boucinhas	91721	30728	f
Bragadela	91722	30728	f
Cabo	91723	30728	f
Campo de Cima	91724	30728	f
Canto	91725	30728	f
Carril	91726	30728	f
Carvalha	91727	30728	f
Casa Nova	91728	30728	f
Casais	91729	30728	f
Casal Ermo	91730	30728	f
Casas de Além	91731	30728	f
Caselhos	91732	30728	f
Caunho	91733	30728	f
Cavadas	91734	30728	f
Celeiros	91735	30728	f
Cerca	91736	30728	f
Chãos	91737	30728	f
Coroado	91738	30728	f
Cunha	91739	30728	f
Curujeira	91740	30728	f
Devesa	91741	30728	f
Eira	91742	30728	f
Eira de Ruivães	91743	30728	f
Falperra	91744	30728	f
Figueiras	91745	30728	f
Figueiredo	91746	30728	f
Fundevila	91747	30728	f
Gervide	91748	30728	f
Gondim	91749	30728	f
Igreja	91750	30728	f
Jogundal	91751	30728	f
Lages	91752	30728	f
Lamas	91753	30728	f
Lamas de Paredes	91754	30728	f
Lameira	91755	30728	f
Lameirinha	91756	30728	f
Moinhos	91757	30728	f
Moinhos da Curujeira	91758	30728	f
Moinhos do Vilar	91759	30728	f
Moinhos dos Caselos	91760	30728	f
Monte	91761	30728	f
Montim	91762	30728	f
Mós	91763	30728	f
Mosteiro	91764	30728	f
Motreno	91765	30728	f
Outeiro	91766	30728	f
Outeiro de Ruivães	91767	30728	f
Paixão	91768	30728	f
Paredes	91769	30728	f
Pedregal	91770	30728	f
Penedo	91771	30728	f
Penedo das Pombas	91772	30728	f
Pica	91773	30728	f
Pica de Além	91774	30728	f
Poça Espida	91775	30728	f
Pontido	91776	30728	f
Pontinhas	91777	30728	f
Portela	91778	30728	f
Prelada	91779	30728	f
Raizes	91780	30728	f
Raposa	91781	30728	f
Real	91782	30728	f
Redondelo	91783	30728	f
Restiva	91784	30728	f
Ribadeiras	91785	30728	f
Roma	91786	30728	f
Salgueiral	91787	30728	f
São Lourenço	91788	30728	f
Soutinho	91789	30728	f
Soutinho de Real	91790	30728	f
Souto de Ruivães	91791	30728	f
Supico	91792	30728	f
Tomada	91793	30728	f
Torrão	91794	30728	f
Trás da Portela	91795	30728	f
Travessa	91796	30728	f
Venda	91797	30728	f
Venda do Campo	91798	30728	f
Vilares	91799	30728	f
Vinha	91800	30728	f
Vinha de Ruivães	91801	30728	f
Matamá	91802	30803	f
Exposto da Roda de Guimarães	91803	30834	f
Paraíso (São Miguel)	91804	30854	f
Hospital de Guimarães	91805	30860	f
Moure (São Martinho)	91806	31328	f
Ponte (São Vicente)	91807	31337	f
Hospital Rovisco Pais (Tocha, Cantanhede)	91808	60214	f
Arrifana (São Martinho)	91809	90706	f
Anjos (Lisboa)	91810	110606	f
Lapa (N. S. da Lapa)	91811	110617	f
Lisboa (Cadeia do Limoeiro)	91812	110652	f
Hospital de Amarante	91813	130133	f
Valadares (Santiago)	91814	130219	f
Vila Verde (São Mamede)	91815	130333	f
Rio Tinto (São Cristóvão)	91816	130408	f
Recezinhos	91817	131132	f
Exposto da Roda do Porto	91818	131214	f
Resende (São Salvador)	91819	181311	f
Valadares (N. S. da Expectação)	91820	181617	f
Penso (São Sebastião)	91821	181813	f
Ocidental (Viseu)	91822	182324	f
Cossourado (Santiago)	91823	30224	f
Alegria	91824	30729	f
Areal	91825	30729	f
Asnela	91826	30729	f
Assento	91827	30729	f
Barreiro	91828	30729	f
Boavista	91829	30729	f
Bouça	91830	30729	f
Cabo	91831	30729	f
Cabo das Nogueiras	91832	30729	f
Cachada	91833	30729	f
Campinho	91834	30729	f
Cerdeiral	91835	30729	f
Cima das Nogueiras	91836	30729	f
Cima de São Martinho	91837	30729	f
Cortes	91838	30729	f
Cremerinhos	91839	30729	f
Debaixo das Nogueiras	91840	30729	f
Eira	91841	30729	f
Fraga	91842	30729	f
Igreja	91843	30729	f
Levadinha	91844	30729	f
Marquinho	91845	30729	f
Moinhos	91846	30729	f
Ortezedo	91847	30729	f
Outeirinho	91848	30729	f
Outeiro	91849	30729	f
Pedreira	91850	30729	f
Porinhas	91851	30729	f
Portela	91852	30729	f
Pousafoles	91853	30729	f
Requeixo	91854	30729	f
Ribeiras	91855	30729	f
São Martinho	91856	30729	f
São Miguel	91857	30729	f
Serdeiral	91858	30729	f
Sobradelo	91859	30729	f
Telha	91860	30729	f
Tresmil	91861	30729	f
Varzea	91862	30729	f
Hospital Militar de Coimbra	91863	60325	f
Hospital de Évora	91864	70520	f
Roda de Penafiel	91865	131124	f
Pinheiro (São Vicente)	91866	131126	f
Paranhos (São Veríssimo)	91867	131210	f
Cadeia do Porto	91868	131214	f
Arcozelo (São Miguel)	91869	131701	f
Ermelo (São Vicente)	91870	170504	f
Santa Leocádia (São Bartolomeu)	91871	181912	f
Silva (São Julião)	91872	30279	f
Alvite (São Pedro)	91873	30402	f
Exposto	91874	30709	f
Lama de Cima	91875	30726	f
Arrochela	91876	30730	f
Assento	91877	30730	f
Assento - Bacelinho	91878	30730	f
Assento - Boucinha	91879	30730	f
Assento - Outeiro	91880	30730	f
Assento - Porta da Cancela	91881	30730	f
Assento - Quinta do Carvalho	91882	30730	f
Assento - Soutinho	91883	30730	f
Assento - Sub Nogueiras	91884	30730	f
Assento - Sub Torre	91885	30730	f
Assento - Subaco	91886	30730	f
Assento - Tapada	91887	30730	f
Assento - Telhado	91888	30730	f
Assento - Tomada	91889	30730	f
Assento - Torre	91890	30730	f
Assento - Trás do Paço	91891	30730	f
Assento - Valemau	91892	30730	f
Assento - Venda	91893	30730	f
Assento - Venda de Cima	91894	30730	f
Assento - Vinha de Oleiros	91895	30730	f
Assento - Vinha do Subaco	91896	30730	f
Assento - Zebral	91897	30730	f
Azenha	91898	30730	f
Barreiros	91899	30730	f
Barroca de Oleiros	91900	30730	f
Bouça	91901	30730	f
Bouça da Portela	91902	30730	f
Bouça de Fora	91903	30730	f
Bouçó	91904	30730	f
Campinho	91905	30730	f
Campo	91906	30730	f
Cancela	91907	30730	f
Carvalho do Lobo	91908	30730	f
Carvalhos	91909	30730	f
Casa da Arrochela	91910	30730	f
Casa da Cerdeira	91911	30730	f
Casa da Ribeira	91912	30730	f
Casa de Estrafães	91913	30730	f
Casa de Pinhoi	91914	30730	f
Casa do Lugar	91915	30730	f
Casa do Penedo	91916	30730	f
Casa do Souto	91917	30730	f
Casa do Telhado	91918	30730	f
Casa Nova	91919	30730	f
Casa Nova de Estrafães	91920	30730	f
Casa Nova de Pinhoi	91921	30730	f
Casa Nova dos Oleiros	91922	30730	f
Casas do Senhor	91923	30730	f
Casinha	91924	30730	f
Cerdeira	91925	30730	f
Costa	91926	30730	f
Costeira	91927	30730	f
Costinha	91928	30730	f
Crespos	91929	30730	f
Devesa	91930	30730	f
Eirinha	91931	30730	f
Estrada	91932	30730	f
Estrada Nova da Portela	91933	30730	f
Estrafães	91934	30730	f
Ferreiros	91935	30730	f
Ferreiros de Além	91936	30730	f
Fonte	91937	30730	f
Fonte de Baixo	91938	30730	f
Fonte de Cima	91939	30730	f
Fonte do Meio	91940	30730	f
Fontelo	91941	30730	f
Fregim	91942	30730	f
Igreja	91943	30730	f
Lage	91944	30730	f
Lameira	91945	30730	f
Lameira da Bouça	91946	30730	f
Lameiro	91947	30730	f
Lijó	91948	30730	f
Lugar	91949	30730	f
Monte	91950	30730	f
Nogueira	91951	30730	f
Nogueira de Cima	91952	30730	f
Oleiros	91953	30730	f
Outeirinho	91954	30730	f
Outeiro da Bouça	91955	30730	f
Outeiro de Oleiros	91956	30730	f
Paço	91957	30730	f
Paulinho	91958	30730	f
Penedo	91959	30730	f
Penedo de Cima	91960	30730	f
Penouços	91961	30730	f
Perlada	91962	30730	f
Pestana	91963	30730	f
Picoto	91964	30730	f
Porrinhos	91965	30730	f
Portal	91966	30730	f
Portela	91967	30730	f
Portela da Venda	91968	30730	f
Portela de Pinhoi	91969	30730	f
Porto	91970	30730	f
Prendal	91971	30730	f
Quinta de Arrochela	91972	30730	f
Quinta de Crespos	91973	30730	f
Quinta de Estrafães	91974	30730	f
Quinta de Oleiros	91975	30730	f
Quinta do Assento	91976	30730	f
Quinta do Souto	91977	30730	f
Rego	91978	30730	f
Reguengo	91979	30730	f
Requeixo	91980	30730	f
Ribeiral	91981	30730	f
Ribeiro	91982	30730	f
Samoça	91983	30730	f
Seara	91984	30730	f
Sebe de Ferreiros	91985	30730	f
Serradinho	91986	30730	f
Serrado	91987	30730	f
Soalheiro	91988	30730	f
Souto da Nogueira	91989	30730	f
Fradelos (Santa Leocádia)	91990	31215	f
Vermoim (Santa Maria)	91991	31247	f
Nevogilde (Santa Marinha)	91992	31329	f
Travanca (Divino Salvador)	91993	130136	f
Teixeira (São Pedro)	91994	130216	f
Pedreira (Santa Marinha)	91995	130312	f
Penacova (São Martinho)	91996	130313	f
Valbom (São Veríssimo)	91997	130411	f
Silva Escura (Santa Maria)	91998	130614	f
Custóias (Santiago)	91999	130801	f
Bustelo (São Miguel)	92000	131103	f
Duas Igrejas (Santo Adrião)	92001	131109	f
Vilarinho (São Miguel)	92002	131432	f
Junqueira (São Simão e São Judas Tadeu)	92003	131612	f
Padroso (N. S. das Neves)	92004	160125	f
Rio Frio (São João Baptista)	92005	160130	f
Gandra (Divino Salvador)	92006	160807	f
Vilar (N. S. da Guia)	92007	170216	f
Assento	92008	30732	f
Barreiro	92009	30732	f
Barrelas	92010	30732	f
Boavista	92011	30732	f
Chã	92012	30732	f
Chão	92013	30732	f
Cima de Vila	92014	30732	f
Cruz	92015	30732	f
Devesa	92016	30732	f
Eira	92017	30732	f
Eira	92018	30732	f
Gondeães	92019	30732	f
Grandinho	92020	30732	f
Igreja	92021	30732	f
Igrejinha	92022	30732	f
Lordelo	92023	30732	f
Outeiro do Paço	92024	30732	f
Panelada	92025	30732	f
Patelos	92026	30732	f
Portela	92027	30732	f
Portelinha	92028	30732	f
Quintela	92029	30732	f
Quintelinha	92030	30732	f
Ribeiro	92031	30732	f
Rio Mau	92032	30732	f
Rua Nova	92033	30732	f
Toural	92034	30732	f
Vale de Ferreiro	92035	30732	f
Vila Nova	92036	30732	f
Soutelo (Santo Adrião)	92037	31117	f
Espinho (Aveiro)	92038	10702	f
Carreira (Barcelos)	92039	30219	f
Convento N. S. Conceição em Braga	92040	30352	f
Serzedo	92041	30414	f
Hospital de Fafe	92042	30709	f
Adgoiva	92043	30733	f
Além Rio	92044	30733	f
Assento	92045	30733	f
Atalaia	92046	30733	f
Boavista	92047	30733	f
Bouças	92048	30733	f
Casa Nova	92049	30733	f
Casinhas	92050	30733	f
Castanheira	92051	30733	f
Castro	92052	30733	f
Compostela	92053	30733	f
Cortegaça	92054	30733	f
Costeira	92055	30733	f
Covelo	92056	30733	f
Forcada	92057	30733	f
Frades	92058	30733	f
Freita	92059	30733	f
Freixo	92060	30733	f
Gontinha	92061	30733	f
Guimbra	92062	30733	f
Igreja	92063	30733	f
Laje	92064	30733	f
Laranjeiras	92065	30733	f
Leiras	92066	30733	f
Lestido	92067	30733	f
Linhares	92068	30733	f
Macieiro	92069	30733	f
Mó	92070	30733	f
Moinho do Outeiro	92071	30733	f
Moinhos	92072	30733	f
Outeiro	92073	30733	f
Pedegral	92074	30733	f
Pena	92075	30733	f
Poça	92076	30733	f
Pombais	92077	30733	f
Ponte	92078	30733	f
Ponte da Vizela	92079	30733	f
Portela	92080	30733	f
Quintãs	92081	30733	f
Redondo	92082	30733	f
Ribeira	92083	30733	f
Ribeiras	92084	30733	f
Ribeiro	92085	30733	f
Sá	92086	30733	f
Samorinha	92087	30733	f
Sanfins	92088	30733	f
Santos	92089	30733	f
Senra	92090	30733	f
Soutinho	92091	30733	f
Souto	92092	30733	f
Tapada	92093	30733	f
Telhado	92094	30733	f
Valados	92095	30733	f
Vale de Frades	92096	30733	f
Varzea	92097	30733	f
Varzinhas	92098	30733	f
Vilar	92099	30733	f
Prazins (Guimarães)	92100	30842	f
Cruz de Baixo	92101	30865	f
Gronho	92102	30866	f
Concelho de Regalados	92103	31336	f
Santos_o_Velho	92104	110637	f
São Nicolau (Porto)	92105	131213	f
Arcozelo (Vila Nova de Gaia)	92106	131701	f
Arcozelo (São Mamede)	92107	30209	f
Ancheiras	92108	30734	f
Aveleiras	92109	30734	f
Barreiro	92110	30734	f
Barreiro de Bastelo	92111	30734	f
Cabo da Lagoa	92112	30734	f
Cabovila	92113	30734	f
Cabovila de Bastelo	92114	30734	f
Cabovila de Várzea Cova	92115	30734	f
Calveiro	92116	30734	f
Cancela	92117	30734	f
Cancela de Várzea Cova	92118	30734	f
Carvalhas	92119	30734	f
Carvalhinha de Bastelo	92120	30734	f
Carvalhinhos da Lagoa	92121	30734	f
Carvalho	92122	30734	f
Casalbom	92123	30734	f
Castinheiro	92124	30734	f
Cerdeira	92125	30734	f
Cerdeira da Lagoa	92126	30734	f
Costa	92127	30734	f
Costa de Várzea Cova	92128	30734	f
Eiro de Bastelo	92129	30734	f
Facha	92130	30734	f
Figueira	92131	30734	f
Figueira de Várzea Cova	92132	30734	f
Fonte da Lagoa	92133	30734	f
Lage da Lagoa	92134	30734	f
Lameiro de Bastelo	92135	30734	f
Lavandeira	92136	30734	f
Lavandeira de Várzea Cova	92137	30734	f
Mogo	92138	30734	f
Outeiro	92139	30734	f
Outeiro da Lagoa	92140	30734	f
Outeiro da Vila	92141	30734	f
Paço	92142	30734	f
Paço de Várzea Cova	92143	30734	f
Pomar	92144	30734	f
Pomar de Várzea Cova	92145	30734	f
Portela	92146	30734	f
Portela da Lagoa	92147	30734	f
Possa	92148	30734	f
Presa	92149	30734	f
Quelha	92150	30734	f
Quelha de Várzea Cova	92151	30734	f
Ramada de Bastelo	92152	30734	f
Rego de Bastelo	92153	30734	f
Rego de Bastelo	92154	30734	f
Renda	92155	30734	f
Renda de Várzea Cova	92156	30734	f
Ribeiras	92157	30734	f
Ribeirinhas	92158	30734	f
Ribeirinhas de Bastelo	92159	30734	f
Ribeiro	92160	30734	f
Ribeiro de Bastelo	92161	30734	f
Ribeiros	92162	30734	f
Ribeiros de Bastelo	92163	30734	f
Rio	92164	30734	f
Rio da Lagoa	92165	30734	f
Rio de Várzea Cova	92166	30734	f
Rolões	92167	30734	f
Tábua	92168	30734	f
Tapado	92169	30734	f
Tapado de Bastelo	92170	30734	f
Tarrio	92171	30734	f
Tumium	92172	30734	f
Tumium de Cima	92173	30734	f
Vale de Bastelo	92174	30734	f
Várzea Cova	92175	30734	f
Vila de Bastelo	92176	30734	f
Serzedelo (Santa Cristina)	92177	30866	f
Paradela (São Sebastião)	92178	61306	f
Cambeses (Santiago)	92179	30216	f
Lama (Divino Salvador)	92180	30242	f
Aidro	92181	30735	f
Assento	92182	30735	f
Bairão	92183	30735	f
Bairro	92184	30735	f
Barreiro	92185	30735	f
Boavista	92186	30735	f
Calçada	92187	30735	f
Caldeiras	92188	30735	f
Calvelo	92189	30735	f
Campinho	92190	30735	f
Carapinho	92191	30735	f
Carneiro	92192	30735	f
Carvalhal	92193	30735	f
Carvalhas	92194	30735	f
Carvalho	92195	30735	f
Casa Nova	92196	30735	f
Casais	92197	30735	f
Caselas	92198	30735	f
Castanheira	92199	30735	f
Castanheira de Baixo	92200	30735	f
Castanheira de Cima	92201	30735	f
Chão do Fornelo	92202	30735	f
Corvo	92203	30735	f
Cotelhe	92204	30735	f
Cotelinho	92205	30735	f
Covelo	92206	30735	f
Covilhã	92207	30735	f
Cruzeiro	92208	30735	f
Curujeira	92209	30735	f
Cutelo	92210	30735	f
Devesa da Curujeira	92211	30735	f
Eira	92212	30735	f
Eira Velha	92213	30735	f
Figueira	92214	30735	f
Figueira de Fornelo	92215	30735	f
Fonte de Moure	92216	30735	f
Fontes	92217	30735	f
Fontisso	92218	30735	f
Fragas	92219	30735	f
Igreja	92220	30735	f
Lajes	92221	30735	f
Lama	92222	30735	f
Lamas	92223	30735	f
Lameira	92224	30735	f
Lameiro	92225	30735	f
Lata	92226	30735	f
Lavinho	92227	30735	f
Louredo	92228	30735	f
Loureiro	92229	30735	f
Lourido	92230	30735	f
Moure	92231	30735	f
Outeiro	92232	30735	f
Paços	92233	30735	f
Padinho	92234	30735	f
Pena	92235	30735	f
Pereira	92236	30735	f
Pereirinha	92237	30735	f
Portela	92238	30735	f
Portelinha	92239	30735	f
Quintã	92240	30735	f
Quintamá	92241	30735	f
Residência	92242	30735	f
Rio	92243	30735	f
Sancha	92244	30735	f
Silvares	92245	30735	f
Souto de Corvas	92246	30735	f
Togide	92247	30735	f
Toutiço	92248	30735	f
Valado	92249	30735	f
Valdelhe	92250	30735	f
Vale	92251	30735	f
Valide	92252	30735	f
Vilar	92253	30735	f
Vinha Velha	92254	30735	f
Portela (Santa Marinha)	92255	31231	f
Portela (São Paio)	92256	131127	f
Adegas	92257	30736	f
Assento	92258	30736	f
Cachada	92259	30736	f
Campo	92260	30736	f
Carreira	92261	30736	f
Carvalho	92262	30736	f
Casa Nova	92263	30736	f
Chamuscada	92264	30736	f
Chantado	92265	30736	f
Devesa	92266	30736	f
Escalheiro	92267	30736	f
Fonte	92268	30736	f
Fontinhas	92269	30736	f
Fundevila	92270	30736	f
Godim	92271	30736	f
Igreja	92272	30736	f
Jardim	92273	30736	f
Lagar	92274	30736	f
Lagar de Baixo	92275	30736	f
Lagar de Cima	92276	30736	f
Leis	92277	30736	f
Monte	92278	30736	f
Outeirinho	92279	30736	f
Outeiro	92280	30736	f
Outeiro da Linha	92281	30736	f
Outeiro da Vinha	92282	30736	f
Ramada	92283	30736	f
Requeixo	92284	30736	f
Ribeiro do Lobo	92285	30736	f
São Mamede	92286	30736	f
Vinhas	92287	30736	f
Santo Cristo de Outeiro (Bragança)	92288	40226	f
S. Paio de Antas	92289	30605	f
Hospital de Lisboa	92290	110617	f
Hospital	92291	110652	f
Cadeia de Caminha	92292	160207	f
Hospital	92293	160207	f
Couto	92294	160211	f
Afogada	92295	160215	f
Afogada na Barra de Lisboa	92296	160215	f
Afogado no Cais	92297	160215	f
Afogado no Cais do Pontal	92298	160215	f
Afogado no mar	92299	160215	f
Afogado no rio	92300	160215	f
Aldeia	92301	160215	f
Alentejo	92302	160215	f
Assassinado	92303	160215	f
Assassinado	92304	160215	f
Barrosa	92305	160215	f
Barrosa	92306	160215	f
Bustelo	92307	160215	f
Cabreira	92308	160215	f
Calçada	92309	160215	f
Calçada de Barreiros	92310	160215	f
Cancelo	92311	160215	f
Carvalhinho	92312	160215	f
Carvalho	92313	160215	f
Coura	92314	160215	f
Crasto	92315	160215	f
Cruzeiro	92316	160215	f
Escadas do Sobral	92317	160215	f
Fora	92318	160215	f
Gaiosa	92319	160215	f
Gierra	92320	160215	f
Hospital da Guarda	92321	160215	f
Hospital de Caminha	92322	160215	f
Hospital de Coimbra	92323	160215	f
Hospital de Lisboa	92324	160215	f
Hospital de Setúbal	92325	160215	f
Hospital do Porto	92326	160215	f
Hospsital dos Marinheiros de Santa Clara, Lisboa	92327	160215	f
Lagoa	92328	160215	f
Lugar da Igreja	92329	160215	f
Mar do Norte	92330	160215	f
Monte	92331	160215	f
Montinho	92332	160215	f
Naufrágio	92333	160215	f
Paiares	92334	160215	f
Pereira	92335	160215	f
Portela	92336	160215	f
Portela	92337	160215	f
Portela de Baixo	92338	160215	f
Praia do rio	92339	160215	f
Presa	92340	160215	f
Quingostas	92341	160215	f
Regata	92342	160215	f
Renda	92343	160215	f
S. Bento	92344	160215	f
S. Pedro	92345	160215	f
São Bento	92346	160215	f
São Sebastião	92347	160215	f
Seixinhos	92348	160215	f
Serra da Estrela	92349	160215	f
Terramoto de Lisboa	92350	160215	f
Trás os Montes	92351	160215	f
Vale	92352	160215	f
Âncora	92353	160217	f
Marinhas	92354	160218	f
Couto de Sanfins	92355	160816	f
Ordonho	92356	171009	f
Afogado no mar	92357	160220	f
Alentejo	92358	160220	f
Ausente	92359	160220	f
Calvário	92360	160220	f
Fontinha	92361	160220	f
Fora	92362	160220	f
Igreja	92363	160220	f
Lugar de Baixo	92364	160220	f
Quelha	92365	160220	f
Sapor	92366	160220	f
Serrape	92367	160220	f
Coroados	92368	142113	f
Peros Ruivos	92369	142111	f
Valada	92370	142113	f
Quinta da Portela	92371	40902	f
Rio de Moinhos	92372	181707	f
Quinta da Silveira	92373	40902	f
Meadela	92374	160931	f
Chosendo	92375	181803	f
Figueira de Castelo Rodrigo	92376	90408	f
Figueira de Castelo Rodrigo	92377	90403	f
Hospital de Jesus Cristo (SCM Santarém)	92378	490313	f
Igreja de Monserrate	92379	160919	f
Travessa do Rotea	92380	160919	f
Junto derradeiro arco	92381	160919	f
Cótimos	92383	91305	f
Caminho de Cima	92384	450201	f
Caminho do Outeiro	92385	450201	f
lousa	92386	30521	f
Quelha da Papanata	92388	160931	f
Rua da Capela, Estevais	92389	40902	f
Igreja velha	92390	30925	f
R. Eirados, Estevais	92391	40902	f
R. Fundo do Povo, Estevais	92392	40902	f
R. Trás, Estevais	92393	40902	f
R. Igreja, Estevais	92394	40902	f
R. Olmo, Estevais	92395	40902	f
R. Cimo do Povo, Estevais	92396	40902	f
campo velho	92397	160931	f
R. Lajes, Estevais	92398	40902	f
Guarda	92399	90742	f
Frente Ermida Santiago	92400	160919	f
De frente chafariz S. Domingos	92401	160919	f
R. Entrada do Povo, Estevais	92402	40902	f
Entrada R. do Loureiro	92403	160919	f
Rua de Santa Clara	92404	160931	f
Guivães	92405	30906	f
Costa	92406	30918	f
São João Baptista da Ribeira	92407	121504	f
Travessa André Henriques	92408	160919	f
Travessa de Goa (da Gois)	92409	160919	f
Fonte da Penha de França	92410	160919	f
Cerca, Estevais	92411	40902	f
Praça do Toural	92412	30863	f
Penude	92413	180517	f
Barreiro	92414	30906	f
Santa Comba da Vilariça	92415	41012	f
Guarda	92416	90903	f
Eirado	92417	160919	f
Estalagem da Portela	92418	40902	f
Rua do Cais de São Bento	92419	160931	f
Alagoa	92420	40304	f
Estalagem da Silveira da Vilariça	92421	40902	f
Lamego	92422	180521	f
Quinta da Terrincha	92423	40902	f
Rua de Santo Homem Bom	92424	160919	f
Travessa do Barbosa	92425	160919	f
Travessa do Barbosa	92426	160931	f
Rua dos Manjovos	92427	160931	f
Rua do Castelo	92428	160919	f
R. do Mata Mouros	92429	160919	f
Vilarinho	92431	30925	f
Prelada	92432	30513	f
Rua de Santa Clara	92433	160919	f
Vale da Sancha	92434	40716	f
Terceiro arco da Ribeira	92435	160919	f
R. da Esperança	92436	160931	f
brasil	92437	470110	f
Ribeira	92438	450103	f
Ermígio	92439	30840	f
Rua Inácio Velho	92440	160931	f
Real	92441	30873	f
Gondar	92442	30840	f
Quinta do Carrascal	92443	41017	f
Picões	92444	40102	f
Souto do Arrabalde	92445	30838	f
Vale Pereiro	92446	40115	f
Santiago	92447	160721	f
São Martinho	92448	160931	f
São Martimho	92449	160128	f
Vilartão	92450	171205	f
Paço	92451	30872	f
Esquerdo	92452	30815	f
Vilar de Frades	92453	30211	f
Edroso	92454	40512	f
Valverde	92455	40824	f
Bouzende	92456	40231	f
Boucinha	92457	30918	f
Travessa do Postigo	92458	160931	f
São Pedro	92459	30235	f
Bustelos	92460	30927	f
Leiradela	92461	30927	f
Vilar	92462	30927	f
Covas	92463	30903	f
São Pedro	92464	30219	f
São Salvador	92465	131614	f
Rua do Hospital Velho	92466	160931	f
Sobrado	92467	30511	f
Mós	92468	31336	f
Campo de Santa Ana	92469	30342	f
Aldeia de cima	92470	30927	f
Paço	92471	30814	f
Lebução	92472	171213	f
Rua Nova	92473	30521	f
Vilarouco	92474	181514	f
Pereira	92475	40706	f
Curral do Concelho	92476	450201	f
Santa Rita	92477	450201	f
Pias	92478	450201	f
Quelha do Calhau	92479	160931	f
Estrada Real	92480	450201	f
Refoios	92481	160931	f
São Tiago	92482	160805	f
Couto	92483	160307	f
Madancos	92484	30410	f
Portas de S. Crispim	92485	160931	f
Casas de Marçal Casado Jacome	92486	160919	f
Toledo	92487	450204	f
Serroa	92488	450206	f
Reis Magos	92489	160931	f
Rua do Pascoal	92490	160931	f
Casas Novas	92491	30807	f
Quintã	92492	30403	f
Rua do Rubim	92493	160931	f
rua do Rubim	92494	160931	f
Tapado	92495	30849	f
Travessa de Gaspar Fagundes	92496	160931	f
Rua de Roque Gomes	92497	160931	f
Do Postigo	92498	160931	f
Paço	92499	30614	f
Quelha da Gandave	92500	160919	f
Santa Marinha	93500	161007	f
Rua da Porta de S. nTiago	93501	160931	f
Rua da Porta de S.Tiago	93502	160931	f
Rua defronte da do Corredio	93503	160919	f
Campo de Santo António	93504	160931	f
Travessa do Corredio	93505	160931	f
S. Julião de Moreira	93506	160919	f
Valbom	93507	30909	f
Santa Marta	93508	31113	f
Vila Boa	93509	31108	f
São Pedro	93510	31113	f
Rua das Laranjeiras	93511	160931	f
Alvite	93512	30808	f
Carvalho de Egas	93513	41004	f
Darque	93514	160931	f
Rua do Estudo	93515	160931	f
Acheira	93516	30838	f
Fiães	93517	171210	f
Adro da Igreja Matriz	93518	160931	f
Devesa	93519	30869	f
Corvite	93520	30848	f
Vilares da Vilariça	93521	40120	f
Espinho	93522	30838	f
Rua de São Crispim	93523	160931	f
Almofala	93524	90402	f
Quelha dos Fornos	93525	160931	f
Reiros	93526	30402	f
Rendufe	93527	30520	f
Corujeira	93528	30416	f
Sá	93529	30520	f
Rua do Mestre Sequeiros	93530	160931	f
Tó	93531	40810	f
Tó	93532	40819	f
Casal	93533	30406	f
Casa Nova	93534	30408	f
Benlhevai	93535	41002	f
Trindade	93536	41014	f
Rasa	93537	30521	f
Rua Fernão Ferreira	93538	160919	f
Detrás da Rua de Santa Catarina	93539	160919	f
Rua Nova	93540	450101	f
Fajã	93541	450101	f
Fontainhas	93542	450101	f
Braga	93543	30307	f
Braga	93544	30352	f
Capela de S.José	93545	40902	f
Norte Pequeno	93546	450101	f
Vale das Amoras	93547	450101	f
Caminho Novo	93548	450101	f
Ribeira	93549	450101	f
Trofa	93550	30403	f
Vila Pouca	93551	30502	f
Miranda	93552	490154	f
Areeiro	93553	170501	f
Papanata	93554	160931	f
Campo da Feira	93555	160931	f
Freixedas	93556	91010	f
Cogula	93557	91304	f
Caminho Velho	93558	450101	f
Pombal	93559	40109	f
Alfarela de Jales	93560	171302	f
S. Sebastião de Touro	93561	180521	f
Rua das Flores	93562	131214	f
Bormela	93563	170501	f
Soutelo	93564	30514	f
Carvalho	93565	450101	f
Arcozelo	93566	90602	f
S. Lourenço de Ribapinhão	93567	171011	f
São Bartolomeu	93568	450101	f
Santa Comba, VNFC	93569	91412	f
Quintã	93570	30521	f
Lugar do Loureiro	93571	131209	f
Quinta dos Açores	93572	90101	f
Salvador de Eiró	93573	170205	f
Porta de Santa Bárbara	93574	30834	f
Quinta do Casal	93575	31247	f
Rua do Bacalhau	93576	160931	f
Vinhaça	93577	30516	f
Quelha Inácio de Barros	93578	160931	f
Rua do Paço	93579	160931	f
No rio, caiu de um barco	93580	160919	f
Rua Nova de Jerónimo Lopes	93581	160919	f
Mirandela	93582	40721	f
Airoso	93583	30521	f
Sardoal	93584	30521	f
Vilar de Ouro	93585	40727	f
Carrapatas	93586	40507	f
São Salvador	93587	40728	f
Bouça	93588	30514	f
Vila Meã, Deilão	93589	40211	f
Samil	93590	40240	f
Rua do Loureiro	93592	160919	f
Carreira de Pedro de Melo	93593	160931	f
Vinha	93594	30518	f
Rua do Cruzeiro do Mosteiro de São Domingos	93595	160919	f
Ribeira do Nabo	93596	450205	f
Caminho da Ribeira	93597	450101	f
Quelha do Estudo	93598	160931	f
Lameiros	93599	30514	f
Castanheiro	93600	30509	f
Castro	93601	30520	f
Rua de Baixo	93602	450101	f
Carreira	93603	30505	f
Rua do Robim	93604	160931	f
Estevais	93605	40807	f
Vilarinho das Azenhas	93606	41018	f
Zebras	93607	171227	f
São Cláudio	93608	160924	f
Braga	93609	30308	f
Cruzeiro de Santiago	93610	160931	f
Burga	93611	40506	f
Santa Justa	93612	70203	f
Junto à Câmara desta vila	93613	160931	f
Igreja Velha	93614	160931	f
Outeirinho	93615	30521	f
Canada da Cancela	93616	450101	f
Ladeira	93617	450101	f
Corredoura	93618	30506	f
Assares	93619	41001	f
Ao Postigo	93620	160931	f
Eirado do Ferrão	93621	160931	f
Rua Martins de Faria	93622	30213	f
Boavista	93623	30213	f
Rua da Esperança	93624	30213	f
São Miguel-o-Anjo	93625	30213	f
Rossas	93626	31113	f
Picoto	93627	30416	f
Avidagos	93628	40706	f
Ribeira do Nabo	93629	450206	f
Gandra	93630	30254	f
Quelha de Goa	93631	160919	f
Rua do Marquês	93632	160919	f
Casa Rvº Gabriel Pereira	93633	160919	f
Casa ama Águeda Pires	93634	160919	f
Travessa do Estudo	93635	160931	f
Travessa da Água	93636	160919	f
Sortes	93637	40248	f
Prova	93638	180521	f
Travessa dio Rubim	93639	160919	f
Rua da Água	93640	160919	f
Passos	93641	30238	f
Areal de Cima	93642	30213	f
Igreja	93643	30237	f
Tabosa de Arnas	93644	181816	f
Guilheiro	93645	91310	f
Val Concelho	93646	91417	f
Feitosa, Ponte de Lima	93647	160931	f
Aloques	93648	160931	f
Algodres	93649	90401	f
Ponte do Louro	93650	160931	f
Junto à Via Sacra	93651	160919	f
Travessa ndo Forno da Rua de S. sebastião	93652	160931	f
Travessa do Forno da Rua de S. Sebastião	93653	160931	f
R. Sacra	93654	160919	f
Rua de Santiago	93655	160931	f
Junto a Santa Clara	93656	160919	f
Vila Mou	93657	160919	f
Travessa do Penedo	93658	160919	f
a São Crispim	93659	160931	f
Nogueira	93660	30519	f
Mazouco	93661	40405	f
Afães de Cima	93662	30503	f
Mondrões	93663	30503	f
Picoto	93664	30503	f
Vilar	93665	30503	f
Porçã	93666	30503	f
Borba	93667	30503	f
Junto Chafariz S. Domingos	93668	160919	f
Lisboa	93669	490421	f
Pinhel	93670	490228	f
Perraço	93671	30517	f
Pousada	93672	30507	f
Varzea	93673	30501	f
Limoeiro	93674	31403	f
Constantim	93675	171407	f
Lombo	93676	40808	f
Travessa do Miranda	93677	160931	f
Lamas	93678	30503	f
Longroiva	93679	90907	f
Afães	93680	30503	f
Quelha da Água	93681	160931	f
Sucado	93682	30503	f
Lages	93683	30503	f
Bolada	93684	30517	f
Eirado de Santo Homem Bom	93685	160931	f
Laje	93686	30816	f
Grijó de Parada de Outeiro	93687	40219	f
Monção	93688	160417	f
Quinta da Torrinha	93689	41017	f
Quinta de Manuel de Morais	93690	41017	f
Rua de Santa Luzia	93691	160931	f
Britiande	93692	180504	f
Aveleiras, Miranda, Arcos de Valdevez	93693	160121	f
R. das Guardeiras	93694	160919	f
Vila Meã	93695	161014	f
Outeiro	93696	31230	f
.	93697	450102	f
Ribalonga	93698	40315	f
R. da Bandeira	93699	160919	f
Alijão	93700	30501	f
Azevo	93701	91003	f
Burgo	93702	30510	f
Fundevila	93703	30501	f
Lamegal	93704	91012	f
Almagreira	93705	410101	f
Almagreira do Nascente	93706	410101	f
Almagreira do Poente	93707	410101	f
Bom Despacho	93708	410101	f
Bom Despacho Velho	93709	410101	f
Brejo	93710	410101	f
Carreira	93711	410101	f
Covas	93712	410101	f
Farropo	93713	410101	f
Graça	93714	410101	f
Outeiro	93715	410101	f
Praia	93716	410101	f
Ribeira de São Domingos	93717	410101	f
Arrebentão	93718	410102	f
Baguinhas	93719	410102	f
Barreiro	93720	410102	f
Boa Vista	93721	410102	f
Covão da Mula	93722	410102	f
Fajã de São Lourenço	93723	410102	f
Feteiras	93724	410102	f
Feteiras(Outeiro)	93725	410102	f
Fontainhas	93726	410102	f
Forno	93727	410102	f
Grota do Meirinho	93728	410102	f
Igreja	93729	410102	f
Lagoinhas	93730	410102	f
Lagos	93731	410102	f
Moinho do Salto	93732	410102	f
Norte	93733	410102	f
Pico do Penedo	93734	410102	f
Picos	93735	410102	f
Pocilgas	93736	410102	f
Poço Grande	93737	410102	f
Ribeira do Amaro	93738	410102	f
Ribeira do Poldro	93739	410102	f
Salto	93740	410102	f
São Lourenço	93741	410102	f
Tagarete	93742	410102	f
Trunqueira	93743	410102	f
Almas	93744	410103	f
Azenha	93745	410103	f
Azenha de Baixo	93746	410103	f
Azenha de Cima	93747	410103	f
Boavista	93748	410103	f
Calheta	93749	410103	f
Cardal	93750	410103	f
Castelhana	93751	410103	f
Cruz	93752	410103	f
Cruz de Almagre	93753	410103	f
Cruz de São Mór	93754	410103	f
Fajãs	93755	410103	f
Feteirinha	93756	410103	f
Fonte do Jordão	93757	410103	f
Fontinhas	93758	410103	f
Grotas	93759	410103	f
Igreja	93760	410103	f
Jordão	93761	410103	f
Lapa	93762	410103	f
Loural	93763	410103	f
Malbusca	93764	410103	f
Nossa Senhora da Glória	93765	410103	f
Outeiro	93766	410103	f
Panasco	93767	410103	f
Pedreira	93768	410103	f
Ribeira do Cachaço	93769	410103	f
Santo António	93770	410103	f
Santo Espírito	93771	410103	f
Terra do Raposo	93772	410103	f
Água de Alto	93773	410104	f
Alto	93774	410104	f
Alto do Nascente	93775	410104	f
Alto do Poente	93776	410104	f
Banda de Além	93777	410104	f
Canaviais	93778	410104	f
Chã de João Tomé	93779	410104	f
Courelas	93780	410104	f
Covões	93781	410104	f
Faneca	93782	410104	f
Feteiras	93783	410104	f
Feteiras de Baixo	93784	410104	f
Feteiras de Cima	93785	410104	f
Flor da Rosa	93786	410104	f
Flor da Rosa Alta	93787	410104	f
Graça	93788	410104	f
Igreja	93789	410104	f
Lagos	93790	410104	f
Outeiro	93791	410104	f
Paul	93792	410104	f
Paul de Baixo	93793	410104	f
Paul de Cima	93794	410104	f
Pontes	93795	410104	f
Ribeira do Engenho	93796	410104	f
Roças	93797	410104	f
Almagreira	93798	410105	f
Almagreira de Nascente	93799	410105	f
Almagreira do Poente	93800	410105	f
Arrabalde	93801	410105	f
Arrifes	93802	410105	f
Barreiros	93803	410105	f
Boa Viagem	93804	410105	f
Bom Depacho (Almagreira)	93805	410105	f
Bom Despacho Velho	93806	410105	f
Brasil	93807	410105	f
Brejo	93808	410105	f
Caminho da Rocha	93809	410105	f
Carreira	93810	410105	f
Casas Velhas	93811	410105	f
Covas	93812	410105	f
Covas (Flor da Rosa)	93813	410105	f
Covas da Almagreira	93814	410105	f
Covas dos Arrifes	93815	410105	f
Farrobo	93816	410105	f
Flor da Rosa	93817	410105	f
Flor da Rosa Baixa	93818	410105	f
Fonte do Mourato	93819	410105	f
Fornos	93820	410105	f
Ladeiras	93821	410105	f
Ladeiras da Almagreira	93822	410105	f
Ladeiras do Nascente	93823	410105	f
Ladeiras do Ponente	93824	410105	f
Lomba	93825	410105	f
Moinho da Rocha	93826	410105	f
Moinho de Cima	93827	410105	f
Moinho do Meio (Vila)	93828	410105	f
Monteiro	93829	410105	f
Nossa Senhora dos Anjos	93830	410105	f
Pedras de São Pedro	93831	410105	f
Praça Municipal	93832	410105	f
Praia	93833	410105	f
Ribeira da Praia	93834	410105	f
Ribeira das Covas	93835	410105	f
Ribeira de São Domingos	93836	410105	f
Ribeira do Guterres	93837	410105	f
Rua 15 de Agosto	93838	410105	f
Rua da Alfândega	93839	410105	f
Rua da Boa Nova	93840	410105	f
Rua da Conceição	93841	410105	f
Rua da Cruz	93842	410105	f
Rua da Matriz	93843	410105	f
Rua da Misericórdia	93844	410105	f
Rua de Santo António	93845	410105	f
Rua Direita	93846	410105	f
Rua do Açougue	93847	410105	f
Rua do Campo	93848	410105	f
Rua do Chafariz	93849	410105	f
Rua do Dr. Juiz de Fora	93850	410105	f
Rua do Livramento	93851	410105	f
Rua do Norte	93852	410105	f
Rua dos Oleiros	93853	410105	f
Rua Nova	93854	410105	f
Saltinho	93855	410105	f
Salvaterra	93856	410105	f
Santa Ana	93857	410105	f
Santo Antão	93858	410105	f
Valverde	93859	410105	f
Vila	93860	410105	f
Cabouco	93861	430201	f
Caminho da Levada	93862	430201	f
Caminho da Ribeira da Agualva	93863	430201	f
Caminho Novo	93864	430201	f
Canada das Dadas	93865	430201	f
Canada das Tias	93866	430201	f
Canada do Correia	93867	430201	f
Canada do Morro	93868	430201	f
Canada Grande	93869	430201	f
Canada Velha	93870	430201	f
Castanheiros	93871	430201	f
Cruzeiro	93872	430201	f
Ladeira de Nossa Senhora	93873	430201	f
Outeiro do Filipe	93874	430201	f
Outeiros	93875	430201	f
Portela	93876	430201	f
Rua da Igreja	93877	430201	f
Rua da Portela	93878	430201	f
Rua do Açougue	93879	430201	f
Rua do Morro	93880	430201	f
Rua do Valverde	93881	430201	f
Rua dos Moinhos	93882	430201	f
Rua Velha	93883	430201	f
Bairro Alto	93884	430208	f
Cabo	93885	430208	f
Caminho do Concelho	93886	430208	f
Caminho dos Moinhos	93887	430208	f
Canada da Fonte do Gato	93888	430208	f
Canada da Igreja	93889	430208	f
Canada da Vista	93890	430208	f
Canada do Capitão Domingos	93891	430208	f
Canada do Tenente Joaquim Coelho	93892	430208	f
Canada Nova	93893	430208	f
Cascalho	93894	430208	f
Cruzeiro	93895	430208	f
Estrada Pública	93896	430208	f
Igreja	93897	430208	f
Ladeira Alta	93898	430208	f
Moinhos	93899	430208	f
Ribeira Grande	93900	430208	f
Calvário	93901	430210	f
Caminho do Concelho	93902	430210	f
Caminho do Meio	93903	430210	f
Canada da Abrigada	93904	430210	f
Canada da Bernarda	93905	430210	f
Canada da Bezerra	93906	430210	f
Canada da Igreja	93907	430210	f
Canada da Ribeira das Pedras	93908	430210	f
Canada das Bicas	93909	430210	f
Canada de Francisco Borges	93910	430210	f
Canada de Tomás de Bettencourt	93911	430210	f
Canada do Boqueirão	93912	430210	f
Canada dos Galinheiros	93913	430210	f
Canada Funda	93914	430210	f
Casa contígua à Igreja	93915	430210	f
Estrada Real	93916	430210	f
Junto à Ermida da Senhora da Ajuda	93917	430210	f
Junto à Igreja	93918	430210	f
Pico da Rocha	93919	430210	f
Praça	93920	430210	f
Ribeira da Agualva	93921	430210	f
Ribeira da Areia	93922	430210	f
Ribeira das Pedras	93923	430210	f
Rua da Misericórdia	93924	430210	f
Rua das Covas	93925	430210	f
Rua do Cabo	93926	430210	f
Rua do Cabôco	93927	430210	f
Rua do Cruzeiro	93928	430210	f
Rua do Passal	93929	430210	f
Rua do Rego	93930	430210	f
Rua Primeira	93931	430210	f
Quinta do Carrascal	93932	40916	f
Fronte da Igreja	93933	160931	f
Carreira de Santa Ana	93934	160931	f
Moinhos	93935	30503	f
Carvalhas	93936	30503	f
Escarigo	93937	90407	f
Quinta da Serra, Sta. Ágata de Carrolão	93938	490355	f
Mota	93939	30510	f
Laje	93940	30822	f
Canto da Rua Grande	93941	160931	f
Figueira de Castelo Rodrigo	93942	490222	f
Cortiçada	93943	90103	f
Ventuzela	93944	131426	f
Subinhal	93945	30510	f
R. Roque Gomes	93946	160919	f
Figueiró	93947	90504	f
Safurdão	93948	91021	f
Bouçoães	93949	171205	f
Vila Real	93950	490427	f
Vila Pouca de Aguiar	93951	171314	f
Vila Real	93952	490355	f
Laje	93953	30871	f
Algodres	93954	90501	f
Golfeiras	93955	40721	f
Rua de S. Pedro	93956	160931	f
Rua de S. Sebastião	93957	160931	f
De fronte de S. Crispim	93958	160931	f
Rua de Coelho Jorge	93959	160931	f
Praça da Ribeira	93960	160931	f
Ao Carmo	93961	160931	f
Monção, Viana do Castelo	93962	490335	f
Cardielos	93963	10312	f
Rua da Misericórdia	93964	160919	f
Beira Grande	93965	40302	f
Ribeirinha	93966	460103	f
São Pedro	93967	30501	f
Souto	93968	30510	f
Povoa	93969	30510	f
Aldeia	93970	30505	f
Praça das Couves Rua do Eirado	93971	160931	f
Praça da Palha	93972	160931	f
Coimbra	93973	490416	f
Biscoito	93974	460103	f
Eirado de Altamira	93975	160919	f
Junto Convento dos Crúzios	93976	160919	f
Iteiro	93978	30807	f
Taipas	93979	30808	f
Postigo da Guia	93980	30834	f
Ponte de Lima	93981	160931	f
Mascarenhas	93982	40720	f
Pontevedra	93983	160931	f
Travessa António Lobo da Cunha	93984	160919	f
?? Monserrate	93985	160919	f
Forno do Cal	93986	460103	f
Cubalhão	93987	160306	f
Travessa do Forno	93988	160931	f
Travessa dos Fornos	93989	160931	f
Sidrô	93990	30807	f
S. Mamede, Areosa, Viana do Castelo	93991	160905	f
Areosa, Viana do Castelo	93992	160905	f
Quinta de Lamelas	93993	40910	f
Quinta da Torrinha	93994	490254	f
R. da Lama, frente Igreja Monserrate	93996	160919	f
Rua das Tendas	93997	160931	f
Rua da Carreira	93998	160931	f
Vilar de Perdizes	93999	170628	f
Macedo de Cavaleiros	94000	490153	f
Rua de Gonçalo Bravo	94001	160931	f
Pontilhões Velhos	94003	30807	f
São Martinho	94004	30873	f
Bouça	94005	40708	f
Lemos de Baixo	94006	30815	f
Bouça	94008	30503	f
Prova	94012	90913	f
Lameirinhos	94013	30510	f
Rua Roque de Barros	94016	160931	f
Souto	94017	30213	f
Monte	94018	30213	f
Arrifana	94019	40534	f
Castelo de Santiago da barra	94024	160919	f
Quelha estreita da Rua da Bandeira	94025	160931	f
Casa Antº Lopes Ortis	94026	160919	f
Travessa de Gracia Lopes	94027	160919	f
Casa D. Luis Silveira	94028	160919	f
Arco da Ribeira	94029	160919	f
R. S. Catarina junto ao castelo	94030	160919	f
Fajã dos Cubres	94031	450101	f
Travessa de São Domingos	94032	160919	f
Junto a Santiago	94034	160919	f
Santiago da Barra	94035	160919	f
Fetais	94036	460101	f
Feteira	94037	460101	f
Fajãs	94038	460101	f
Boca das Canadas	94039	460101	f
Casais	94040	30807	f
Fontinha	94041	30510	f
Montenegro	94042	30501	f
R. S. Sebastião frente S. Clara	94044	160919	f
Travessa do Mata Mouros	94045	160919	f
Valverde	94046	160931	f
Gruta dos Fiéis de Deus	94047	460102	f
Outeiro	94050	30237	f
Sendim	94051	40614	f
Penedos	94052	30505	f
Cais de São Bento	94053	160931	f
R. dos Caleiros, banda do mar	94054	160919	f
Rua do Cais	94055	160919	f
Junto S. Catarina « a nova»	94056	160919	f
Rua dos Abraços	94057	160931	f
Múrias	94058	40722	f
Requião	94059	30838	f
Jogo da Bola	94060	460101	f
Ribeira Grande	94061	460101	f
Veiga	94062	30857	f
Azenha	94063	30862	f
Cima da Vila	94064	30858	f
Dafões	94065	30510	f
Fragas	94066	30519	f
Cêgoa	94067	30502	f
Rua atrás da Igreja	94068	460101	f
Retorta	94069	30503	f
Cascalho	94070	30519	f
Crusinha	94071	30503	f
Botelhão	94072	30511	f
Cerca das Capuchas	94073	30863	f
Rua de São Marcos	94074	30352	f
Canada de Miguel Vieira	94075	460106	f
Porto de Ave	94076	30926	f
Vale de Casas	94077	171228	f
Terreiro de São Domingos	94078	160931	f
Granja	94079	30510	f
Monfebres	94080	91409	f
Cidral	94081	130303	f
Lameirão	94082	30510	f
Rua dos Clérigos	94083	131215	f
De trás Igreja Grande	94084	160931	f
De fronte da Burgueira	94085	160931	f
R. da Lama	94086	160931	f
Junto Cruzeiro S. Domingos	94087	160931	f
Abaixo S. João (D'Arga)	94088	160931	f
Fajã	94090	450204	f
Frente Cruzeiro S. Domingos	94091	160931	f
Praça do peixe velha	94092	160931	f
Em frente da Piedade	94093	160931	f
Junto Igreja Grande	94094	160931	f
Sob a Ribeira	94095	160931	f
Misericórdia	94096	160931	f
Junto ao canto de Jerónimo de Darque	94097	160931	f
Junto ao canto de João de Darque	94098	160931	f
Portela de S. João	94099	160931	f
R. de Pedro Bravo	94100	160931	f
Frente da Igreja Matriz	94101	160931	f
R. Damião	94102	160931	f
R. do Chafariz	94103	160931	f
Lugar da Vilheira, arrabalde	94104	160931	f
Casas do Marquês	94105	160931	f
Arrabalde do Bonfim	94106	30214	f
Cativelos	94107	90603	f
Junto a S. Catarina	94108	160931	f
Outeiro	94109	30501	f
Quintela	94110	30517	f
Junto a S. Domingos	94111	160931	f
Frente ao Cheiradeiro	94112	160931	f
Azinhoso	94113	40801	f
Alfama	94114	110651	f
Refojos	94115	131301	f
Lages	94116	160201	f
Lameira	94117	160201	f
Lomba	94118	160201	f
Gorgolada	94119	160214	f
Guia	94120	160214	f
Funchal	94121	160218	f
Portela	94122	160218	f
Corgo	94123	160219	f
Portela	94124	160219	f
Chão do Carqueijal	94125	160220	f
Santos	94126	160520	f
São Félix	94127	161002	f
Aldeia	94128	161013	f
Espinhosa	94129	161013	f
Couto	94130	170312	f
Glória	94131	410103	f
Maia	94132	410103	f
Prainha	94133	460301	f
S. Pedro de Vale do Conde	94134	40721	f
Grijó	94135	30502	f
Cabeços	94136	160905	f
Temperas	94137	30502	f
Ribeiro	94138	30213	f
Largo do Tanque	94139	30213	f
Caldeira	94140	480102	f
Coada	94141	480102	f
Fajã Grande	94142	480102	f
Fajãzinha	94143	480102	f
Mosteiros	94144	480102	f
Mosteiros	94145	480102	f
Ponta	94146	480102	f
Ponta	94147	480102	f
Canto	94148	480203	f
Casas de Baixo	94149	480203	f
Cruz dos Penedos	94150	480203	f
Farol do Alvernaz	94151	480203	f
Junçal	94152	480203	f
Monte Calvário	94153	480203	f
Outeiro do Vento	94154	480203	f
Ponta Ruiva	94155	480203	f
Porto	94156	480203	f
Ribeira da Fazenda	94157	480203	f
Ribeira dos Moinhos	94158	480203	f
Ribeirinha	94159	480203	f
Rua da Arrochela	94160	480203	f
Rua da Cruz	94161	480203	f
Rua da Cruz Nova	94162	480203	f
Rua da Escadinha	94163	480203	f
Rua da Fonte do Moleiro	94164	480203	f
Rua da Fonte do Moleiro	94165	480203	f
Rua da Grota	94166	480203	f
Rua da Igreja	94167	480203	f
Rua da Ladeira	94168	480203	f
Rua da Levada	94169	480203	f
Rua da Ribeirinha da Cruz	94170	480203	f
Rua da Terra Chã	94171	480203	f
Rua da Travessa	94172	480203	f
Rua das Casas do Concelho	94173	480203	f
Rua das Ceves	94174	480203	f
Rua das Pedras Brancas	94175	480203	f
Rua de S. Pedro	94176	480203	f
Rua do Estaleiro	94177	480203	f
Rua do Outeiro	94178	480203	f
Rua do Passal	94179	480203	f
Rua do Portinho	94180	480203	f
Rua do Porto	94181	480203	f
Rua do Quarteiro	94182	480203	f
Rua do Vento	94183	480203	f
Terra Chã	94184	480203	f
Terra de Dentro	94185	480203	f
Seara	94186	30808	f
Matinho	94187	30238	f
Caldinhas	94188	30808	f
Canhota	94189	30808	f
Alvite	94190	30858	f
Quintães	94192	30849	f
Eirado do peixe	94193	160931	f
Arbonça	94194	30517	f
Fundão	94195	50417	f
Ferrujal	94196	30873	f
Devesa do Miogo	94198	30838	f
Saiado	94199	30838	f
Rua da Cruz de Pau	94200	110628	f
Rua do Passadiço	94201	110614	f
Ribeiro	94202	30873	f
Caleira Longa	94204	160931	f
Poiares Santo André	94208	61703	f
Praia	94211	160931	f
Outeiro	94212	30515	f
Tui	94213	160931	f
Muxagata	94214	90511	f
Paradela	94216	30510	f
Quinta Branca	94217	40910	f
Pombeiro	94218	130315	f
Tapado	94219	30510	f
Vacaria	94220	30520	f
Assento	94221	30503	f
Ventosela	94222	30510	f
Casais	94223	30507	f
Porta do Postigo	94224	160931	f
Castelo S. Tiago da Barra	94225	160931	f
Gandarinha	94226	30271	f
Carvalhal	94227	30271	f
Rua do Infante Dom Henrique	94228	30214	f
Vila Pouca de Aguiar	94229	171303	f
Portela	94230	30503	f
Pereiro	94231	91016	f
Pernambuco, Brasil	94232	160919	f
Giestas	94234	30208	f
Quelha dos Bacalhaus	94235	160931	f
Rua de Santana	94236	160919	f
Paredes	94237	30510	f
Quintã	94238	30519	f
Lombo	94239	30513	f
Redondo	94240	30503	f
Quinta	94241	30836	f
Outeiro	94242	30835	f
Sorval	94243	91023	f
Viana do Castelo	94244	160931	f
Largo da Fonte	94245	30213	f
Sabugueiro	94246	30521	f
Outeiro	94247	30507	f
Cedães	94248	40712	f
Arco da Amaroa ?	94249	160931	f
França	94250	160931	f
Outeiro	94252	30510	f
Monte	94253	30516	f
Rua de Santa Catarina	94254	160919	f
Rua da Esperança	94255	160919	f
Penela	94256	490185	f
Rua do Anjo	94257	160931	f
Feixe	94258	30513	f
Santa Marinha	94259	30510	f
Abaixo do Corpo da Guarda	94260	160919	f
Loja daPrega	94261	160919	f
Detrás de Monserrate	94262	160919	f
Corpo da Guarda	94263	160919	f
Vermiosa	94264	90415	f
Rua do Espírito Santo	94265	160919	f
Bem Viver	94266	160931	f
Abelheira	94267	160919	f
Detrás da Ermida de Santiago	94268	160919	f
Rua de Santa Catarina, a meio	94269	160919	f
Santa Maria de Emeres	94270	171219	f
La Rochelle	94271	160931	f
Quelha das Cecilianas	94272	160919	f
Travessa de Cecília Vaz	94273	160919	f
Portela - Eira da Venda	94274	160919	f
Travessa de São Sebastião	94275	160919	f
Sabariz	94276	160936	f
Rua do Loureiro, indo para o Castelo	94277	160919	f
Terreiro de Santa Catarina	94278	160919	f
Corpo da Guarda	94279	160931	f
Barra (mouros)	94280	160919	f
Rua de Santa Catarina, defronte de Gandano	94281	160919	f
Beco da Senhorinha Pereira	94282	160919	f
Santa Catarina, junto à Ribeira	94283	160919	f
Segundo arco junto a Santo Homem Bom	94284	160919	f
Terreiro de S. Domingos	94285	160919	f
Rossio de Santo Homem Bom, parte de dentro do arco	94286	160919	f
Sub-a-Ribeira	94287	160919	f
Rua Nova de Pedro de Melo	94288	160919	f
Rua de Santa Catarina, junto a Pedro Jordão	94289	160919	f
Rua de Santa Catarina, ao fim	94290	160919	f
Rua das Naus?	94291	160919	f
Rua do Loureiro - junto quelha do Gandavo	94292	160919	f
Arco de São Tomé	94293	160919	f
Rua de São Sebastião, junto ao Cruzeiro de São Domingos#	94294	160919	f
Casas do capitão Velho, Rua de São Sebastião#	94295	160919	f
Afogado	94296	160205	f
Agrinhos	94297	160205	f
Além Rio	94298	160205	f
Alentejo	94299	160205	f
Alqueirão	94300	160205	f
Assassinado/a	94301	160205	f
Avelar	94302	160205	f
Balbasto	94303	160205	f
Barreiros	94304	160205	f
Bouças	94305	160205	f
Cal	94306	160205	f
Capela de São Gonçalo	94307	160205	f
Cardadouro	94308	160205	f
Carido	94309	160205	f
Carvalhal	94310	160205	f
Casa do Naval	94311	160205	f
Castelo	94312	160205	f
Colarinha	94313	160205	f
Cortevelha	94314	160205	f
Cruz	94315	160205	f
Cruzeiro	94316	160205	f
Devesa	94317	160205	f
Enforcado	94318	160205	f
Fiais	94319	160205	f
Fora	94320	160205	f
Guerra	94321	160205	f
Laje	94322	160205	f
Lourido	94323	160205	f
Matada	94324	160205	f
Moimento	94325	160205	f
Moinho	94326	160205	f
Moinho do Atalho	94327	160205	f
Nabal	94328	160205	f
Pedra da Bouça	94329	160205	f
Pedra Encostada	94330	160205	f
Penedo	94331	160205	f
Pereiras	94332	160205	f
Ponte	94333	160205	f
Portela	94334	160205	f
Quebradoura	94335	160205	f
Quinta de Balbasto	94336	160205	f
Quinta de São Gonçalo	94337	160205	f
Rego	94338	160205	f
Rego de Marouco	94339	160205	f
Rio	94340	160205	f
Salgueiro	94341	160205	f
Santa Cruz	94342	160205	f
Sopo	94343	160205	f
Supalheiro	94344	160205	f
Torre	94345	160205	f
Trás os Montes	94346	160205	f
Vale Chão	94347	160205	f
Viso	94348	160205	f
Cristelo	94349	160212	f
Afogada na Ínsua	94350	160207	f
Afogado na barra	94351	160207	f
Afogado na paria de Oia	94352	160207	f
afogado no Cabedelo	94353	160207	f
Afogado no mar	94354	160207	f
Afogado no rio	94355	160207	f
Afogado num poço	94356	160207	f
Arrojado À praia	94357	160207	f
Boavista	94358	160207	f
Cabana (arrabalde)	94359	160207	f
Cabo da Rua da Misericórdia	94360	160207	f
Cadeia	94361	160207	f
Camarido	94362	160207	f
Campanha do Alentejo	94363	160207	f
Castela	94364	160207	f
Castela, exército	94365	160207	f
Cativeiro	94366	160207	f
Chafariz	94367	160207	f
Convento de Santa Clara	94368	160207	f
Cruzeiro da Fonte da Vila	94369	160207	f
Dentro da Vila	94370	160207	f
Entrada da Graça	94371	160207	f
Exército	94372	160207	f
Fonte da Vila	94373	160207	f
Fonte do chafariz	94374	160207	f
Fora	94375	160207	f
Forte da Ínsua	94376	160207	f
Frente ao adro, na Rua dos Meios	94377	160207	f
Hospital da Misericórdia	94378	160207	f
Hospital da Misericórdia - Loja do Hospital	94379	160207	f
Hospital da Misericórdia - Parte de baixo do Hospital	94380	160207	f
Hospital de S. João de Deus	94381	160207	f
Hospital de Santa Margarida	94382	160207	f
Hospital Real	94383	160207	f
Junto à Igreja	94384	160207	f
Junto ao adro	94385	160207	f
Junto ao adro - No adro da Igreja Matriz	94386	160207	f
Junto ao Corpo da Guarda	94387	160207	f
Junto ao Mosteiro das Freiras	94388	160207	f
Nau	94389	160207	f
Naufrágio na barra	94390	160207	f
Naufrágio no mar	94391	160207	f
Naufrágio no rio	94392	160207	f
Pé do Mosteiro	94393	160207	f
Pé do Mosteiro - Calçada da Escola	94394	160207	f
Pé do Mosteiro - Calçada de Santo António	94395	160207	f
Pé do Mosteiro - Quartel de Santo António	94396	160207	f
Pé do Mosteiro - Rua Benemérito Joaquim Rosa	94397	160207	f
Pé do Mosteiro - Rua da Escola	94398	160207	f
Pé do Mosteiro - Rua de Santo António	94399	160207	f
Pé do Mosteiro - Rua do Cemitério	94400	160207	f
Pé do Mosteiro - Rua Nova de Santo António	94401	160207	f
Pé do Mosteiro - Rua Saraiva de Carvalho	94402	160207	f
Porta da Vila	94403	160207	f
Porta de Viana	94404	160207	f
Porta do Relógio	94405	160207	f
Porta do Sol	94406	160207	f
Porta Nova	94407	160207	f
Portas da Sra. da Boa Nova	94408	160207	f
Praça Municipal	94409	160207	f
Praia do Cabedelo	94410	160207	f
Princípio da Rua da Misericórida	94411	160207	f
Quelha da Rua da Palha	94412	160207	f
Quinta da Graça	94413	160207	f
Quinta da Lomba	94414	160207	f
Quinta de Leiras	94415	160207	f
Quinta de Venade	94416	160207	f
Ribeira	94417	160207	f
Rio	94418	160207	f
Rio de Ouro	94419	160207	f
Rio de Ouro - Rego do Ouro	94420	160207	f
Rua da Corredoura	94421	160207	f
Rua da Corredoura - Calçada da Escola	94422	160207	f
Rua da Corredoura - Quinta da Rocha	94423	160207	f
Rua da Corredoura - Repuxo	94424	160207	f
Rua da Corredoura - Rua da Escola	94425	160207	f
Rua da Corredoura - Rua Saraiva de Carvalho	94426	160207	f
Rua da Corredoura - Travessa do Repuxo	94427	160207	f
Rua da Misericórdia - Asilo Senhor dos Mareantes	94428	160207	f
Rua da Misericórdia - Campo da Agonia	94429	160207	f
Rua da Misericórdia - Convento de Santo António	94430	160207	f
Rua da Misericórdia - Largo da Sra. da Agonia	94431	160207	f
Rua da Misericórdia - Lugar do Calvário	94432	160207	f
Rua da Misericórdia - Ponte de Esteiró	94433	160207	f
Rua da Misericórdia - Repuxo dda Misericórdia	94434	160207	f
Rua da Misericórdia - Rua da Agonia	94435	160207	f
Rua da Misericórdia - Rua da Trincheira	94436	160207	f
Rua da Misericórdia - Rua da Trindade	94437	160207	f
Rua da Misericórdia - Rua detrás dos Açougues	94438	160207	f
Rua da Misericórdia - Rua do Calvário	94439	160207	f
Rua da Misericórdia - Rua do Pombal	94440	160207	f
Rua da Misericórdia - Rua do Repuxo	94441	160207	f
Rua da Misericórdia - Rua dos Pescadores	94442	160207	f
Rua da Misericórdia extramuros	94443	160207	f
Rua da Misericórdia extramuros - Portas do Cabo	94444	160207	f
Rua da Misericórdia extramuros - Rua da Calçada	94445	160207	f
Rua da Misericórdia extramuros - Rua dos Pescadores	94446	160207	f
Rua da Misericórdia, de dentro das portas novas	94447	160207	f
Rua da Piedade	94448	160207	f
Rua da Quelha	94449	160207	f
Rua da Retorta	94450	160207	f
Rua da Retorta - Campo da Retorta	94451	160207	f
Rua da Retorta - Junto à Muralha	94452	160207	f
Rua da Retorta - Largo da Retorta	94453	160207	f
Rua da Retorta - Rua da Retortinha	94454	160207	f
Rua da Retorta - Rua dos Quintais	94455	160207	f
Rua da Ribeira	94456	160207	f
Rua da Ribeira - Avenida	94457	160207	f
Rua da Ribeira - Frente à Igreja Paroquial	94458	160207	f
Rua da Ribeira - Muralha da Igreja	94459	160207	f
Rua da Ribeira - Rua 16 de Setembro	94460	160207	f
Rua da Ribeira - Rua da Escola	94461	160207	f
Rua da Ribeira - Rua da Igreja	94462	160207	f
Rua da Ribeira - Rua da Matriz	94463	160207	f
Rua da Ribeira - Rua da Muralha	94464	160207	f
Rua da Ribeira - Rua do Barão de São Roque	94465	160207	f
Rua da Ribeira - Rua Nova da Ribeira	94466	160207	f
Rua da Ribeira - Travessa da Rua da Ribeira	94467	160207	f
Rua da Vila	94468	160207	f
Rua das atafonas	94469	160207	f
Rua das Cabras	94470	160207	f
Rua das Cabras - Rua do Hospital	94471	160207	f
Rua das Cabras - Rua do Relho	94472	160207	f
Rua das Flores	94473	160207	f
Rua das Flores - Rua Nova da Ribeira	94474	160207	f
Rua das Flores - Travessa da Rua das Flores	94475	160207	f
Rua de Meios	94476	160207	f
Rua de Meios - Nas costas da igreja Matriz	94477	160207	f
Rua de Meios - Rua da Matriz	94478	160207	f
Rua de Meios - Rua de dentro	94479	160207	f
Rua de Meios - Rua do Hospital	94480	160207	f
Rua de Meios - Santo António	94481	160207	f
Rua de Meios - Travessa da Cadeia	94482	160207	f
Rua de Meios - Travessa do Hospital	94483	160207	f
Rua de São João	94484	160207	f
Rua de São João - Avenida Manuel Xavier	94485	160207	f
Rua de São João - Campo da Feira	94486	160207	f
Rua de São João - Campo de São João	94487	160207	f
Rua de São João - Estação da Ferrovia	94488	160207	f
Rua de São João - Rua da Estação	94489	160207	f
Rua de São João - Travessa de São João	94490	160207	f
Rua de Stº António dos Esquecidos	94491	160207	f
Rua Direita	94492	160207	f
Rua Direita - Muralha	94493	160207	f
Rua Direita - Travessa dua Rua Direita	94494	160207	f
Rua do Cais	94495	160207	f
Rua do Cais - Avenida	94496	160207	f
Rua do Cais - Largo do Cais	94497	160207	f
Rua do Cais - Portas do Cais	94498	160207	f
Rua do Cais - Travessa do Cais	94499	160207	f
Rua do Cemitério	94500	160207	f
Rua do Forno	94501	160207	f
Rua do Poço	94502	160207	f
Rua do Rego do Ouro	94503	160207	f
Rua do Rio de Ouro	94504	160207	f
Rua do Sol	94505	160207	f
Rua do Terreiro	94506	160207	f
Rua do Vau - Campo da Feira	94507	160207	f
Rua do Vau - Largo da Ponte	94508	160207	f
Rua do Vau - Lugar da Ponte	94509	160207	f
Rua do Vau - Rua da Ponte	94510	160207	f
Rua do Vau - Rua do Relho	94511	160207	f
Rua do Vau - Rua do Vau, ao pé da Misericórdia	94512	160207	f
Rua do Vau - Travessa da Ponte	94513	160207	f
Rua do Vau de Baixo	94514	160207	f
Rua do Vau do Cais	94515	160207	f
Rua do Vau do Cais	94516	160207	f
Rua Nova	94517	160207	f
Terreiro	94518	160207	f
Terreiro - Campo do Terreiro	94519	160207	f
Terreiro - Casa do Paço do concelho	94520	160207	f
Terreiro - Esquina do Terreiro	94521	160207	f
Terreiro - Paço do Concelho	94522	160207	f
Terreiro - Paços do Concelho	94523	160207	f
Terreiro - Praça Conselheiro Silva Torres	94524	160207	f
Terreiro - Praça Municipal	94525	160207	f
Terreiro - Rua da Praça Municipal	94526	160207	f
Terreiro - Rua do Terreiro	94527	160207	f
Terreiro do Chafariz	94528	160207	f
Travessa da Praça	94529	160207	f
Viela do Terreiro	94530	160207	f
Vinha Velha	94531	160207	f
Casa Florestal do Camarido	94532	160208	f
Fortaleza da Ínsua	94533	160208	f
Sua Quinta	94534	160216	f
Quinta da Areosa	94535	160905	f
Estalagem do Cais de S. Lourenço	94536	160911	f
Hospital	94537	160931	f
Afogado	94538	160208	f
Alentejo	94539	160208	f
Assassinado	94540	160208	f
Fora	94541	160208	f
Suicídio	94542	160208	f
Afogado	94543	160213	f
Aldeia	94544	160213	f
Alentejo	94545	160213	f
Barros	94546	160213	f
Boucinha	94547	160213	f
Cabanas	94548	160213	f
Cabo	94549	160213	f
Cachada Velha	94550	160213	f
Cancela	94551	160213	f
Carejos	94552	160213	f
Carotes	94553	160213	f
Carvalhais	94554	160213	f
Carvalhas	94555	160213	f
Casa Nova	94556	160213	f
Chãozinho	94557	160213	f
Crasto	94558	160213	f
Eira Velha	94559	160213	f
Fojaco	94560	160213	f
Fojo	94561	160213	f
Fora	94562	160213	f
Gondar	94563	160213	f
Guerra	94564	160213	f
Mato	94565	160213	f
Pedras Frias	94566	160213	f
Redondelo	94567	160213	f
Roçada	94568	160213	f
Romarigães	94569	160213	f
São Martinho	94570	160213	f
Sisto	94571	160213	f
Valdocarro	94572	160213	f
Vieiro	94573	160213	f
Afogado	94574	160214	f
Alentejo	94575	160214	f
Assassinado/a	94576	160214	f
Ausente	94577	160214	f
Beiras	94578	160214	f
Borda de Água	94579	160214	f
Casa da Armada	94580	160214	f
Fora	94581	160214	f
Guerra	94582	160214	f
Quinta de Santo Amaro	94583	160214	f
Quinta do Pinto	94584	160214	f
Trás os Montes	94585	160214	f
Espantar	94586	160920	f
Acidente	94587	160218	f
Afogado no rio	94588	160218	f
Agrelo	94589	160218	f
Aldeia	94590	160218	f
Alentejo	94591	160218	f
Ausente	94592	160218	f
Aveleira	94593	160218	f
Barrocas	94594	160218	f
Bouça	94595	160218	f
Braçais	94596	160218	f
Cabo	94597	160218	f
Cachadinha	94598	160218	f
Cancela	94599	160218	f
Carvalhinho	94600	160218	f
Casal	94601	160218	f
Castro	94602	160218	f
Cavada	94603	160218	f
Chão  de  Marinhas	94604	160218	f
Chelo	94605	160218	f
Coberna	94606	160218	f
Costado	94607	160218	f
Cruzeiro	94608	160218	f
Devesa	94609	160218	f
Eiras	94610	160218	f
Fial	94611	160218	f
Fora	94612	160218	f
Guena	94613	160218	f
Guerra	94614	160218	f
Lajes	94615	160218	f
Moinhos do Viso	94616	160218	f
Monte	94617	160218	f
Murada	94618	160218	f
Pereira	94619	160218	f
Pináculo	94620	160218	f
Pombo	94621	160218	f
Ponte	94622	160218	f
Portelo da Veiga	94623	160218	f
Pregoim	94624	160218	f
Presa	94625	160218	f
Presa	94626	160218	f
Quinta da Aveleira	94627	160218	f
Quinta da Barge	94628	160218	f
Quinta de Braçais	94629	160218	f
Quinta do Castro	94630	160218	f
Ranha	94631	160218	f
Ranhada	94632	160218	f
Riadouro	94633	160218	f
Rocha	94634	160218	f
Telhadas	94635	160218	f
Torrão	94636	160218	f
Torre	94637	160218	f
Valas	94638	160218	f
Vales	94639	160218	f
Vau	94640	160218	f
Veiga	94641	160218	f
Viso	94642	160218	f
Afogado	94643	160219	f
Afogado no rio	94644	160219	f
Cabana	94645	160219	f
Cabeçouto	94646	160219	f
Cabedelo	94647	160219	f
Camarido	94648	160219	f
Cambezes	94649	160219	f
Cartemil	94650	160219	f
Cativeiro	94651	160219	f
Estação de Caminha	94652	160219	f
Esteiró	94653	160219	f
Estrada Nova/Esteiró	94654	160219	f
Fonte de Vila	94655	160219	f
Fora	94656	160219	f
Fornas	94657	160219	f
Fraga	94658	160219	f
Graça	94659	160219	f
Guerra	94660	160219	f
Lugar da Fábrica	94661	160219	f
Lugar das Hortas	94662	160219	f
Meijoadas	94663	160219	f
Olheiros	94664	160219	f
Pena	94665	160219	f
Penacova	94666	160219	f
Quinta da Cabana	94667	160219	f
Quinta da Fonte de Vila	94668	160219	f
Quinta da Graça	94669	160219	f
Quinta da Pena	94670	160219	f
Quinta de S. Roque	94671	160219	f
Quinta de Valindo	94672	160219	f
Quinta do Condado	94673	160219	f
Quinta do Corgo	94674	160219	f
Quinta do Coto	94675	160219	f
Quinta do Loreto	94676	160219	f
Quinta do Souto	94677	160219	f
Rua de Santto António	94678	160219	f
Rua do Pombal	94679	160219	f
Rua do Vau	94680	160219	f
Rua Nova	94681	160219	f
S. Sebastião	94682	160219	f
Senande	94683	160219	f
Souto	94684	160219	f
Urraca	94685	160219	f
Vale	94686	160219	f
Rua dos Caleiros	94687	160919	f
Campo do Peixe	94688	160931	f
Defronte da porta de São João	94689	160919	f
Viela da rua de S. Sebastião para a rua de Altamira	94690	160919	f
Rua nova junto à casa de Alexandre de Amorrim	94691	160919	f
Defronte da Ermida da Penha da França	94692	160919	f
ERmida para a parte do Castelo	94693	160919	f
Rua das Rosas, junto a Montserrat	94694	160919	f
Quelha do Pe. Domingos António	94695	160919	f
Bem Viver	94696	490286	f
Anvers	94697	160931	f
Fajã de São João	94698	450105	f
Trancoso	94699	490231	f
Rua das Cordas	94700	160915	f
Rua da Parenta	94701	160919	f
Campo do Forno	94702	160919	f
Feira	94703	30507	f
R. das Correias	94705	160931	f
Terra do pão	94706	460205	f
Peredo de Bemposta	94707	40813	f
Quinta da Argaçosa	94708	160931	f
Travessa do Rubim	94709	160931	f
Quintiães	94710	30262	f
Espinhal	94711	61402	f
Carrazedo de Montenegro	94712	171207	f
R do Terreiro de Santana	94713	160931	f
Junto à Igreja Velha	94714	160931	f
R. da Bandeira, junto à Leira Longa	94715	160931	f
Vindo de Santiago	94716	160931	f
R. da Bandeira defronte António do Porto	94717	160931	f
R. da Cruz do João de Darque	94718	160931	f
R. Pascoal Fiúza	94719	160931	f
Junto à Igreja Matriz	94720	160931	f
Paço	94721	30848	f
Sobrado	94722	30868	f
Carvalho	94723	30816	f
Santa Comba	94724	40241	f
Lamas	94725	30507	f
Senhorinha	94726	30406	f
Porta do Carmo	94727	160931	f
Ventozelo	94728	40825	f
Assento	94729	30507	f
Rua Gaspar Fagundes	94730	160931	f
Ribeira	94731	30856	f
Costeirinha	94732	30507	f
Terreiro da Feira	94733	30808	f
Ponte	94734	30868	f
Cales	94735	30510	f
Levandeira	94736	30519	f
Outeiral	94737	30513	f
Travassos	94738	30519	f
Rio	94739	30519	f
Matinho	94740	30507	f
Lamelas	94741	30513	f
Barreiro	94742	30501	f
Caminho Velho	94743	430208	f
Ramada	94744	30513	f
Jou	94745	170704	f
Valverde	94746	40735	f
Costinha	94747	30519	f
Ariz	94748	180501	f
Igreja	94749	30515	f
Caminho	94750	30510	f
Casal	94751	30501	f
Barreiros	94752	30518	f
Nossa Senhora de Guadalupe, Ilha Graciosa	94753	430208	f
Travessa de Garcia Lopes	94754	160931	f
Santiago de Gondufe, Ponte de Lima	94755	160931	f
Agualva, Praia da Vitória	94756	430208	f
Biscoitos, praia da Vitória	94757	430208	f
Pocariça	94758	60211	f
Urrós	94759	40821	f
Travessa de Roque Gomes	94760	160931	f
Cruz das Barras	94761	160931	f
Pinheiros	94762	100914	f
Outeirinho	94763	30515	f
Paço	94764	30519	f
Ribeira	96901	30501	f
Estrada Nova	96902	460205	f
Quinta das Quebradas	96903	40810	f
Caminho Novo	96904	460206	f
Penha de França	96905	160931	f
Àguas Férreas	96906	160201	f
Aguilhão	96907	160201	f
Alentejo	96908	160201	f
Âncora	96909	160201	f
Areia	96910	160201	f
Aspra	96911	160201	f
Ausente	96912	160201	f
Baltazares	96913	160201	f
Bargiela	96914	160201	f
Barreiros	96915	160201	f
Boavista	96916	160201	f
Boqueiro	96917	160201	f
Borlido	96918	160201	f
Boucinhas	96919	160201	f
Calvário	96920	160201	f
Cardosas	96921	160201	f
Casa da Guarda da CP	96922	160201	f
Castro	96923	160201	f
Concheiro	96924	160201	f
Cruz da Areia	96925	160201	f
Cruzeiro	96926	160201	f
Cruzeiro da Aspra	96927	160201	f
Cruzeiro do Socorro	96928	160201	f
Desterro	96929	160201	f
Devesa	96930	160201	f
Enxaguada	96931	160201	f
Ervilhal	96932	160201	f
Fonte	96933	160201	f
Fonte do Castro	96934	160201	f
Fora	96935	160201	f
Gelfa	96936	160201	f
Igreja	96937	160201	f
Ilha	96938	160201	f
Lage	96939	160201	f
Laginhas	96940	160201	f
Loro	96941	160201	f
Lug. Âncora	96942	160201	f
Paço	96943	160201	f
Paço de Cima	96944	160201	f
Paranho	96945	160201	f
Pó Aspra	96946	160201	f
Ponte	96947	160201	f
Ponte de Abadim	96948	160201	f
Portela	96949	160201	f
Prado	96950	160201	f
Queijadinhas	96951	160201	f
Quelha	96952	160201	f
Quinta da Boavista	96953	160201	f
Quinta da Trindade	96954	160201	f
Quinta do Paço de Cima	96955	160201	f
Quintal	96956	160201	f
S. João	96957	160201	f
Salgueiral	96958	160201	f
Santo	96959	160201	f
São Sebastião	96960	160201	f
Socorro	96961	160201	f
Sta. Luzia	96962	160201	f
Trindade	96963	160201	f
Veiga	96964	160201	f
Viso	96965	160201	f
Portal de Marçal	96966	160931	f
Real	96967	30513	f
Rua Formosa	96968	470105	f
Ponte do Feixe	96969	30513	f
Rua Vista Alegre	96970	470108	f
Rua da Prainha	96971	460205	f
Rua de Santa Margarida	96972	460205	f
Canada dos Biscoitos	96973	460205	f
Rua do Morgado	96974	460205	f
Moinho Vedro	96975	30510	f
Vilar de Amargo	96976	90416	f
Bouça	96977	30510	f
Quinchousos	96979	30505	f
Portela	96981	30522	f
Fontão, Ponte de Lima	96982	160931	f
Cidade de Braga	96983	160931	f
Portas da Colegiada	96993	160931	f
Rua da Porta do Postigo	97008	160931	f
Na sua quinta da Meadela	97009	160931	f
Na sua quinta de Meixedo	97010	160931	f
Rua da Porta da Piedade	97011	160931	f
Sua quinta de Meixedo	97012	160931	f
Rua da Porta de S.João	98012	160931	f
Aldeia	98013	30872	f
Maçores	98014	40908	f
Rua do Pinheiro	98015	160735	f
Rua de Inácio Velho	98016	160931	f
Deão	98017	160931	f
Casa da Misericórdia	98018	160931	f
Rua da Carreira de Bento de Melo	98019	160931	f
Deocriste	98020	160931	f
Roda de Santo António	98021	160931	f
Quinta em Nogueira	98022	160931	f
Terreiro de Pedro de Melo	98023	160931	f
Rua de Paulo ?	98024	160931	f
Braga	98025	160931	f
Reino de Angola	98026	160931	f
Quelha de Inácio Velho	98027	160931	f
Arcos de Valdevez (São Pedro de Souto)	98028	160931	f
Na sua quinta de Anha	98029	160931	f
na sua quinta de Geraz	98030	160931	f
Geraz	98031	160931	f
Quelha de-Trás-da-Igreja	98032	160931	f
No Brasil	98033	160931	f
Freguesia de Távora do termo de Arcos	98034	160931	f
Na sua Quinta em Belinho , Esposende	98035	160931	f
Sernancelhe	98036	490378	f
Hospital Velho	98037	160931	f
Rua das Rosas	98038	160931	f
Cadeia de Viana	98039	160931	f
Arrabalde da Abelheira	98040	160931	f
Quelha dos Fornos da Porta da Vila	98041	160931	f
Mateus	98042	171415	f
Veiga	98043	30846	f
Barreira	98044	90908	f
Porto	98045	30838	f
Venda do Porto	98046	30838	f
Pensal	98047	30519	f
Defronte da Igreja	98048	160931	f
Prisão	98049	160931	f
Castelãos	98050	40508	f
Leira Longa	98051	160931	f
Ponte	98052	30519	f
Costa de Além	98053	30519	f
Toutinheira	98054	30519	f
Travessa de Santo António	98055	160931	f
Boeiro	98056	30834	f
Rua de Luís Jaime	98057	160931	f
Rua dos Currais	98058	160931	f
Rua dos Calheiros	98059	160931	f
Junto a Gaspar Malheiro	98060	160931	f
Casal da Marinha	98061	60509	f
Igreja de Nª Sª do Ó	98062	60509	f
Escada Sra. da Piedade	98063	160931	f
Rua do Sol	98064	110628	f
São João	98067	181915	f
VIla Franca	98068	160931	f
Coimbra	98069	160931	f
Rua dos Bagaços	98070	460205	f
Junto à Piedade	98071	160931	f
Junto do Forno	98072	160931	f
Ribeira Seca	98073	450105	f
Ribeirinha	98074	450105	f
Cruzal	98075	450105	f
São Tomé	98076	450105	f
Nas partes do Brasil	98077	160931	f
Cancela da extrema	98078	450105	f
Infernal	98079	450105	f
Bairro de São Pedro	98080	450105	f
Sete Fontes	98081	450105	f
Algar	98082	450105	f
Alqueves	98083	450105	f
Rua do Porto	98084	460205	f
Gortões	98085	450105	f
Ribeira das Lajes	98086	450105	f
Cancelinha	98087	450105	f
Corujal	98088	450105	f
R. da Bandeira, junto ao Carmo	98089	160931	f
Cala das Couves	98090	160931	f
Junto à Misericórdia desta vila.	98091	160931	f
Lisboa	98092	160931	f
Rua de Santo António	98093	160919	f
Rua Nova de Santo António	98094	160931	f
Casa da Roda - Trav. Misericórdia	98095	470108	f
Convento de Nª Sª da Glória	98096	470108	f
Ladeira da Paiva	98097	470108	f
Junto a Nossa Senhora da Piedade	98098	160931	f
Convento de São Francisco	98099	470108	f
Rua do Outeiro	98100	460204	f
Largo do Marquês de Ávila e Bolama	98101	470108	f
Beco da Rua do Espírito Santo	98102	160931	f
Canada das Dutras	98103	470108	f
Argaçosa	98104	160931	f
Hospital da Misericórdia	98105	30834	f
Abaixo da Porta da Ribeira	98106	160931	f
Praça da Hortaliça	98107	160931	f
Junto Igreja velha	98108	160919	f
Rua das Padeiras	98109	160919	f
R. da Gramática	98110	160919	f
Junto ao Carmo	98111	160931	f
Na sua quinta de Darque	98112	160931	f
Ponta do Topo	98113	450105	f
De trás da Igreja	98114	160931	f
Junto ao Açougue	98115	160919	f
Praça de Gaião	98116	160931	f
R. da Vitória	98117	160931	f
Baía - Brasil	98118	160931	f
Pedemonte	98119	130320	f
Cabreira	98120	130320	f
Bairro de São Pedro	98121	450105	f
Ribeira do Meio	98122	450105	f
Junto ao Açougue	98123	160931	f
Cancela da água	98124	450105	f
Ribeirinha do norte	98125	450105	f
Tamujal	98126	450105	f
Eirado do Postigo	98127	160931	f
R. Manuel da Rocha de Sá	98128	160931	f
Junto Mosteiro de Santana	98129	160931	f
Abaixo da Piedade	98130	160931	f
Além do Carmo	98131	160931	f
No mar	98132	160931	f
no mar	98133	160931	f
Frente Igreja Velha	98134	160931	f
Perto do Carmo	98135	160931	f
Rio de Janeiro	98136	160931	f
Junto do adro ?	98137	160931	f
Junto da Papanata	98140	160931	f
Fim da R. da Bandeira	98141	160931	f
R. da Bandeira, junto à porta principal do Carmo	98142	160931	f
R. da Bandeira junto à Leira Longa	98143	160931	f
Sobreira	98144	30512	f
Postigo, banda de baixo	98145	160931	f
Quelha dos Abraços	98146	160931	f
Igreija	98147	30514	f
Cardais	98148	30514	f
R. da Bandeira, junto João Sá Soutomaior	98149	160931	f
Costa	98150	30514	f
Tojal	98151	30514	f
Travessa de Baltasar Fagundes	98152	160931	f
Junto Convento dos Crúzios	98153	160931	f
Reino da Galiza	98154	160931	f
Defronte do Carmo	98155	160931	f
Detrás da igreja	98156	160931	f
Rua de Santiago	98157	160919	f
Fonte Nova	98160	450105	f
Chousa	98161	30514	f
Porrais	98162	40509	f
Peredo de Chacim	98163	40509	f
Rua das Couves até à Porta de S. Tiago	98164	160931	f
Travessa da Igreja Matriz	98165	160931	f
Vale	98166	30514	f
Sobre a Fajã	98167	450105	f
Outeiro	98168	30522	f
Pojalho	98169	30505	f
Largo do Santo Homem Bom	98170	160931	f
Lage	99344	30505	f
Na sua quinta de Refóios do Lima	98171	160931	f
Arada	98172	30514	f
Ribeira	98173	30513	f
Vinha	98174	30514	f
Castelo Branco	98175	50205	f
Reguengo	98176	30521	f
Poço	98177	30514	f
Pombal, lado do mar	98178	160931	f
Freguesia de Beiral do Lima	98179	160931	f
Porta do Forno	98180	160931	f
Ao Hospital velho	98181	160931	f
Quinta de Serreleis	98182	160931	f
Travessa do Alferes	98186	460206	f
Rua de Santa Margarida	98187	460206	f
Serapicos	98188	40247	f
Província do Alentejo	98189	160931	f
Olivença	98190	160931	f
Monte	98192	30511	f
Rua dos Mártires da Liberdade	98195	131204	f
Avenida Cândido dos Reis	98196	30863	f
Santiago	98197	160715	f
Freixo	98203	130219	f
Albergaria-a-Velha	98204	10201	f
Nossa Senhora da Conceição do Estreito	98205	490433	f
Lata - Mesão Frio	98206	30830	f
Adro	98207	30840	f
Além do Ribeiro	98208	30840	f
Bica de Chozende	98209	30840	f
Bouça de Requeixo	98210	30840	f
Cancela	98211	30840	f
Costeira	98212	30840	f
Covas	98213	30840	f
Fonte do Ferreiro	98214	30840	f
Gemunde	98215	30840	f
Germil de Baixo	98216	30840	f
Monte do Outeiro	98217	30840	f
Peça	98218	30840	f
Pedrais	98219	30840	f
Pego Negro	98220	30840	f
Pena Grande	98221	30840	f
Riba de Ave	98222	30840	f
Souto de Cima	98223	30840	f
Talho	98224	30840	f
Venda	98225	30840	f
Vila Fria (Viana do Castelo)	98226	160931	f
Vila de Caminha	98227	160931	f
Rua de Baltasar Fagundes	98228	160931	f
À Porta da Ribeira	98229	160931	f
REgo	98230	30514	f
Rego	98231	30514	f
Cimo de Vila	98232	30514	f
Valado	98233	30516	f
à Porta de Santiago	98234	160931	f
Cadeia de Lisboa	98235	160931	f
Detrás da Colegiada	98236	160931	f
Travessa do Robim	98237	160931	f
Monte dos Barretos	98238	121002	f
Rua de Reilho	98239	30863	f
Canada de São Bartolomeu	98240	450101	f
Travessa de Martim Velho	98241	160931	f
Antiga Rua de Manuel Ribeiro	98242	160931	f
Largo dos Quartéis (SM)	98243	30834	f
Rua dos Açougues	98244	160931	f
São Lourenço de Rio Cabrão	98245	160931	f
Travessa de Vasco Gomes	98246	160931	f
Na sua quinta de Vila de Punhe	98247	160931	f
Ribeira de São Pedro	98248	450105	f
Rua da Praça Velha	98249	160931	f
Rua do Mistério	98250	460205	f
Rua de cima	98251	460205	f
Rua do Anjinho	98252	160931	f
Rua do Anjinho	98253	160919	f
Abaixo dos Manjovos	98254	160919	f
Nogueiredo	98255	30511	f
Alvarães	98256	160919	f
Chão Frio	98257	470110	f
Matriz	98258	160919	f
Rua dos Rubins	98265	160931	f
Terreiro da Carreira	98266	160931	f
Rua dos Crúzios	98267	160931	f
Praça de São João	98268	160931	f
Rua do Marquês	98269	160931	f
Travessa	98270	30513	f
Padim	98276	30502	f
Abelheiro	98278	30506	f
Em casa de Jerónima Bezerra	98279	160931	f
Ruas das Laranjeiras	98280	160919	f
Herdade da Nogueira	98283	20105	f
Herdade do Pinheiro	98284	20105	f
Sovereira	98285	20105	f
Salga	98286	420202	f
Ocidental	99287	182323	f
Junto ao Castelo	99288	160919	f
Hospedarias da Capela do Senhor da Ladeira	99289	470108	f
Hospedarias da Capela do Senhor da Ladeira	99290	60102	f
Basto	99294	160931	f
Rua das Padeiras	99295	160931	f
São Miguel de Vila Franca	99296	160931	f
Na Índia	99297	160931	f
Sua quinta de Santa Marinha	99298	160931	f
Defronte da Igreja Velha	99300	160931	f
Cabeço Chão	99301	460204	f
Na sua quinta	99302	160931	f
a Manjovos	99303	160931	f
Porta de Santiago	99306	160919	f
Santo Andou	99307	30502	f
Travessa	99308	30511	f
Penedono	99309	490367	f
Casa da Ribeira	99310	430207	f
Nossa Senhora da Assunção	99311	20301	f
Balado	99312	30517	f
Terreiro de São Bento	99313	160931	f
Igreja Matriz, Colegiada	99314	160931	f
São Salvador do Campo	99315	30217	f
São Salvador do Campo, Barcelos	99316	160931	f
Levada	99321	30502	f
Soalheira	99322	30511	f
Travessa da Carreira	99323	160931	f
Colegiada	99324	160931	f
Freguesia de Santa Marta	99326	160931	f
São Miguel de Perre	99327	160931	f
Assento	99328	30518	f
Rua Nova	99329	30514	f
Combro	99330	30514	f
Estremadouro	99331	30514	f
Freguesia de São José, Lisboa	99334	160931	f
Freguesia de São José, Lisboa	99335	110645	f
Aguieras	99336	40703	f
Rua do Cano	99337	470108	f
Meadela (Santa Cristina)	99338	160931	f
Igreja Velha do Salvador	99339	160931	f
Vila de Punhe	99340	160931	f
Regadinhas	99341	30506	f
São Miguel de Alvarães	99342	160931	f
São  Miguel	99343	160902	f
Vitorino das Donas, Ponte do Lima	99345	160931	f
Facha (Santo Estêvão), Ponte de Lima	99346	160931	f
Vila Franca, Viana do Castelo	99347	160931	f
Vila de Esposende	99348	160931	f
Rua do Souto, Porto	99349	160931	f
Freguesia de Santa Cruz, Ponte de Lima	99350	160931	f
Freguesia de Álvora (Santa Maria), Arcos de Aldevez	99351	160931	f
Arnozelo	99352	91411	f
Vila de Ponte de Lima	99353	160931	f
Igreja Matriz	99354	160931	f
Calheiros, Ponte de Lima	99355	160931	f
Santa Eufémia	99356	160713	f
Santiago de Bembibre, bispado de Tui	99357	160931	f
Touguinhó, Vila do Conde, Porto	99358	160931	f
Portela (Santo André)	99359	160127	f
Torre	99360	30520	f
Sande, Marco de Canaveses	99361	160931	f
Sande, Marco de Canaveses, Porto	99362	130718	f
Monção	99363	160931	f
Cossourado, Paredes de Coura	99364	160931	f
Cruz de Pedra	99365	30514	f
Fontão	99366	30512	f
Banho (Santa Eulália, Marco de Canaveses	99367	160931	f
Banho (Santa Eulália) Marco de Canaveses	99368	130704	f
Banho (Santa Elália), Marco de Canaveses	99369	160931	f
Banho (Santa Eulália), Marco de Canaveses	99370	130704	f
Banho e Carvalhosa, Marco de Canaveses	99371	130704	f
Banho (Santa Eulália), Marco de Canaveses	99372	160931	f
Oleiros, Ponte de Barca	99373	160614	f
Oleiros, Ponte da Barca	99374	160614	f
Oleiros, Ponte da Barca	99375	160931	f
Vitória, São Nicolau, Sé	99376	490291	f
Porto,Vitória, São Nicolau, Sé	99377	490291	f
Vitória, São Nicolau, Sé	99378	131215	f
Santa Maria do Vale	99379	10930	f
Santa Maria do Vale,	99380	10930	f
Varges	99381	170707	f
Vieiro	99382	41005	f
Penajóia, Lamego	99383	180516	f
Refóios, Ponte de Lima	99384	160737	f
Serreleis	99385	160931	f
Moreira do Lima (São Julião)	99386	160732	f
Belinho (São Pedro Félix)	99387	30603	f
Belinho (São Pedro Félix), Esposende	99388	30603	f
Rua dos Aloques	99389	160931	f
Sé, Leiria	99390	100912	f
Sobreira	99391	170701	f
Novais	99392	30516	f
Banda do Norte	99393	450105	f
Boucelha	99394	30522	f
Ribeira Seca	99395	480105	f
Rua da Vilarinha	99396	160931	f
Meixedo	99397	160931	f
Vila de Punhe (Santab Eulália	99398	160931	f
Vila de Punhe (Santa Eulália)	99399	160931	f
Vila Fria (São Martinho)	99400	160931	f
Rua do Rubim	99401	160919	f
Mogo	99402	40303	f
São Miguel do Couto, Gondufe	99403	160728	f
Lanheses	99404	160931	f
Lanhelas	99405	160211	f
São Cristóvão de Nogueira, Cinfães	99406	180413	f
Rua Nova,	99407	160735	f
Arcos (São Pedro)	99408	160703	f
Castanheira	99409	90712	f
Moreira de Geraz do Lima	99410	160931	f
Fráguas	99411	182202	f
Fráguas, Vila Nova de Paiva	99412	182202	f
Bravães, Ponte da Barca	99413	160603	f
Convento de São Bento	99414	160931	f
Freguesia de Rubiães,	99415	160520	f
Carvoeiro (Santa Maria)	100415	160931	f
São Sebastião	100416	30863	f
Insalde	100417	160511	f
Santa Marinha	100418	131716	f
Gondufe (Couto)	100419	160728	f
Feitos (São Tiago)	100420	30232	f
Britelo (São Pedro)	100421	30504	f
São Pedro	100422	171424	f
Forjães (Santa Maria)	100423	30608	f
Vila Boa do Bispo	100424	130730	f
Vila Boa do Bispo (Santa Maria)	100425	130730	f
Capela de família na Rua de Santa Ana	100426	160931	f
Brunheda	101424	40313	f
São Brás	101425	40305	f
Areosa, Lugar de São Mamede	101426	160931	f
Quinta da Felgueira	101427	40313	f
Beiral do Lima (Santa Maria)	101428	160707	f
Moreira de Geraz do Lima (Santa Marinha)	101429	160931	f
Eido	101430	30506	f
Soutelo	101431	30513	f
Louredo	101432	31109	f
Lavandeira	101433	30516	f
Postigo	101437	160919	f
Campelos	101438	40308	f
Santrilha	101439	40313	f
Conservatória	101440	40916	f
São Lourenço	101441	40314	f
Travessa de São Sebastião	101442	160931	f
Junto fonte João Jácome	101443	160919	f
Casa de Henrique Lamoner	101444	160919	f
Calheta de Nesquim	101445	460103	f
Quintães	101446	30840	f
Santa Casa da Misericórdia	101447	470108	f
Portela Nova	101448	160919	f
Sao Martinho do Peso	101449	40817	f
Igreja Velha	101450	160931	f
Balasar (Santa Eulália)	101451	131305	f
Zedes	101452	40301	f
R. S. Domingos junto ao convento	101453	160919	f
Capela de S. João da Abelheira	101454	160931	f
Aldeia	101455	30514	f
Torre	101460	30511	f
Paço de Cima	101468	30845	f
Ponte de Lima	101473	160735	f
Amonde (Santa Maria)	101474	160903	f
Capela da Fortaleza de Viana	101475	160931	f
Tregosa (Santa Maria)	101476	30281	f
Pedregais (São Salvador)	101477	31333	f
São Pedro	101478	182007	f
Santo Amaro	101479	40312	f
São Gonçalo	101480	40313	f
Santa Maria	101481	160930	f
Geraz do Lima (Santa Maria)	101482	160930	f
Vila Franca	101483	160935	f
Carvalhais	101484	40711	f
Lavradas (São Miguel)	101485	160611	f
Campo da Feira	101487	160919	f
Eirô	101489	30506	f
Monção (Santa Maria dos Anjos)	101490	160417	f
Ázere (São Cosme e São Damião)	101491	160104	f
Rua Nova	101492	490338	f
Aborim	101493	30202	f
Santo Ildefonso	101494	131212	f
Rua Barnabé de Melo	101495	160919	f
R. Luís Jácome	101496	160919	f
Fragoso (São Pedro)	101497	30235	f
R. do Marqês, junto ao Arco	101509	160919	f
Aboim das Choças (Santo Estêvão)	101510	160101	f
Vitorino das Donas	101511	160750	f
Viana do Castelo	101512	490340	f
Alijo	101513	40311	f
Vila Nova de Muía	101515	160625	f
Carregosa	101517	11301	f
Alvarães	101518	160931	f
Santa Marta	101519	160931	f
Codeçais	101520	40312	f
Areosa	101521	160931	f
Igreja Nossa Senhora do Socorro	101522	470113	f
Santa Marinha de Anais	101523	160701	f
Santo António	101524	30514	f
Ourém	101525	142111	f
Saião	101526	40911	f
Coleja	101527	40316	f
Correlhã (São Tomé)	101528	160716	f
Gouveia	101530	91011	f
Silva (São Julião)	101531	160813	f
São Pedro Fins	101532	30276	f
Santa Leocádia	101533	160929	f
Campos (São João)	101534	161001	f
São Miguel de Perre	101535	160926	f
Rua da Alfândega	101536	160931	f
Santa Maria de Geraz do Lima	101537	160931	f
Frente a S. Clara	101538	160919	f
Nossa Senhora da Vila	101539	490335	f
Ganfei	101540	160808	f
Anha	101541	160931	f
Pias (São Torcato)	101543	30865	f
Formariz	101544	160509	f
Mortágua	101545	180806	f
Romarigães (São Tiago)	101546	160519	f
Lobrigos (São João)	101547	171108	f
Calheiros (Santa Eufémia)	101549	160713	f
Facha (Santo Estêvão)	101551	160718	f
Vila Nova de Cerveira (Sâo Cipriano)	101552	490341	f
Rua de Santa Bárbara	101554	30834	f
Durrães (S.Lourenço)	101555	30229	f
Portela de Viana	101556	160931	f
Alcofra	101557	182401	f
Quarteis	101558	30834	f
Granel da Misericórdia	101559	470108	f
Mogada	101560	30849	f
Alcofra (Meã)	101561	182401	f
Cadeia da vila da Horta	101562	470108	f
Ribeira (S. João)	101566	160739	f
Parada de Gatim (Salvador)	101567	31331	f
Fontão (Santiago)	101568	160721	f
Carvalho	101569	131711	f
Areosa (Santa Maria da Vinha)	101570	160931	f
Mazarefes (S. Nicolau)	101571	160931	f
Bertiandos	101572	160708	f
Prozelo (Santa Marinha)	101573	160128	f
Arcozelo (Santa Marinha)	101574	160704	f
São João do Campo	101575	60320	f
Vilar da Veiga (Santo António)	101576	31017	f
Sampriz	101577	160619	f
Azias	101578	160601	f
Lara (Santa Eulália)	101579	160410	f
Feitosa	101580	160719	f
Trav. do Penedo da R. da Lama	101584	160919	f
Alvelos	101586	30208	f
Gemieira	101587	160727	f
Cambeses	101588	160407	f
Travessa do Salgueiro	101590	160931	f
Salvador	101591	160134	f
Rua S. Domingos	101592	160919	f
Cruz de Pedra	101594	30324	f
Fontoura (São Miguel)	101597	160805	f
Sopo	101598	161013	f
Junto ao Arco da Ribeira	101599	160919	f
R. das Correias	101601	160919	f
Tregosa (S. Pedro)	101602	30281	f
Refóios (S. Francisco)	101603	160737	f
Amonde (Santa Maria)	101604	160931	f
Cardielos	101605	160931	f
Frente à Vedoria	101606	160919	f
São Roque	101607	160919	f
Carvoeiro	101608	160919	f
R. S. Sebastião, junto Chafariz	101609	160919	f
Em Casa de Maria Velho	101610	160919	f
Santa Eufémia	101612	30842	f
Santa Eufémia, luga do Forno	101613	30842	f
São Cipriano	101614	30869	f
Calvelo, São Pedro	101615	160714	f
Rua da Caldeiroa	101616	30847	f
Rua Barnabé de Melo	101617	160931	f
Assento	101618	130308	f
Hospital Militar da SCMHorta	101620	470108	f
Valpiedade	101621	31230	f
Tàvora (Santa Maria)	101622	160137	f
Lugar da Estrada	101623	30849	f
Quinta da Veiga	101624	30804	f
Sobre Costa	101625	30812	f
Santa Cruz	101626	160743	f
Ferreiros (Santa Maria)	101627	30314	f
Borba de Montanha (Santa Maria)	101628	30503	f
Gualtar (São Miguel)	101629	30319	f
Geraz do Lima (Santa Leocádia)	101630	160931	f
Casa da Roda de Penafiel	101631	490290	f
Eido	101633	30511	f
Tartulhal	101634	30511	f
Igreija	101635	30511	f
Granja	101636	30801	f
Lagar	101637	30511	f
Fão	101638	30606	f
Residência	101639	30511	f
Outeiro (S: Miguel)	101640	160931	f
Outeiro (S. Martinho)	101641	160931	f
R. S. Catarina, princípio R. do Loureiro	101642	160919	f
Bacêlo	101643	30511	f
Almeida	101644	30511	f
Defronte Nossa Senhora da Piedade	101645	160931	f
Casais	101646	30518	f
Vila Mou	101647	160931	f
Fim da R. do Loureiro	101648	160919	f
Vila Franca das Naves	101651	91327	f
Mouquim	101652	31226	f
tTravessa de Barnabé de Melo	101653	160919	f
Travessa de Barnabé de Melo	101654	160919	f
Cerdal	101655	160803	f
Vilar do Paraíso	101656	131724	f
Rua e Travessa de Roque de Barros	101657	160931	f
Torrão	102655	130725	f
Vilar Formoso	102657	90229	f
Mozelos	102660	160513	f
Lugar das Maias	102661	30812	f
Rio Cabrão	102665	160129	f
Igreja Velha de São Tomé	102669	30808	f
Quintã	102670	30808	f
Canto	102671	30808	f
Souto	102672	30808	f
Além	102673	30808	f
Cucujães	102674	11319	f
Carregal	102675	30808	f
Lama	102676	30808	f
Mujães	102677	160931	f
Bemposta	102678	30808	f
Lagartal	102679	30808	f
Campos	102683	30808	f
Assento	102684	30808	f
Melre	102685	30808	f
De frone Convento S. Domingos	102686	160919	f
Colegiada	102687	490142	f
Caminha (Matriz)	102688	160931	f
Aguiar	102689	30204	f
Aveloso	102693	90901	f
Bouçós	102694	30808	f
Barcelinhos	102695	30213	f
Prado	102696	31342	f
São João	102697	490337	f
Rua dos Cónegos	102702	30352	f
Prado	102703	31350	f
Boavista	102704	30518	f
Casa dos Pobres SCMHorta	102705	470108	f
Enfermaria dos inválidos da SCMH	102707	470108	f
Lufrei	102708	130121	f
Areosa, Lugar de Povoença	102709	160931	f
Freiriz	102710	31316	f
Sé	102711	30352	f
Santa Maria Maior	102712	160931	f
Seara	102713	160745	f
Anhões	102714	160402	f
Cabanelas	102715	30505	f
Igreja	102716	30808	f
Subrego	102717	30808	f
Rua Nova	102718	30352	f
Canhoso ,lugar da Cova	102719	50331	f
Fornelos	102720	160722	f
Martim	102721	30247	f
Ponte (Corvite)	102722	30838	f
Em casa de Francisco Gonçalves, ferreiro	102723	160919	f
Roçomarães	102724	30849	f
Rua de São Domingos	102725	160919	f
Loivo	102726	161007	f
Carreço	102727	160931	f
Carreço	102728	160908	f
Bouça	102729	30808	f
Ladeira do barro	102732	460101	f
Azemel	102734	30808	f
Casa nova	102735	30808	f
Coura	102736	160505	f
Freguesia de Monserrate	102737	160919	f
Vidigueira	102738	490134	f
Freixieiro de Soutelo	102739	160914	f
Lugar do muro	102740	30806	f
Casal de Currelos	102741	30855	f
Lameira	102742	30808	f
Rebata	102743	30808	f
Reboreda	102744	30842	f
Asilo de mendicidade	102745	470108	f
Casal do Outeiro	102746	30855	f
Casa da Residência	102747	30506	f
Lugar do Casal	102748	160143	f
Rua de Francisco Enes Bravo	102749	160919	f
Corvite	102750	490142	f
Rua dos Chãos de Cima	102751	30351	f
Rua da Régua	102752	30351	f
Lanheses	102753	160915	f
Boucinha	102754	30808	f
Penelas	102755	30504	f
Miragaia	102756	131208	f
Alvarães	102757	160902	f
Penelas	102758	30851	f
Travanca	102759	30855	f
Poças	102760	30808	f
Vila Chã (São João)	102761	30615	f
Vinha Nova	102762	30871	f
Brtelo (Lugar de Freixieiro)	102763	30504	f
Britelo (Lugar de Freixieiro)	102764	30504	f
Santiago	102765	30511	f
Refóios do Lima	102769	160737	f
Cidade do Porto	102770	490423	f
Boavista	102772	30817	f
Esposende	102773	30605	f
Venda do Barco #	102777	30808	f
Valas	102778	30842	f
Carcavelos	102779	30513	f
Reborim	102780	160909	f
Sobradelo	102781	160738	f
Palos	102782	490139	f
São Martinho	102783	30202	f
Gondelim	102784	160803	f
Granja	102785	30511	f
Penedo	102786	30808	f
Lamaçães	102787	30321	f
Tarrio	102789	30858	f
Lugar de Terroso	102790	30613	f
Laundos	102791	131308	f
Rua do Covelo	102792	130110	f
Bairro da Assunção	102793	490253	f
Azeitão	102794	151204	f
Bemposta	102795	490416	f
Lugar de Encima de Vila	102796	30915	f
Em Cima de Vila	102797	30915	f
S. Sebastião de Touro	102798	490360	f
Outeiro	102799	160116	f
Casal de Torre	102800	30806	f
Vila Chã	102801	30615	f
São Salvador	102803	160808	f
São Mamede	102804	130105	f
São Pedro	102805	160149	f
Adro da igreja de Monserrate	102806	160919	f
Couto	102807	160737	f
S. Maria da Porta	102808	490334	f
S. M. dos Anjos	102809	490339	f
Santiago	102810	160108	f
Santiago	102811	490215	f
Lugar de Paradela da Veiga	102812	170333	f
S. Cipriano	102814	490341	f
Silva (São Julião)	102817	160811	f
Outeiro	102819	160611	f
Outeiro	102821	160704	f
Mentrestido	102823	161009	f
S. Sebastião	102825	490425	f
S. Sebastião	102826	490330	f
Sé	102827	490291	f
Vila de Punhe	102828	160938	f
Canada do Arrasto	102829	460106	f
Pedral	102830	30846	f
Sequaz	102831	31221	f
Palhares	102832	490425	f
Palhares	102833	490330	f
Cristelo Côvo (Segadães)	102834	160804	f
Canada do Almance	102836	460106	f
Da canada de Lázaro Pereira à do alferes José Pereira	102837	460106	f
Pinheiro	102840	160426	f
Canada de Lázaro Pereira	102841	460106	f
Da Canada de Perpétua de Sousa à de Lázaro Pereira	102842	460106	f
Lureira	102843	490142	f
Vale de Afonso	102845	490188	f
Santo Estevão	102846	490339	f
Santa Cruz	102847	60504	f
Igreja Velha	102848	160207	f
Galegos- Prado	102849	490136	f
Galegos	102850	30214	f
Bouças	102851	160717	f
Lugar de Ventoso	102852	160929	f
S. Sebastião	102853	160911	f
S. Salvador	102855	160708	f
Santiago	102856	160907	f
S. Lourenço	102857	160129	f
Verdoejo	102858	160810	f
Canada do Almanse à canada de Francisca	102860	460106	f
Da Canada de Santo António até ao fim da freguesia	102861	460106	f
Bufo	102863	30829	f
Vila Chã	102864	30836	f
Pereiro	102866	160730	f
Monte do Bairro	102867	30818	f
Souto de Vendas	102868	30818	f
Assento	102869	30846	f
Bugalhós	102870	30829	f
Em casa de Perpétua Pereira	102871	160919	f
Assento	102872	30818	f
Roma	102873	30836	f
Caria	102874	30855	f
Igreja de Sam Paio	102877	160501	f
Fojo	102878	10609	f
Carvalhos	102879	30837	f
Currelos	102880	30855	f
Casal de Campos	102881	30808	f
Herdade	102884	30864	f
Candoso	102885	30857	f
R. dos Palames	102886	30351	f
Santa Marinha	102887	490338	f
Murinho	102888	30806	f
Casal do Outeiro	102889	30806	f
Assento	102890	30858	f
Reboreda	102891	30808	f
Casal do Outeiro	102892	30842	f
S. Cristóvão de Muro	102895	490285	f
São Cristóvão	102896	131808	f
S. Eulália	102898	31342	f
S. Martinho do Lago	102899	160738	f
Venda	102900	130521	f
Barreiro	102901	470110	f
Colegiada - Matriz	102902	160931	f
Carvalho	102903	30817	f
Quintela	102904	30926	f
Igreja Velha	102905	30803	f
Teixeira	102906	30857	f
Rua de Santa Maria	102907	30804	f
Colegiada-Matriz	102908	160931	f
S. Maria e S. Sebastião	102909	490209	f
Santa Maria dos Anjos	102911	490335	f
S. Miguel	102912	160506	f
Foz	102913	30511	f
Casal da Roda	102915	30842	f
Taipa	102916	30837	f
Filgueira	102919	10415	f
Sardoal	102920	30511	f
casal do souto	102921	30806	f
Casal da Ruela	102922	30842	f
Convento de Santa Ana	102923	160931	f
São Romão	102924	130615	f
Fonte	102925	30331	f
Ceivães	102926	160432	f
Santo André	102927	170310	f
São Miguel o Anjo	102928	490411	f
São Miguel o Anjo	102929	490106	f
São Julião	102930	490254	f
Boavista	102931	30521	f
Sammamede	102935	160508	f
Ponte	102936	30856	f
Entre as águas	102937	30827	f
Herdade	102938	30836	f
Agouro	102939	30854	f
Rua da Ordem	102940	130133	f
Areia funda	102942	460204	f
Montelongo	102943	30723	f
Galhufe	102944	31404	f
Teixugueiras	102945	31403	f
Feitilha	102947	30853	f
Corvo	102948	31230	f
Paço	102949	30858	f
Cais do Mourato	102950	460201	f
Porta de Sâo Crispim	102951	160931	f
Toiande	102952	30502	f
São Miguel	102953	160926	f
Rua de São João	102954	160931	f
Lugar de Aldeia Velha	102955	130134	f
Lugar do Torrão	102956	160136	f
Convento S. Bento	102957	160931	f
S. Mamede	102958	160745	f
Santa Eulália	102959	170620	f
Lugar do Torrão	102960	160137	f
Lugar da Igreja	102961	30503	f
S. Maria	102962	160908	f
S.Salvador	102963	31309	f
Santo André	102964	160117	f
Matriz	102965	110503	f
Cuchiarre	102966	30855	f
Couto	102967	30806	f
Cabo	102968	30855	f
S. Sebastião de Passos	102969	490139	f
Azenha do Rio	102970	30808	f
S.Pedro	102971	160912	f
Caminho de Cima	102972	460201	f
Portela	102973	131432	f
Loje	102974	30815	f
Travassos	102975	130307	f
S. Martinho	102976	160914	f
Touguinho	102977	490136	f
Caçarilha	102978	30404	f
Barge	102979	30857	f
Pereiras	102980	30414	f
Aljube	102981	490423	f
Assento	102982	30855	f
Mondino	102983	30817	f
Catains	102984	131722	f
Velas	102985	30805	f
Rua de Santa Ana	102987	460304	f
Ribeira	102988	30858	f
R. do Anjinho	102989	160919	f
R. da Hospedaria	102990	160919	f
Rua do Salgueiro	102991	160931	f
R. do Mirante	102992	160919	f
Pontilhão	102993	30838	f
Rua de Soalhães	102994	30239	f
Vila Velha	102995	30864	f
Soutelo	102996	131430	f
Pedreira	102997	30511	f
Casa da Aldeia - Crespos	102998	30504	f
Frente Igreja Monserrate	102999	160919	f
Sé Catedral	103000	490291	f
Igreja S. Miguel do Castelo	103002	30834	f
Lage do Pinheiro	103003	30837	f
Mosteiro do Souto	103004	30862	f
Lugar do Monte	103005	30504	f
Recolhimento das Mercês	103006	30834	f
Vale	103007	30866	f
Santo Amaro	103008	30846	f
Prozelo, Arcos de Valdevez	103009	160931	f
Porta Marçal	103010	160931	f
Cruzeiro	103011	130328	f
Agrelo	103012	131426	f
Aldeias	103013	31403	f
Valinhas	103014	130328	f
Cortinhas	103015	30865	f
Monte	103016	130302	f
Batoca	103017	30857	f
Vinha	103018	130323	f
R Nova de Santana	103020	160919	f
Barroco	103021	130332	f
Oleiros	103022	30833	f
Bardial	103023	30803	f
Igreja de S.João de Ponte	103024	30838	f
Tourada	103025	30809	f
Carreira chã	103026	31401	f
Lameira	103028	130511	f
Silvares	103029	30831	f
Taipa de baixo	103030	30808	f
Ruqueixo	103038	30842	f
Assento	103039	130307	f
Couta	103040	30821	f
Lugar da Igreja	103041	181009	f
Corredoura	103042	30865	f
Monte	103043	31406	f
Valido	103044	30803	f
Seilho	103046	30802	f
Contiasto	103047	30803	f
Igreja Paroquial	103048	31240	f
Cal de Cima	103049	31246	f
Monte	103050	31240	f
Crasto	103051	31246	f
Fojo	103052	31404	f
Soalhães	103053	30518	f
Fontainhas	103054	130521	f
Poredo	103055	30803	f
Casal	103056	31405	f
Pena Redonda	103057	30864	f
Lagido de Baixo	103058	460201	f
Santa Cruz	103059	60317	f
Rua do Vilarinho	103060	160931	f
Estrada	103061	30855	f
Paço do Sardual	103062	31406	f
Pé do Monte	103063	31404	f
Lages	103064	130511	f
Oleiros	103065	30867	f
Castanheira	103066	30821	f
Travessa de Santiago	103068	160919	f
Pé de Ponte	103070	30414	f
Balboeiro	103071	30851	f
Quintães	103072	31404	f
Monte Negro	103073	30865	f
Tumada	103074	30865	f
Formigosa	103075	31402	f
Rua da Lama	103076	160919	f
Largo da Igreja	103077	460201	f
Taipas de cima	103078	30808	f
Rua de Luís Jácome	103079	160931	f
Lugar de Montedor	103080	160908	f
Pedras	103081	30858	f
Burguete da Abelheira	103084	160931	f
Lugar da Abelheira	103085	160931	f
Asilo da SCMHorta	103086	470108	f
Carreiro da Leira	103087	160931	f
Santa Martinha do Lima	103088	160931	f
Lugar do Adro	103089	490225	f
Couto de Cima	103091	30806	f
Aldeia do Souto	103092	30808	f
Aldeia da Lameira	103093	30808	f
Casal de Frades	103094	30807	f
Rua do Penedo	103097	160919	f
Facha	103098	30853	f
Fundo	103099	130521	f
Póvoa	103100	130303	f
Montinho	103101	30836	f
Casal	103102	30832	f
Lugar de São Mamede	103103	160905	f
Bouça	103104	30856	f
Godim	103105	130307	f
Rua dos Mercadores	103106	131214	f
Salgueiros	103107	170343	f
Mosteiro de Bom Jesus	103108	130521	f
Vilar de Atão	103109	30865	f
Lugar da Igreja	103110	30806	f
Caminho para o Salão	103111	470103	f
Faia	103112	30521	f
Leirão	103113	130328	f
Bom Jesus	103114	130521	f
Barreiro	103115	30854	f
Couto de Tibães	103116	30347	f
Igreja Paroquial	103117	30837	f
Defronte da cadeia	103118	160931	f
Lajes	103120	30823	f
Ponte	103122	30821	f
Rua das Rosas	103123	160919	f
Salvador	103124	490135	f
Salvador	103125	30101	f
Eiteiro de Basto	103126	30404	f
Penegache	103127	30835	f
Estrada	103128	30821	f
Assento	103129	30863	f
Casa Nova	103130	30857	f
Arranhadoura	103131	40402	f
Samarim	103132	130306	f
Faburno	103133	30858	f
Monte	103134	30823	f
Visita	103135	30849	f
Paredes	103136	30927	f
Igreja	103137	30927	f
Condado	103138	31225	f
Cacheina	103139	30274	f
Lugar do Canadelo	103140	160732	f
Casa do Bom Viver	103141	31405	f
Casa de Junfe	103142	30834	f
Casa de Junfe	103143	130328	f
Escalheiras	103144	30841	f
Fonte	103145	130321	f
Darife?	103147	30809	f
Várzia	103148	30503	f
Prelada	103149	30730	f
Lugar de Ponte	103150	30907	f
Gandarela	103151	30817	f
Carvalhas do Campo da Feira	103152	30863	f
Agrelo	103153	30844	f
Casa do Paço	103154	30927	f
Ponte	103155	31234	f
Quintais de cima	103156	30848	f
Casa da Pedra	103157	30927	f
Moinhos da Ribeirinha	103158	30815	f
Alminha	103159	30862	f
Porto	103160	101602	f
Cucanhos	103161	30414	f
Gardamil	103162	30838	f
Figueiredo	103163	31405	f
Carvalhas	103164	30865	f
Boucinha	103165	30829	f
Casal	103166	130103	f
Souto	103167	31404	f
Calhau	103168	470107	f
Boa Vista	103170	30850	f
Samoça	103171	131419	f
Furão	103172	91010	f
Portas	103174	130332	f
Albergue noturno	103177	470108	f
Pousada	103178	31219	f
Casal	103179	30821	f
Cartemil	103180	131419	f
Junto a santo Homem <Bom	103181	160919	f
Junto a Santo Homem Bom	103182	160919	f
Rua dos Ramos	103183	30342	f
Costinha	103184	30517	f
Lomba do Pilar	103185	470107	f
Assento de baixo	103186	30865	f
Herdade	103187	30851	f
Tintoreiros	103188	131009	f
Cachada	103190	30865	f
Taipa	103191	30803	f
Eiteiro	103192	131430	f
Torre	103194	130330	f
Cova	103195	30866	f
Arco	103196	30867	f
Geia	103197	30805	f
Casas Novas	103198	30835	f
Souto de baixo	103199	30865	f
Daveza	103200	31407	f
Souto da cruz	103201	31405	f
Rua de Altamira	103202	160931	f
Calvos	103203	30866	f
Castro	103204	30854	f
Pena	103205	30850	f
Torrão	103206	130523	f
São Faustino	103207	30869	f
Casas Novas	103208	30839	f
Bouça	103209	130315	f
Arosa	103210	30520	f
Moinhos	103211	131432	f
Ponte Domingos Terne	103212	30907	f
Quatro Irmãos	103213	30858	f
Companhia de Cima	103214	460106	f
Barreiro	103215	30805	f
Lareira	103216	30823	f
Rua da Igreja	103217	460106	f
Veiga	103218	30511	f
Rua do Salvador	103219	160931	f
Ribeira de Soaz	104218	490145	f
Preira	104219	160721	f
Barreiro	104220	30826	f
Travessa da Ribeira	104221	160919	f
Paredes	104222	30909	f
São Paulo	104223	31402	f
Quintã	104224	131405	f
Defronte da Cadeia	104225	160931	f
Porto	104226	460101	f
Augueiro	105226	131432	f
Arada	105229	130315	f
Cancela	105230	130520	f
Pereira	105232	160914	f
Panelas	105233	31247	f
Sarça	105234	30819	f
Travessa da Rua de São Sebastião	105235	160919	f
Lugar do Fardel	105236	30837	f
Outeiro	105237	30837	f
lugar da cerca	105238	30863	f
Lugar da Cerca	105239	30837	f
Detrás da Igreja Matriz	105240	160931	f
Coutada	105241	30867	f
Rocha de cima	105242	30858	f
Torre	105243	30515	f
Estiada Nova	105244	30804	f
Quintães	105245	31405	f
Roda	105246	30860	f
Veira	105247	30832	f
Serquelo	105248	30502	f
Pontudo	105250	30850	f
Terra do pão	105252	430118	f
Cancela	105253	131426	f
Samoça	105254	131424	f
Serviço	105255	130517	f
Casa do Telhado	105256	170501	f
Barroca	105257	30851	f
Quinta	105258	30837	f
Telhado	105259	31219	f
Velas	105260	30804	f
Cartas	105261	130317	f
Tarrio	105262	30864	f
Senhora da Graça	105263	30840	f
Lugar do bairro	105264	30832	f
Valinho	105265	30803	f
Penedo	105266	30319	f
Abeleira	105267	31219	f
Pombinhos	105268	131430	f
Lameira	105269	31403	f
Segade	105271	30865	f
Devesa	105272	30821	f
Gémeos	105273	30864	f
Casa da Vinha	105274	30504	f
Ribeiro	105275	30515	f
Hospital de S. Paio	105276	30860	f
Casa de Travaços	105277	30502	f
Carreira	105278	30515	f
Ribeirinho	105279	30510	f
Rua Duque de Bragança	105280	110620	f
Telheira	105282	130102	f
Mato	105283	31403	f
Pombal	105284	130306	f
fontelos	105285	30515	f
Fontelos	105286	30515	f
Travessa dos Manjovos	105288	160931	f
Prainha do Galeão	105289	460205	f
Hospital provisório da SCMH	105290	470108	f
Santo António	105291	30808	f
Quinta	105292	30513	f
a Santo Bom Homem	105293	160931	f
Boucinha	105294	30929	f
Mãe de Deus	105295	420314	f
à Picota	105296	160931	f
Campo de Santana	105297	160931	f
Bougado	105298	131424	f
Cabo	105299	31205	f
Costinha	105300	31401	f
Bobeiro	105301	30909	f
Quinta de Mede	105302	30828	f
Bouça	105303	130524	f
Quelha	105304	131426	f
Trindade	105305	131426	f
Trusal	105306	30821	f
Boa Vista	105307	30865	f
Defronte da Misericórdia	105308	160931	f
Suarreira	105309	31219	f
Fonde	105310	30816	f
Casa Nova	105311	31401	f
Costa	105312	130520	f
Rua das Vinte e Quatro	105313	160919	f
Combros	105314	30515	f
Resende	105315	30865	f
Conselha	105316	30854	f
Paraíso	105317	30843	f
Renda	105318	30803	f
Trofa	105319	130315	f
Travessa dos Rubins	105320	160919	f
Subado	105321	130333	f
Lugar do Engennho	105322	30869	f
Rio	105323	31405	f
Vinha	105324	30862	f
Vila Verde	105325	170331	f
Rebordelo	105326	31236	f
Ventuzela	105327	31225	f
Adro da Igreja Velha	105328	160919	f
Cernadela	105329	40510	f
Junto Capela São Roque	105330	160919	f
Venda Nova	105331	31230	f
Munhos	105332	30822	f
Gaiteira	105333	30819	f
Quinta de Laços	105334	30813	f
Tarron	105335	170501	f
Rua se Santiago, defronte ao Castelo	105336	160919	f
Monte	105337	30414	f
Igreja	105338	160145	f
Estrica	105339	160145	f
Pereira, Igreja	105340	160145	f
Padrão	105341	160145	f
Portacova	105342	160145	f
Porto Cerdeira	105343	160106	f
Alegria	105344	31230	f
Eido de cima	105345	30840	f
Cima de Pele	105346	30840	f
Mourisco	105347	31225	f
Sta. Luísa do Monte	105348	30823	f
Monte	105349	131426	f
Rua de S. Sebastião	105350	160919	f
Rua de Luís Jácome	105351	160919	f
Exposto na Roda de Lisboa	105352	110652	f
Hospital do Anjo	105353	30834	f
Águas quentes	105354	31402	f
Talhos	105355	130511	f
Bouça	105356	130327	f
Vacelo	105357	31405	f
Trigais	105358	30837	f
Boquinha	105359	30817	f
Satão	105360	181710	f
Cercado de S. Domingos	105361	160919	f
Frente ao Castelo	105362	160919	f
Fonte da Barrela	105363	30834	f
Pera Longa	105364	130307	f
Couço	105365	31233	f
Barrôco	105366	31405	f
Paço	105367	31225	f
Bobela	105368	31230	f
Caido	105369	30821	f
Caminho de Baixo	105370	460301	f
Cabo da Vila	105371	30854	f
Almofães	105372	31209	f
Corredoura	105373	31228	f
Bouços	105374	31221	f
Cascalheira	105383	31402	f
Monte	105384	130315	f
Peças	105385	31219	f
Souto Novo	105386	30848	f
Oliveira de Azeméis	105388	11309	f
Sameiro	105389	31210	f
Cima de Vila	105390	31232	f
Barroco	105391	30821	f
Assento	105392	30816	f
Souto	105393	30821	f
Cividade	105394	31219	f
Madalena	105395	30832	f
Além	105396	30505	f
igreija	105397	30505	f
Cabovila	105398	30516	f
Vilar de Ledra	105400	40711	f
Campo de cima	105401	30821	f
Outeiro	105402	130902	f
Bouça da Baiona	105404	30808	f
Póvoa	105405	100803	f
leirinha	105406	30505	f
Fardelhos	105407	30808	f
Borba de Godim	105408	130331	f
Granja	105409	130128	f
Cruz	105410	30505	f
Gaia	105411	30858	f
Pialho	105412	30808	f
Faísca	105413	30808	f
Caldas	105414	30808	f
Rua da Praça Velha - Viana	105416	160919	f
Ribeira	105417	30847	f
Torre	105418	30806	f
Cabreira	105419	30849	f
Vieite	105420	30849	f
Rio Douro	105421	40911	f
Gaia	105422	30808	f
Casal do barqueiro	105423	30806	f
Ribeiro	105424	30848	f
Igreja de Santiago	105425	30307	f
muro	105426	30855	f
Taipa	105428	130114	f
Rua Pedro de Melo	105429	160919	f
Barroca	105430	30849	f
Leal	105431	31216	f
Quintãs	105432	30862	f
Fonte	105433	30873	f
Piario	105434	30808	f
Quinta do Farfão	105435	40911	f
Capela de NªSrª do Carmo	105436	160919	f
Rua de Santa Luzia	105437	160919	f
Alpendre da Penha de França	105438	160919	f
Portela	105439	30872	f
Minas, Brasil	105440	160919	f
Vitorino	105441	160919	f
Arco do Cavalgante	105442	160919	f
Penelas	105445	30272	f
Arnal	105446	40308	f
Moinhos do Campo do Castelo	105447	160919	f
Quinta de Fontão	105448	160919	f
Igreja	105449	30268	f
Casa de Britelo	105450	30504	f
Eira	105451	30505	f
Souto Maior	105452	171009	f
Antas	105453	181101	f
Porta da Vila	105454	160931	f
Geraz do Lima	105455	160919	f
Caminho	105456	30808	f
Rua das Couves	105457	160931	f
Azenha	105458	30849	f
Igreja	105459	30855	f
Baiona	105460	30808	f
Montezelo	105461	30849	f
Sá	105462	30843	f
Subpaço	105463	30843	f
Corre	105464	30806	f
Tibais	105465	30806	f
Casa do Bairro	105466	30506	f
Rechão dos Sobreiros	105467	30858	f
Charneca	105468	30808	f
Igreja de Perre	105473	160919	f
Venade, Caminha	105474	160919	f
Rua do Postigo até à Piedade	105475	160931	f
Roda do Porto	105476	490291	f
Santa Justa	105477	40104	f
Couto	105478	40318	f
Rua do Corredio	105479	160919	f
Vila Fria	105480	30849	f
Eira	105481	30808	f
Souto	105482	30873	f
Estrebaria	105483	30502	f
Casal do Ferreiro	105484	30808	f
Assento	105485	30847	f
Igreja Matriz, Santa Maria Maior	105486	160931	f
Moinhos	105487	30849	f
Carrazedo	105488	40207	f
Areal	105489	30718	f
Portela	105490	30867	f
Barreirós	105491	30505	f
Sobrado	105492	131405	f
Beira	105493	160919	f
Beira, Portugal	105494	160919	f
Almeida	105495	490220	f
Afogado, junto à barra	105496	160919	f
Ilha do Bispo	105497	160919	f
Roda da Rua das Padeiras	105498	160931	f
Estrada do canto	105499	30808	f
Canto da banda de fora	105500	30808	f
Lufrei	105501	130115	f
Pevidém	105502	30868	f
Pomarinho	105503	30844	f
Telhado	105504	170201	f
Baganheira	105505	31403	f
Moinho do Carvalho	105506	130521	f
Souto Maior	105507	91320	f
Bom viver	105508	30836	f
Eido Novo	105509	130520	f
Fiães	105510	91307	f
Paço	105511	30837	f
Peixoto	105512	30854	f
Ninais	105513	31233	f
Bouças	105514	130915	f
Xeiras	105515	30831	f
Pontes	105516	30858	f
Santo Amaro	105517	130302	f
Lustosa	105518	130525	f
Moinhos	105519	130302	f
Inxido	105520	30831	f
Cachada	105521	130525	f
Ingido	105522	30843	f
Adro	105523	30841	f
Fermil	105524	30512	f
Matinho	105525	30608	f
Condes	105526	30913	f
a São Domingos	105527	160919	f
Souto	105529	30608	f
Serpa	105530	490133	f
Amial	105531	31230	f
Monte	105532	31402	f
São Brás	105533	30315	f
Pedra Longa	105534	31403	f
Povoa de Lanhoso	105535	490143	f
Ponte	105536	130908	f
Cachopadre	105537	130908	f
Madões	105538	130908	f
Leigal	105539	130908	f
Bouça	105540	130908	f
Nossa senhora das Candeiras	105541	180508	f
Miraldo	105542	130908	f
Devesinha	105543	30850	f
Devesinha	105544	30857	f
Pedreira	105545	30809	f
Rua de São Lázaro	105546	30813	f
Cruz	105547	30854	f
Pessô	105548	130908	f
Igreja	105549	130908	f
Além	105550	130908	f
Xistos	105551	130908	f
Freamunde	105552	130908	f
Sanguinhães	105553	130902	f
Lama	105554	130908	f
Louredo de baixo	105555	30857	f
Alberguaria do Anjo	105556	30834	f
Albergaria da Capela do Anjo	105557	30834	f
Pinheiro	105558	130908	f
Outeiro	105559	130908	f
Telhado Novo	105560	30809	f
Souto	105561	130516	f
Vila do Touro	105562	91139	f
Covas	105563	130522	f
Pegas	105564	130507	f
Boucinhas	105565	30845	f
Estrada	105566	130512	f
Lameirão	105567	30815	f
Lamegal	105568	181104	f
Igreja	105569	30865	f
Arquinho	105570	30849	f
Viande	105571	170505	f
Boavista	105572	130116	f
Sabugal	105573	30709	f
Ribeira de cães	105574	31247	f
Monte	105575	30850	f
Mosteiro S. Miguel	105576	131432	f
Souto do mosteiro	105577	131432	f
Vinha	105578	130307	f
Bouça	105579	130328	f
Soutinho	105580	30821	f
Penousos	105581	30801	f
Porta de Carros	105582	131214	f
Souto	105583	161002	f
Lagares	105584	130725	f
Devesa	105585	30862	f
São Tiago de Marvão	105586	121002	f
São Pedro de Agostém	105587	170333	f
Leigal	105588	131411	f
Outeiro	105589	30828	f
Taipa	105590	130304	f
Bouça fria	105591	30408	f
Forno	105592	30814	f
Santa Susana	105593	30406	f
Santa Susana	105594	31403	f
Arrifana	105595	30909	f
Senhor da Piedade	105596	130325	f
Sestais	105597	31402	f
Mondas	105598	30846	f
Campo da Penha	105599	160919	f
Mosteiro de Ferreira	105600	130905	f
Vale	105601	90908	f
Cima de Vila	105602	30814	f
Moinhos do Rato	105603	30821	f
Bouças	105604	30811	f
Bussacos	105605	130908	f
Porto	105606	131419	f
Torre	105607	31219	f
Santo Amaro	105608	30926	f
Real	105609	30847	f
Calçada	105610	30872	f
Cabadinha	105611	130512	f
Marcado	105612	30836	f
À porta de Sto. António	105613	30860	f
Pedominho	105614	31230	f
Paço	105615	30853	f
Prado	105616	30853	f
Junqueira	105617	30808	f
Lobeira (São Cosme)	105618	30803	f
Gandarela	105619	130908	f
Figueiredo	105620	30822	f
Cortinhas	105621	130302	f
Costa	105622	30820	f
Portela	105623	30210	f
Caniço	105624	30865	f
Eira Velha	105625	30843	f
Atom	105626	30865	f
Venda Nova	105627	130908	f
Reguengo	105628	30826	f
Venda	105629	30734	f
Rabosais	105630	131416	f
Aldeia	105631	31234	f
Quintal de São Francisco	105632	30863	f
Venda	105633	31407	f
Cotelho	105634	30713	f
Latas	105635	30312	f
Saganha	105636	30857	f
Portela	105637	30854	f
Outeiros	105638	30808	f
Longra	105639	130316	f
São Fins de Riba de Ave	105640	31204	f
São Fins de Riba de Ave - Igreja	105641	31204	f
Corvaceir	105642	30842	f
Quinta	105643	30730	f
Breia	105644	31225	f
Boavista	105645	130312	f
Trazões	105646	130307	f
Rua Nova	105647	30828	f
Ponte	105648	31402	f
Assento	105649	30805	f
Santarém	105650	30873	f
Carvalhal	105651	130908	f
Bussacos	105652	130906	f
Covo	105653	130908	f
Lisboa	105654	160919	f
Igreja	105655	30836	f
Ermeiros	105656	30842	f
Sapos	105657	31230	f
Olival e Pedroso	105658	30840	f
Bouça das Caldas	105659	30808	f
Chamusca	105660	130131	f
Escarei	105661	170905	f
Lavozim	105662	30828	f
Exposto na Roda	105663	490346	f
Corvite - Bouça	105664	30848	f
Bacelo	105666	30813	f
Funtão	105668	131419	f
Igreja	105669	30837	f
Junto à Senhora da Vitória	105670	160919	f
Bairro	105674	30856	f
Souto do arrabalde	105675	30865	f
Rua do Poço	105676	30352	f
Cruzeiro	105677	130323	f
Assento	105678	131426	f
Pevidem - Castro	105679	30854	f
S. Pedro	105680	30862	f
Covas	105681	30835	f
Seixo	105682	181815	f
Atães	105684	30839	f
Atães - Bairro	105685	30839	f
Palheiros	105686	170707	f
S.Cosme e Damião da Lobeira	105687	30839	f
Monte	105688	31234	f
Costeira	105689	30823	f
Água Quente	105690	31403	f
Pisca	105691	30850	f
Conceição de fora	105692	30815	f
Bouças	105693	30854	f
Freamunde de Cima	105694	130908	f
Tenda	105695	30807	f
Estremadouro	105696	30513	f
Outeiro	105697	131430	f
Casa Nova	105698	30823	f
Alto	105699	30832	f
Barrosas - Bouça	105700	31401	f
Sentozinhos	105701	131416	f
Igreja	105702	131416	f
Corvite - Campos	105704	30848	f
Rua da Praça das Couves	105705	160931	f
Tomada	105706	30851	f
S.Tiago - Bairro	105707	30920	f
Sodelo	105708	30808	f
Ameijoeira	105709	160302	f
Outeiro	105710	30803	f
Padeiro	105711	30502	f
Freixieiro	105712	30502	f
Parada	105713	130906	f
Vinha	105714	30512	f
Quinta do Couquinho	105715	40909	f
Venda Velha	105716	30846	f
Samoça	105717	130320	f
Hortas domenicas	105718	30863	f
Ruivos	105719	31219	f
Fontes	105720	31219	f
Boavista	105721	30826	f
Taburnos	105722	30858	f
Remondes	105723	40814	f
Bande	105724	130902	f
Moreira	105725	130524	f
S. Miguel	105726	30866	f
Alqueirão	105727	131424	f
Alcarias	105728	130205	f
Guilhufe	105729	30833	f
Venda	105730	130317	f
Igreja	105731	130906	f
São João da Porta da Ribeira	105732	160931	f
Moinhos do Ribeiro	105733	40909	f
Vilarinho de Friões	105734	171212	f
Vale de Porco	105735	40823	f
Cardide	105737	30850	f
Pedra Maria	105738	130330	f
Ponte de serves	105739	30821	f
Convento dos Capuchos	105740	30804	f
Paredes	105741	31405	f
Mosoiro	105742	30846	f
Soeiro	105743	30821	f
Hortas do Prior	105744	30863	f
Outeiro	105745	30920	f
Convento dos capuchos	105749	110624	f
Devesa	105750	30913	f
Pulo	105751	30831	f
Boa Vista	105752	30836	f
Parada	105756	130914	f
Acima de Vila Verde	105757	30863	f
Castelo	105758	30837	f
Bairro	105759	30516	f
Requeixo	105760	30841	f
Entre as Vinhas	105761	30864	f
Chazim	105762	30407	f
Rabiçais	105763	30407	f
Montezinhos	105764	31403	f
Passinhos	105765	30831	f
Pentieiros - Pinheiro	105766	30869	f
Quinta das Eiras	105767	40909	f
Inveladouro	105768	30821	f
S. Miguel do Castelo	105769	30834	f
Quintã	105770	31402	f
Vadoucos	105771	30818	f
Vilar	105772	30865	f
Do Pombal pela porta do Mar	105773	160931	f
Rua do Pombal pela parte do Mar	105774	160931	f
Pica	105775	31213	f
Rua de Pedro de Melo	105776	160919	f
Estalagem de Barco	105777	30808	f
Camarinhos	105778	130311	f
Lugar do Canto do Poço ao cais	105779	460305	f
Rio	105780	31326	f
Quinta do Ataíde	105781	41008	f
Largo do Pombal	105782	160919	f
Lameirão	105783	30521	f
Chelas	105784	30513	f
Paço	105785	130507	f
Capela de S. António	105786	30808	f
Porta do Souto	105787	30341	f
Bouça de Pardelhas	105788	30808	f
Rechão	105789	30858	f
Assento	105790	31228	f
Lamas	105791	30821	f
Seara	105792	30806	f
Assento	105793	30505	f
Bouça	105794	30806	f
Serrinha	105795	30504	f
Costa	105796	30519	f
Corredoura	105797	30849	f
Agrochao	105798	40536	f
Quinta do Carvalhal	105799	40909	f
Vila de Basto	105800	30504	f
Tarrio de baixo	105801	30858	f
Moinhos da Reboreda	105802	30808	f
Fundeira	105803	30514	f
Ponte de Serves	105804	31230	f
Defronte da Igreja Matriz	105806	160931	f
Rua da Travessa dos Fornos	105807	160931	f
Besteiros	105808	40306	f
Assento	105809	31232	f
Eido	105810	30840	f
Penha de Águia	105811	90411	f
Cedaínhos	105812	40731	f
Fontão	105814	130902	f
Jejua	105815	90321	f
Via Sacra (Senhora da Agonia)	105816	160919	f
Freches	105817	91308	f
Ferreirim	105818	181807	f
Gulpilheiras	105819	30504	f
Moreira	105820	91312	f
Ponte da Silveira	105821	40909	f
Moreira	105822	30855	f
Além Estrada	105823	30855	f
Carvalho	105824	30855	f
Pesqueira	105825	490370	f
Fojó	105826	30855	f
Vendas	105827	30805	f
Igreja	105828	30827	f
Batoca	105829	30805	f
Monte	105830	30506	f
A-do-Cavalo	105831	91312	f
Quinta da Ponte	105832	40916	f
Bairro do Treino	105833	490425	f
Custóias	105834	91405	f
Pinela	105835	40230	f
Igreja	105836	130914	f
Praça das Couves	105837	160919	f
Frente Cruzeiro Monserrate	105838	160919	f
Igreja	105839	30805	f
Fontaínha	105840	30827	f
Além Rio	105841	30855	f
Venda Nova	105842	30855	f
freguesia de Távora	105843	160919	f
Arcos de Valdevez - Távora	105844	160919	f
Vinha	105845	30855	f
Palme, Barcelos	105846	30255	f
Botica	105847	30827	f
Cotuluda	105848	30827	f
Soutinho	105849	30858	f
Fojo	105850	30858	f
Cotoluda	105851	30858	f
Botica	105852	30858	f
Igreja	105853	30858	f
Tapada	105854	30858	f
Antigas	105855	30858	f
Burgão	105856	30858	f
Souto de sta. Maria de Sevêr	105857	30858	f
Sardoal	105858	30508	f
Casal de Nino	105859	30502	f
Couvido	105860	30858	f
Sevêr - Bouça	105861	30858	f
residência	105862	30505	f
Bouças	105863	30518	f
Vinhas	105864	30858	f
Romãs	105865	181708	f
Feijoal	105866	30340	f
Ansaris	105867	30311	f
Vilarinho	105868	30858	f
Riomau	105869	30340	f
Soutinho	105870	30340	f
Avoes	105872	180502	f
Cachadinha	105873	30858	f
Bruxelas, Flandres, Bélgica	105874	160931	f
Portela	105875	30518	f
Souto	105876	30849	f
Moinhos de Torre	105877	30849	f
Torre	105878	30849	f
Quinta de Pousada	105879	30805	f
Telhado	105881	30855	f
Grovas	105882	130315	f
Forcada	105883	30814	f
Casalinho	105884	30849	f
santa cruz	105885	130908	f
Souto	105886	30855	f
Aldeia	105887	31230	f
Quinta	105888	30858	f
Eiteiro	105889	30873	f
dos Matos	105890	30838	f
Eivados	105891	40729	f
Suçães	105892	40729	f
Vila de Igreja	105893	181710	f
Pala	105894	91015	f
Ferreiro	105895	30808	f
Pico Ruivo	105896	460101	f
Travessa do Salgueiro	105897	160919	f
Sequeiro	105898	30808	f
Bemposta - casas de fora	106897	30808	f
Bouça do rio	106899	30808	f
Fazenda das pigarras	106900	30808	f
Poço do Canto	106901	90912	f
Vale de Prados	106902	40534	f
Cerdeira	106903	182205	f
Touro	106904	182205	f
Real de corvos	106905	30207	f
Canto de dentro	106906	30808	f
Cadeia da Relação	106907	131215	f
Alminha	106908	30848	f
Costa	106909	30862	f
Santo António	106910	130908	f
Rua do Trigo	106911	160919	f
Pala	106912	130212	f
Assento	106913	30849	f
Bouça da Barranca	106914	30827	f
Vila Maior	106915	90904	f
Ponte da Ribeira da Vilariça	106916	40909	f
Barreiras	106917	30855	f
Barreira	106918	30815	f
Corvite-Ribas	106919	30848	f
Panço	106920	30849	f
Quinta do Ricardo - Portela	106921	160919	f
Laja de Pardelhas #	106922	30709	f
Lamas	106923	30840	f
Santa Eugénia	106924	170113	f
Devesa	106925	30340	f
Rio Mau	106926	30340	f
Vila Garcia	106927	91328	f
Assento	106928	30340	f
Quinta de Agra	106929	30504	f
Casal de Campo	106930	30805	f
Belos	106931	30805	f
Igreja de Monserrate	106932	160931	f
Cabeço de São Miguel	106933	460305	f
Dadim - Devesa	106934	30329	f
Campo da Vinha	106935	30341	f
Calvário	106936	160919	f
Corvite - Souto de Ribas	106937	30848	f
Souto de Freijões	106938	30848	f
Lomba da Cruz	106939	470105	f
Corvite - Freijão	106940	30848	f
Eira Velha	106941	30855	f
Campo	106942	30805	f
Bouça	106943	30816	f
Moreira	106944	30513	f
Quinta dos Santos Mártires	106945	160919	f
Moreira	106946	180909	f
Carreiro	106947	30311	f
Bussos	106948	30872	f
Fortunho	106949	171425	f
Defronte de Santa Catarina	106950	160919	f
Escolas Gerais	106951	110651	f
Não referido	106952	160919	f
Além da estrada	106953	30855	f
Defronte do chafariz de S. Domingos	106954	160919	f
Rua do Mirante	106955	160931	f
Rua dos Fornos  de Baixo	106956	160931	f
Cancelo	106957	31234	f
Soutelo	106958	30805	f
Carvalhal	106959	30505	f
Cavião de Cima	106960	11902	f
Casal de Arão	106961	11902	f
Igreja de Rôge	106962	11902	f
Freguesia de Darque	106964	160919	f
Darque	106965	160919	f
Alto da Portela	106966	160919	f
Rua dos Fornos	106968	160919	f
Calvário	106969	31236	f
Portela	106970	131112	f
Mato	106971	31402	f
Igreja de Rôge	106972	11907	f
Defronte da cruz de Santa Catarina	106973	160919	f
Laje	106974	30827	f
Pinheiros	106975	30849	f
Igreja	106976	30513	f
Reguengos	106977	30709	f
Igreja	106978	30512	f
Rocinho	106979	30513	f
Rua de São Bom Homem	106980	160931	f
Figueiredo	106981	30513	f
Peixoto	106982	130317	f
Rãs	106983	130317	f
Caminho do Tanque	106984	440101	f
Ferreorós	106985	30513	f
Rua Gonçalo Afonso	106986	160931	f
a Santo Bom Homem	106987	160919	f
no Postigo	106988	160931	f
Roda dos expostos	106989	460204	f
Samorinha	106990	40304	f
ao pé da capela S. António	106991	30808	f
Miradezes	106992	40733	f
Rua de Viana	106993	160931	f
Luzelos	106994	40309	f
Arrifana de Sousa	106995	131124	f
Asilo de Mendicidade	106996	131202	f
Rua do Cimo da Lomba	106997	470107	f
Travessa do Pilar	106998	470107	f
Ferreirós	106999	30513	f
Canada da Costa	107000	460203	f
Bemposta	107001	31219	f
Gervide	107002	30833	f
Lamas	107003	30872	f
Vinha	107005	30857	f
na parte do Pombal	107006	160931	f
casal das pigarras	107007	30808	f
Montinho	107008	30853	f
Casa do Monte	107009	30816	f
Figueiró	107010	31219	f
Arcas	107012	181209	f
Eirado da Cadeia	107013	160919	f
Parada	107014	40108	f
Rua do Poço	107016	160919	f
Paço	107017	30843	f
Devesa	107018	30808	f
Moura	107019	30854	f
Idanha-a-nova	107021	50503	f
Lugar dos Pereiros	107022	490159	f
Igreja de São Mateus	107023	470112	f
Porta	107026	130525	f
Quinta de Além	107027	130309	f
Carvalho	107028	460305	f
Escorregadoura	107029	130525	f
Juste	107030	130525	f
Rua da Cruz	107031	460201	f
Soutulho	107032	30513	f
Pinhó	107033	30513	f
Penagude	107035	30513	f
Rabela	107036	31230	f
Escalheiro	107037	30858	f
Alganhafres	107038	40317	f
Telhado	107039	30842	f
Souto da Roda	107040	30842	f
Touzia	107041	30806	f
Devesa	107042	130302	f
Caseiras	107043	31239	f
Travessa do Cais	107044	160931	f
Ribeira dos moinhos	107045	30844	f
Surriba	107046	30513	f
Bouça Nova	107047	30808	f
Ribos de cima	107048	30849	f
Av. da Praia	107049	131301	f
\.


--
-- Data for Name: Profession; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Profession" (name, id, "isOriginal") FROM stdin;
Advogado (a)	4	f
Agenciador	5	f
Agricultor	6	f
Ajudante	7	f
Albardeiro	8	f
Alcaide	9	f
Alfaiate	10	f
Alfandegueiro	11	f
Alferes	12	f
Almirante	13	f
Almocreve	14	f
Almoxarife	15	f
Alquilador	16	f
Ama	17	f
Amanuense	18	f
Apontador de Obras Públicas	20	f
Armador	21	f
Arqueólogo	22	f
Arrieiro	23	f
Artista	25	f
Assistente	26	f
Bacharel	27	f
Baleeiro	28	f
Barbeiro	29	f
Barqueiro	30	f
Bibliotecário	31	f
Botequineiro	32	f
Botoeiro	34	f
Cabaneiro	35	f
Cabeleireiro (a)	36	f
Cabo	37	f
Cabouqueiro	38	f
Caiador	39	f
Caixeiro	40	f
Calafate	41	f
Calceteiro	42	f
Caldeireiro	43	f
Caminheiro	44	f
Canteiro	45	f
Capador	47	f
Capitalista	48	f
Capitão	49	f
Capitão Navios	50	f
Carcereiro	51	f
Cardador(a)	52	f
Carniceiro	53	f
Carpinteiro	55	f
Carreiro	56	f
Carrejão	57	f
Carteiro	58	f
Carvoeiro	59	f
Cauteleiro	62	f
Cerieiro	64	f
Chapeleiro	66	f
Charameleiro	67	f
Cirurgião	69	f
Cocheiro	70	f
Colchoeiro	71	f
Comandante Militar	72	f
Comendador	73	f
Comerciante	74	f
Confeiteiro	76	f
Conselheiro	77	f
Cônsul	78	f
Contínuo	80	f
Contratador(a)	82	f
Corregedor	83	f
Correeiro	84	f
Cortador	85	f
Costureiro (a)	86	f
Coveiro (a)	87	f
Cozinheiro (a)	89	f
Curtidor	96	f
Cutileiro	97	f
Deputado	100	f
Descarregador	101	f
Desembargador	102	f
Despachante da Alfândega	103	f
Distribuidor da Correição	104	f
Doceiro	105	f
Doméstica	107	f
Educador Infância	109	f
Empregado do Governo Civil	110	f
Empregado	111	f
Empregado Agrícola	112	f
Empregado de Escritório	114	f
Empregado de Hotel	115	f
Empregado Industrial	118	f
Empregado Têxtil	119	f
Empregado do Banco	120	f
Empregado da Fazenda	121	f
Empregado do Correio	124	f
Empregado do Notário	125	f
Empregado na Repartição da Fazenda	126	f
Empregado na Repartição de obras públicas	127	f
Empregado nas Docas	128	f
Encadernador	129	f
Enfermeiro (a)	131	f
Engenheiro (a)	133	f
Engomadeira	134	f
Engraxador	135	f
Ensamblador	136	f
Ermitão	137	f
Escravo (a)	139	f
Escrevente	140	f
Escriturário	141	f
Escrivão	142	f
Escrivão da Câmara	144	f
Escudeiro	145	f
Escultor	146	f
Espadeiro	147	f
Espingardeiro	148	f
Estalajadeiro	149	f
Estanqueiro do tabaco	150	f
Estudante	152	f
Fabricante	154	f
Farmacêutico	155	f
Feitor	156	f
Ferrador	157	f
Ferreiro	158	f
Fiadeiro (a)	159	f
Fiscal	160	f
Fogueiro	161	f
Fogueteiro	162	f
Forneiro	163	f
Funcionário do Jornal	167	f
Funcionário Público	168	f
Fundidor	169	f
Funileiro	170	f
Garfeiro	171	f
Gaspeador	172	f
Ginasta	174	f
Gravador	176	f
Guarda da Alfândega	177	f
Guarda da Fazenda Nacional	178	f
Guarda Fiscal	180	f
Guarda Livros	181	f
Guarda Soleiro	182	f
Hortelão	183	f
Hospitaleiro	184	f
Industrial	186	f
Informático	187	f
Inquiridor	188	f
Inspector Trabalho	189	f
Jardineiro	190	f
Jornaleiro (a)	191	f
Jornalista	193	f
Juíz	194	f
Juíz dos órfãos	195	f
Lampianista	196	f
Lapidário	197	f
Latoeiro	198	f
Lavadeira	199	f
Lavrador (a)	200	f
Livreiro	201	f
Lixeiro	202	f
Lojista	203	f
Major	204	f
Marceneiro	207	f
Marchante	208	f
Marinheiro	210	f
Marítimo	211	f
Médico	212	f
Meirinho	213	f
Mercador	214	f
Merceeiro (a)	215	f
Mestre de Meninos	217	f
Metereologista	219	f
Militar	220	f
Mesteiral	221	f
Moleiro (a)	222	f
Mordomo	224	f
Músico	225	f
Negociante	226	f
Notário	227	f
Oficial da Repartição da Fazenda	228	f
Oficial de diligências	229	f
Oleiro	230	f
Operador CTT	231	f
Operário	232	f
Operário(a) industrial	233	f
Operário(a) têxtil	234	f
Organista	235	f
Ourives	236	f
Ourives de ouro	237	f
Ourives de prata	238	f
Padeiro	239	f
Padre	241	f
Palmilhador	242	f
Parteira	243	f
Pasteleiro	246	f
Patrão	247	f
Picheleiro	248	f
Pedreiro	249	f
Peneireiro	250	f
Penteeiro	251	f
Pescadeiro	253	f
Pescador	254	f
Pianista	255	f
Piloto	256	f
Pintor	257	f
Polícia	258	f
Porteiro	259	f
Pregoeiro	260	f
Presbítero Secular	261	f
Procurador	262	f
Professor(a)	264	f
Professor(a) de Instrução Primária	265	f
Proprietário (a)	267	f
Rebocador	268	f
Recoveiro	269	f
Religioso	272	f
Relojoeiro	273	f
Remador	274	f
Retratista	275	f
Reverendo	276	f
Sacristão	277	f
Sangrador	278	f
Santeiro	279	f
Sapateiro	280	f
Sargento	281	f
Sargento-Mor	282	f
Secretário	283	f
Seleiro	284	f
Serrador	285	f
Serralheiro	286	f
Serviçal	288	f
Servo	289	f
Sindicante dos tabacos	290	f
Sineiro	291	f
Sirgueiro	292	f
Soldado	293	f
Solicitador	294	f
Solicitador da Fazenda	295	f
Sombreireiro	296	f
Soqueiro	297	f
Surrador	298	f
Tabelião	299	f
Taberneiro(a)	300	f
Tamanqueiro	301	f
Tanoeiro	302	f
Tecelão/Tecedeira	304	f
Tendeiro (a)	306	f
Tenente	307	f
Tenente Coronel	308	f
Tesoureiro	309	f
Tintureiro	310	f
Tipógrafo	311	f
Torneiro	312	f
Tozador	313	f
Trabalhador(a)	314	f
Trabalhador(a) agrícola	315	f
Trabalhador(a) independente	316	f
Vendeiro (a)	320	f
Veterinário	322	f
Vigário	323	f
Vinhateiro	324	f
Violeiro	325	f
Zelador	326	f
Lavrador Caseiro	327	f
Pastor(a)	328	f
Prostituto(a)	329	f
Ferroviario	336	f
Trabalhador(a) na linha férrea	337	f
Canastreiro	341	f
Agulheiro	344	f
Guarda a pé	345	f
Tripeiro (a)	347	f
Capelão	348	f
sem profissão	349	f
Clérigo "in minoribus"	350	f
Clérigo - Prima Tonsura	351	f
Governo Casa	352	f
Negociante de Cera	353	f
Fuzileiro naval	354	f
Sacerdote	355	f
Frade / Freira	356	f
Egresso	0	f
Tacheiro	357	f
Caseiro	358	f
Regedor	360	f
Mineiro	362	f
Clérigo Presbítero	372	f
Jurista	376	f
Cabo da Guarda Municipal	379	f
Mendigo (a)	381	f
Polícia Fiscal	382	f
Açougueiro	384	f
Litógrafo	386	f
Cesteiro	389	f
Coradeira	390	f
Peixeiro(a)	391	f
Leiteiro (a)	392	f
Picador	394	f
Contraste	395	f
Biscoiteiro	396	f
Administrador das Rendas da Rainha	397	f
Cómico gimnástico	399	f
Modista	400	f
Empreiteiro	401	f
Condutor	404	f
Talhante	405	f
Entalhador	406	f
Gaiteiro	407	f
Fidalgo	408	f
Mestre de canto	411	f
Aspirante	414	f
Telegrafista	415	f
Adeleiro	416	f
Administrador do Concelho	417	f
Dona de Casa	418	f
Agente	419	f
Agente Comercial	420	f
Agente de Causas	421	f
Aguadeiro	422	f
Vendedor ambulante	423	f
Arbitrador Judicial	424	f
Arcediago	425	f
Armeiro	426	f
Arquitecto	427	f
Artilheiro	429	f
Assedador (eira)	431	f
Azeiteiro	432	f
Azulejador	433	f
Bainheiro	435	f
Bordador (eira)	436	f
Brunidor (eira)	437	f
Cabreiro	438	f
Caçador	439	f
Camisoleiro	440	f
Campeiro	441	f
Cartorário	442	f
Cavaleiro	444	f
Motorista	445	f
Chefe de Estação	449	f
Dentista	450	f
Subdiácono	451	f
Comprador de gado	454	f
Cónego	455	f
Cordoeiro	456	f
Corneteiro	457	f
Corneteiro-mor	458	f
Coronel	459	f
Delegado	461	f
Provedor régio	462	f
Desenhador	463	f
Director do banco	464	f
Director (a)	465	f
Director do Correio	466	f
Droguista	470	f
Eletricista	471	f
Empregada doméstica	473	f
Empregado fabril	474	f
Bombeiro	475	f
Empregado no caminho de ferro	476	f
Empregado da alfândega	477	f
Empregado da Conservatória	478	f
Empregado de escola	479	f
Enxertador	480	f
Escrevente da Fazenda	481	f
Escrivão da correição	482	f
Escrivão da paz	483	f
Escrivão da almotaçaria	484	f
Escrivão de direito	485	f
Escrivão do geral	486	f
Escrivão do reguengo	487	f
Escrivão dos órfãos	488	f
Escrivão judicial	489	f
Esgrimador	490	f
Estafeta	491	f
Estampador	492	f
Estanqueiro-mor	493	f
Estucador	494	f
Executor	496	f
Farrapeiro	497	f
Fiteiro	498	f
Fotógrafo	500	f
Furriel	501	f
Galinheira	502	f
General	503	f
Gerente	504	f
Guarda	505	f
Guarda-fios	506	f
Guarda-nocturno	507	f
Hoteleiro	509	f
Juiz de Fora	511	f
Licenciado	512	f
Malheiro	514	f
Maquinista	516	f
Marmoreiro	517	f
Mestre (marítimo)	518	f
Mestre de campo	520	f
Mestre de música	523	f
Mestre-escola	524	f
Ministro	528	f
Recadista	529	f
Oficial de administração	532	f
Oficial da provedoria	534	f
Urdidor (eira)	535	f
Prebendeiro	536	f
Professor(a) particular	538	f
Recebedor	539	f
Refinador [de açucar]	540	f
Regatão/Regateira	541	f
Revendedor (a)	542	f
Revisor	543	f
Sardinheiro(a)	544	f
Sargento-ajudante	546	f
Sargento da Guarda Fiscal	548	f
Segeiro	549	f
Segundo-cabo	550	f
Superintendente do Tabaco	551	f
Tenente-general	553	f
Tenente-médico	554	f
Toucinheiro	555	f
Trolha	556	f
Pagador do Exército	557	f
Capitão de Milícias	558	f
Doutor(a)	559	f
Ator	1	f
Administrador do Tabaco	3	f
Anzoleiro	19	f
Boticário	33	f
Cantoneiro	46	f
Cascalheiro	61	f
Contador	79	f
Delegado do Procurador Régio	98	f
Empregado das Obras Públicas	122	f
Escrivão da Administração do Concelho	143	f
Governador Civil	175	f
Imaginário	185	f
Mamposteiro dos cativos	205	f
Negociante de Fazendas Brancas	365	f
Vivem da Agência	385	f
Fiscal de Real de Água	561	f
Carreteiro	563	f
Mareante	564	f
Presbítero	565	f
Tenente do castelo	566	f
Correio Mor	567	f
Caleiro	570	f
Piloto da barra	572	f
Remendão (sapateiro)	573	f
Besteiro	575	f
Pobre	577	f
Afinador	578	f
Auxiliar de Enfermagem	580	f
Caixeiro Viajante	583	f
Coadjutor	586	f
Criado (a)	587	f
Criado de Lavoura	588	f
Dobador (eira)	589	f
Empregado comercial	591	f
Empregado da Lavoura	592	f
Encarregado Geral	593	f
Operário(a) fabril	602	f
Pedinte	603	f
Reformado(a)	615	f
Reitor	616	f
Reservatário	619	f
Viajante	624	f
Lenhador	627	f
Cravador	628	f
Lavrante	629	f
Alugador	630	f
Prateiro	632	f
Afinador têxtil	634	f
Ajudante têxtil	636	f
Cobrador	637	f
Farinheiro (a)	638	f
Indigente	639	f
Militar infantaria	640	f
Rendeiro(a) - agrícola	643	f
Dourador	644	f
Capelista	645	f
Saleiro	646	f
Despenseiro	648	f
Familiar Santo Ofício	650	f
Juiz da Alfândega	651	f
Vereador	652	f
Governador	653	f
Corretor	654	f
Administrador de Empresas	658	f
Analista de Sistemas	659	f
Auditor Contabilístico	660	f
Brigadeiro	662	f
Cadete	663	f
Controlador Aéreo	665	f
Morgado	666	f
Economista	667	f
Psicólogo(a)	668	f
Fazendeiro	672	f
Marechal	673	f
Empregado Judicial	674	f
Pecuarista	675	f
Diácono	677	f
Fâmulo	679	f
Conde/Condessa	680	f
Duque/Duquesa	681	f
Bispo	686	f
Administrador	687	f
Senador	690	f
Barão/Baronesa	691	f
Clérigo	694	f
Camponês	695	f
Aprezenhadeira	696	f
Medidor	698	f
Miliciano	699	f
Queijeiro	701	f
Veterano	703	f
Vendedor	704	f
Cabo da Guarda	708	f
Escrivão da Fazenda	709	f
Seminarista	710	f
Cabo de Mar	712	f
Faroleiro	713	f
Monteiro	714	f
GNR	715	f
Tambor	716	f
Servente	717	f
Polidor	720	f
Empregado Farmácia	723	f
Assistente de Vendas	725	f
Banheiro (a)	726	f
Chaufeur	727	f
Cortador de Carnes	728	f
Louceira	729	f
Carregador Ferroviário	731	f
Chefe Estação Telegráfica	733	f
Comissário Santo Ofício	734	f
Chefe Posto Fiscal	735	f
Distribuidor Postal	736	f
Telheiro	737	f
Empregado Fiscalização	738	f
Abade (Abadessa)	739	f
Mordomo da Igreja	740	f
Limador	741	f
Esteireiro	743	f
Capitão-Mor	745	f
Fiscal de Obras	751	f
Empregado na produção de energia	753	f
Fabricante de tecidos	754	f
Guarda-florestal	756	f
Fabricante de Sabão	761	f
Fabricante de Couros	762	f
Seareiro	770	f
Rendeiro(a) - têxtil	2896	f
Tenente de Infantaria	2930	f
Quadrilheiro	3033	f
Pobre de pedir	3050	f
Ama de leite	3171	f
Tenente de cavalaria	3252	f
Tenente Geral de Artilharia	3273	f
Ama de abade	3330	f
Oficial de Justiça	3635	f
Apontador do caminho de ferro	403	f
Arrematante de Estradas	428	f
Chefe de esquadra da polícia	446	f
Empregado da Câmara Municipal	472	f
Estofador	495	f
Joalheiro	510	f
Moço de fretes	530	f
Sargento quartel-mestre	547	f
Cultivador	560	f
Repartidor dos Órfãos	631	f
Oficial do Exército	655	f
Procurador de Justiça	676	f
Administrador de seus bens	707	f
Assentador Caminhos Ferro	730	f
Empregado dos arrematantes do Real d Água	752	f
\.


--
-- Data for Name: Title; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Title" (id, name, "isOriginal") FROM stdin;
0	Carmelita Descalço	f
1	Frei	f
2	Ilustríssimo	f
3	Cavaleiro da Ordem de Cristo	f
4	Cavaleiro da Ordem de S. Tiago	f
5	Conde	f
6	Fidalgo da Casa Real	f
7	Visconde	f
8	Excelentíssima	f
9	Excelentíssimo	f
10	Viscondessa	f
11	Governador	f
12	Dona	f
13	Barão	f
14	Professo do Hábito de Cristo	f
1014	Capitão	f
1015	Condestável	f
2014	Familiar do Santo Ofício	f
2015	Dom	f
2016	Alcaide-mor	f
2017	Condessa	f
2018	Doutor	f
2019	Morgado	f
2020	Comendador	f
2021	Fidalga	f
2022	Ilustríssimo(a)	f
2023	Subdiácono	f
2024	Marquesa	f
2025	Cavaleiro do Hábito de Cristo	f
2026	Marquês	f
2027	Reitor	f
2028	Ajudante	f
2029	Sargento	f
2030	Sargento-mor	f
2031	Alferes	f
2032	Padre	f
2033	Reverendo	f
2034	Coronel	f
2035	Licenciado	f
2036	Arcediago	f
2037	Beneficiado	f
2038	Cónego	f
2039	Abade	f
2040	Arcipreste	f
2041	Tesoureiro	f
2042	Tenente Coronel	f
2043	Senhor	f
2044	Marechal	f
2045	Tenente General	f
2046	Tenente	f
2047	Mestre-de-Campo	f
2048	Major	f
2049	Capitão-Mor	f
2050	Brigadeiro	f
2051	Cadete	f
2052	Furriel	f
2053	Cabo	f
2054	Vigário	f
2055	Guarda-Mor	f
2056	Engenheiro	f
2057	Patrão mor	f
2058	Tesoureiro-Mor	f
2059	Cirurgião Mor	f
2060	Soldado	f
2061	Capelão	f
2062	Cura da Colegiada	f
2063	Arcebispo	f
2064	Duque	f
2065	Duquesa	f
2066	Auditor Geral de Guerra	f
2067	Abade da Meadela	f
2068	Coadjutor de Areosa	f
2069	Vigário-Geral	f
2070	Fidalgo de Sua Majestade	f
2071	regrante	f
2072	cónego regrante	f
2073	Conde de Tarouca	f
2074	Abadessa de São Bento	f
2075	Prior	f
2076	Mestre	f
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (name, email, password, "createdAt", "updatedAt", "currentParishId", id, "currentEventType", role) FROM stdin;
Filipe	fsalgado@csarmento.uminho.pt	$2b$10$TCGzcd2RRv//KG54HtAayOfQfijm60n2DWk31BigJXXymbxZ51Uxq	2026-01-15 21:54:22.766	2026-01-22 11:59:37.139	130331	2	BAPTISM	USER
Admin	admin@simplergn.com	$2b$12$34BkncSXfr2apevqt4U0Z.v2hp2tpJTPSmj1IpLI0JBqZvMz0D0Vq	2026-01-14 22:07:08.562	2026-01-22 12:12:04.348	130331	1	BAPTISM	ADMIN
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
71a35b5e-a39e-43a2-9fee-8a0ad38c6530	448577e284a2d500fd797760b634aabfa23f64a0b23255eeaed8c35b7e1447d1	2026-01-14 22:06:25.555737+00	20260106112951_init	\N	\N	2026-01-14 22:06:25.497702+00	1
3e496d0f-f2b1-4188-a4ee-5049eca801e1	bfa445538277841d6caf7b6bbcbe3d69f316f4b250e8ede57f932b6fc2daf902	2026-01-14 22:06:25.692618+00	20260109135842_change_ids_to_int	\N	\N	2026-01-14 22:06:25.559808+00	1
cdd63cd8-ba4e-41fa-b1a7-c52f4b11f203	02b0309ee89d09765573005428141775a8db5ab397a6620f4704b32a6cdfb387	2026-01-14 22:06:25.707468+00	20260112215246_add_current_event_type	\N	\N	2026-01-14 22:06:25.696501+00	1
55d80a59-2d17-4374-881b-e6a4681f7836	ecc0f9f8536a0c02c4526e4a24096a6360e0a7f90176da26693fc5d02303feed	2026-01-14 22:06:25.722298+00	20260114102449_add_lineage_index	\N	\N	2026-01-14 22:06:25.710442+00	1
945bad2d-209c-4bf1-b24a-703eda7a4b36	359bd34fa21edb1ec3f66105154949e8aee5d0af465fe758fca1d8f272c8acfa	2026-01-14 22:06:25.742994+00	20260114124542_add_is_original_field	\N	\N	2026-01-14 22:06:25.725537+00	1
09085911-c7e2-4700-a168-44d673a4a873	6ae9bece0ea1418f0805668d1caac4f4c209cfd5a58bdabb61d92a56abc3ffc8	2026-01-15 21:14:56.875965+00	20260115211456_add_user_role	\N	\N	2026-01-15 21:14:56.845966+00	1
\.


--
-- Name: Event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Event_id_seq"', 3, true);


--
-- Name: Family_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Family_id_seq"', 8, true);


--
-- Name: Individual_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Individual_id_seq"', 39, true);


--
-- Name: Kinship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Kinship_id_seq"', 1, false);


--
-- Name: LegitimacyStatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."LegitimacyStatus_id_seq"', 3, true);


--
-- Name: Parish_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Parish_id_seq"', 1, false);


--
-- Name: ParticipationRole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ParticipationRole_id_seq"', 1, false);


--
-- Name: Participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Participation_id_seq"', 56, true);


--
-- Name: Place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Place_id_seq"', 107049, true);


--
-- Name: Profession_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Profession_id_seq"', 1, false);


--
-- Name: Title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Title_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."User_id_seq"', 2, true);


--
-- Name: Event Event_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Event"
    ADD CONSTRAINT "Event_pkey" PRIMARY KEY (id);


--
-- Name: Family Family_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_pkey" PRIMARY KEY (id);


--
-- Name: Individual Individual_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual"
    ADD CONSTRAINT "Individual_pkey" PRIMARY KEY (id);


--
-- Name: Kinship Kinship_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Kinship"
    ADD CONSTRAINT "Kinship_pkey" PRIMARY KEY (id);


--
-- Name: LegitimacyStatus LegitimacyStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."LegitimacyStatus"
    ADD CONSTRAINT "LegitimacyStatus_pkey" PRIMARY KEY (id);


--
-- Name: Parish Parish_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Parish"
    ADD CONSTRAINT "Parish_pkey" PRIMARY KEY (id);


--
-- Name: ParticipationRole ParticipationRole_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ParticipationRole"
    ADD CONSTRAINT "ParticipationRole_pkey" PRIMARY KEY (id);


--
-- Name: Participation Participation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_pkey" PRIMARY KEY (id);


--
-- Name: Place Place_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Place"
    ADD CONSTRAINT "Place_pkey" PRIMARY KEY (id);


--
-- Name: Profession Profession_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Profession"
    ADD CONSTRAINT "Profession_pkey" PRIMARY KEY (id);


--
-- Name: Title Title_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Title"
    ADD CONSTRAINT "Title_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Family_marriageEventId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Family_marriageEventId_key" ON public."Family" USING btree ("marriageEventId");


--
-- Name: Kinship_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Kinship_name_key" ON public."Kinship" USING btree (name);


--
-- Name: LegitimacyStatus_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "LegitimacyStatus_name_key" ON public."LegitimacyStatus" USING btree (name);


--
-- Name: ParticipationRole_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "ParticipationRole_name_key" ON public."ParticipationRole" USING btree (name);


--
-- Name: Participation_eventId_individualId_role_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Participation_eventId_individualId_role_key" ON public."Participation" USING btree ("eventId", "individualId", role);


--
-- Name: Profession_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Profession_name_key" ON public."Profession" USING btree (name);


--
-- Name: Title_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Title_name_key" ON public."Title" USING btree (name);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Event Event_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Event"
    ADD CONSTRAINT "Event_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Event Event_parishId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Event"
    ADD CONSTRAINT "Event_parishId_fkey" FOREIGN KEY ("parishId") REFERENCES public."Parish"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Event Event_updatedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Event"
    ADD CONSTRAINT "Event_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Family Family_contextParishId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_contextParishId_fkey" FOREIGN KEY ("contextParishId") REFERENCES public."Parish"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Family Family_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Family Family_fatherId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_fatherId_fkey" FOREIGN KEY ("fatherId") REFERENCES public."Individual"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Family Family_marriageEventId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_marriageEventId_fkey" FOREIGN KEY ("marriageEventId") REFERENCES public."Event"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Family Family_motherId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_motherId_fkey" FOREIGN KEY ("motherId") REFERENCES public."Individual"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Family Family_updatedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Family"
    ADD CONSTRAINT "Family_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Individual Individual_contextParishId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual"
    ADD CONSTRAINT "Individual_contextParishId_fkey" FOREIGN KEY ("contextParishId") REFERENCES public."Parish"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Individual Individual_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual"
    ADD CONSTRAINT "Individual_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Individual Individual_familyOfOriginId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual"
    ADD CONSTRAINT "Individual_familyOfOriginId_fkey" FOREIGN KEY ("familyOfOriginId") REFERENCES public."Family"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Individual Individual_legitimacyStatusId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual"
    ADD CONSTRAINT "Individual_legitimacyStatusId_fkey" FOREIGN KEY ("legitimacyStatusId") REFERENCES public."LegitimacyStatus"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Individual Individual_updatedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Individual"
    ADD CONSTRAINT "Individual_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_contextParishId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_contextParishId_fkey" FOREIGN KEY ("contextParishId") REFERENCES public."Parish"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_deathPlaceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_deathPlaceId_fkey" FOREIGN KEY ("deathPlaceId") REFERENCES public."Place"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_eventId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES public."Event"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Participation Participation_individualId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_individualId_fkey" FOREIGN KEY ("individualId") REFERENCES public."Individual"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Participation Participation_kinshipId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_kinshipId_fkey" FOREIGN KEY ("kinshipId") REFERENCES public."Kinship"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_originId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_originId_fkey" FOREIGN KEY ("originId") REFERENCES public."Place"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_participationRoleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_participationRoleId_fkey" FOREIGN KEY ("participationRoleId") REFERENCES public."ParticipationRole"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_professionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_professionId_fkey" FOREIGN KEY ("professionId") REFERENCES public."Profession"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_residenceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_residenceId_fkey" FOREIGN KEY ("residenceId") REFERENCES public."Place"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_titleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_titleId_fkey" FOREIGN KEY ("titleId") REFERENCES public."Title"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Participation Participation_updatedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Participation"
    ADD CONSTRAINT "Participation_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Place Place_parishId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Place"
    ADD CONSTRAINT "Place_parishId_fkey" FOREIGN KEY ("parishId") REFERENCES public."Parish"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: User User_currentParishId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_currentParishId_fkey" FOREIGN KEY ("currentParishId") REFERENCES public."Parish"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict eoXdEdi4T4XfwqazlRjin2DtikbI2kOqOSUodsh38ume1WiWOI2aoMj35Qo21Be

