--
-- PostgreSQL database dump
--

\restrict PtY7zNxn2DH6P3kYnBO4TjasZhxSzsN4dsQYr62NlBA2WLQjnYV6B6jI7zLXYBN

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
-- Dumped by pg_dump version 17.6

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: dbcopymaster_zh9u_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO dbcopymaster_zh9u_user;

--
-- Name: comm_channel; Type: TYPE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TYPE public.comm_channel AS ENUM (
    'telefono',
    'email',
    'whatsapp',
    'portal',
    'presencial',
    'otro'
);


ALTER TYPE public.comm_channel OWNER TO dbcopymaster_zh9u_user;

--
-- Name: machine_status; Type: TYPE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TYPE public.machine_status AS ENUM (
    'bodega',
    'alquilada',
    'chatarrizada',
    'vendida'
);


ALTER TYPE public.machine_status OWNER TO dbcopymaster_zh9u_user;

--
-- Name: movement_type; Type: TYPE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TYPE public.movement_type AS ENUM (
    'ingreso',
    'salida',
    'traslado',
    'venta',
    'chatarrizacion',
    'retorno_alquiler',
    'otro'
);


ALTER TYPE public.movement_type OWNER TO dbcopymaster_zh9u_user;

--
-- Name: service_type; Type: TYPE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TYPE public.service_type AS ENUM (
    'correctivo',
    'preventivo',
    'diagnostico',
    'toner',
    'toma_contador',
    'otro'
);


ALTER TYPE public.service_type OWNER TO dbcopymaster_zh9u_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audits; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.audits (
    id bigint NOT NULL,
    table_name text,
    record_id bigint,
    action text,
    changed_by bigint,
    change_time timestamp with time zone DEFAULT now(),
    diff jsonb
);


ALTER TABLE public.audits OWNER TO dbcopymaster_zh9u_user;

--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audits_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.audits_id_seq OWNED BY public.audits.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    nit character varying(50),
    name text NOT NULL,
    contact_name text,
    phone character varying(30),
    email text,
    address text,
    created_at timestamp with time zone DEFAULT now(),
    location_id bigint
);


ALTER TABLE public.customers OWNER TO dbcopymaster_zh9u_user;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    code text,
    name text NOT NULL,
    description text,
    address text
);


ALTER TABLE public.locations OWNER TO dbcopymaster_zh9u_user;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: machine_movements; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.machine_movements (
    id bigint NOT NULL,
    machine_id bigint,
    from_location_id bigint,
    to_location_id bigint,
    movement_type character varying(50),
    effective_date timestamp with time zone DEFAULT now() NOT NULL,
    reason text,
    related_contract_id bigint,
    created_by_user_id bigint,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.machine_movements OWNER TO dbcopymaster_zh9u_user;

--
-- Name: machine_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.machine_movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.machine_movements_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: machine_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.machine_movements_id_seq OWNED BY public.machine_movements.id;


--
-- Name: machines; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.machines (
    id bigint NOT NULL,
    company_serial text,
    company_number text,
    model text,
    brand text,
    year smallint,
    current_location_id bigint,
    status character varying(50) DEFAULT 'bodega'::public.machine_status,
    current_contract_id bigint,
    current_customer_id bigint,
    purchase_date date,
    created_at timestamp with time zone DEFAULT now(),
    notes text
);


ALTER TABLE public.machines OWNER TO dbcopymaster_zh9u_user;

--
-- Name: machines_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.machines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.machines_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: machines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.machines_id_seq OWNED BY public.machines.id;


--
-- Name: meter_readings; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.meter_readings (
    id bigint NOT NULL,
    machine_id bigint,
    reading bigint NOT NULL,
    reading_date timestamp with time zone DEFAULT now() NOT NULL,
    technician_id bigint,
    notes text
);


ALTER TABLE public.meter_readings OWNER TO dbcopymaster_zh9u_user;

--
-- Name: meter_readings_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.meter_readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meter_readings_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: meter_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.meter_readings_id_seq OWNED BY public.meter_readings.id;


--
-- Name: parts; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.parts (
    id bigint NOT NULL,
    sku text,
    brand text,
    model_compatibility text,
    name text,
    part_type text,
    stock integer DEFAULT 0,
    unit_price numeric(12,2),
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.parts OWNER TO dbcopymaster_zh9u_user;

--
-- Name: parts_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parts_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.parts_id_seq OWNED BY public.parts.id;


--
-- Name: service_requests; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.service_requests (
    id bigint NOT NULL,
    request_number text,
    customer_id bigint,
    machine_id bigint,
    company_serial text,
    company_number text,
    created_by_user_id bigint,
    reported_at timestamp with time zone DEFAULT now(),
    reported_channel character varying,
    service_type character varying,
    description text,
    root_cause text,
    status text DEFAULT 'abierto'::text,
    is_repeated boolean DEFAULT false,
    repeated_of_request_id bigint,
    assigned_technician_id bigint,
    assigned_at timestamp with time zone,
    closed_at timestamp with time zone,
    resolution text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.service_requests OWNER TO dbcopymaster_zh9u_user;

--
-- Name: service_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.service_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_requests_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: service_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.service_requests_id_seq OWNED BY public.service_requests.id;


--
-- Name: service_visits; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.service_visits (
    id bigint NOT NULL,
    service_request_id bigint,
    visit_datetime timestamp with time zone DEFAULT now(),
    technician_id bigint,
    travel_time interval,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    visit_notes text,
    parts_used jsonb,
    meter_reading_before bigint,
    meter_reading_after bigint,
    solved boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    meter_reading_id bigint,
    updated_at timestamp without time zone
);


ALTER TABLE public.service_visits OWNER TO dbcopymaster_zh9u_user;

--
-- Name: service_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.service_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_visits_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: service_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.service_visits_id_seq OWNED BY public.service_visits.id;


--
-- Name: technicians; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.technicians (
    id bigint NOT NULL,
    identification character varying(50),
    full_name text NOT NULL,
    phone character varying(30),
    email text,
    address text,
    hire_date date,
    active boolean DEFAULT true,
    certifications text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.technicians OWNER TO dbcopymaster_zh9u_user;

--
-- Name: technicians_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.technicians_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technicians_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: technicians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.technicians_id_seq OWNED BY public.technicians.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.user_sessions (
    id bigint NOT NULL,
    user_id bigint,
    session_token text NOT NULL,
    ip_address inet,
    user_agent text,
    logged_in_at timestamp with time zone DEFAULT now(),
    logged_out_at timestamp with time zone,
    meta jsonb
);


ALTER TABLE public.user_sessions OWNER TO dbcopymaster_zh9u_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_sessions_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text NOT NULL,
    password_hash text NOT NULL,
    full_name text,
    role text,
    phone character varying(30),
    email text,
    identification character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    last_login_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO dbcopymaster_zh9u_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: visit_parts; Type: TABLE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE TABLE public.visit_parts (
    id bigint NOT NULL,
    service_visit_id bigint,
    part_id bigint,
    qty integer DEFAULT 1,
    serial_number text,
    cost numeric(12,2),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.visit_parts OWNER TO dbcopymaster_zh9u_user;

--
-- Name: visit_parts_id_seq; Type: SEQUENCE; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE SEQUENCE public.visit_parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visit_parts_id_seq OWNER TO dbcopymaster_zh9u_user;

--
-- Name: visit_parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER SEQUENCE public.visit_parts_id_seq OWNED BY public.visit_parts.id;


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.audits ALTER COLUMN id SET DEFAULT nextval('public.audits_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: machine_movements id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machine_movements ALTER COLUMN id SET DEFAULT nextval('public.machine_movements_id_seq'::regclass);


--
-- Name: machines id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machines ALTER COLUMN id SET DEFAULT nextval('public.machines_id_seq'::regclass);


--
-- Name: meter_readings id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.meter_readings ALTER COLUMN id SET DEFAULT nextval('public.meter_readings_id_seq'::regclass);


--
-- Name: parts id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.parts ALTER COLUMN id SET DEFAULT nextval('public.parts_id_seq'::regclass);


--
-- Name: service_requests id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests ALTER COLUMN id SET DEFAULT nextval('public.service_requests_id_seq'::regclass);


--
-- Name: service_visits id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_visits ALTER COLUMN id SET DEFAULT nextval('public.service_visits_id_seq'::regclass);


--
-- Name: technicians id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.technicians ALTER COLUMN id SET DEFAULT nextval('public.technicians_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: visit_parts id; Type: DEFAULT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.visit_parts ALTER COLUMN id SET DEFAULT nextval('public.visit_parts_id_seq'::regclass);


--
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.audits (id, table_name, record_id, action, changed_by, change_time, diff) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.customers (id, nit, name, contact_name, phone, email, address, created_at, location_id) FROM stdin;
1	860042737-1	ASOCIAMOS SA	Brian Alexander	3187684389	brianbastidas72@gmail.com	Cll 23 C no 96 G bis -30	2025-09-16 18:27:18.728834+00	\N
2	123456789	Café Ariari	María Molina	3146937667	cafeariaricubarral@gmail.com	Villavicencio, Meta	2025-09-17 19:48:05.5073+00	1
3	860042733	QULIMPORTA	Brian Alexander	3187684389	brianbastidas72@gmail.com	Cll 23 C no 96 G bis -30	2025-09-18 19:07:54.375054+00	3
4	901234567	Cliente Demo	Ana Gómez	3107654321	cliente.demo@example.com	Calle 123 #45-67	2025-09-19 13:43:10.74044+00	4
5	12425464575	importamos sas	3145547574	2342353	brianalbarracin528@gmail.com	Cll 23 C # 96 G bis 30	2025-09-20 16:14:07.193641+00	5
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.locations (id, code, name, description, address) FROM stdin;
1	\N	Café Ariari	Ubicación principal de Café Ariari	Villavicencio, Meta
2	\N	Bodega 1	Almacén principal	Zona Industrial
3	\N	QULIMPORTA	Ubicación principal de QULIMPORTA	Cll 23 C no 96 G bis -30
4	\N	Cliente Demo	Ubicación principal de Cliente Demo	Calle 123 #45-67
5	\N	importamos sas	Ubicación principal de importamos sas	Cll 23 C # 96 G bis 30
\.


--
-- Data for Name: machine_movements; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.machine_movements (id, machine_id, from_location_id, to_location_id, movement_type, effective_date, reason, related_contract_id, created_by_user_id, created_at) FROM stdin;
1	9	\N	2	INGRESO	2025-09-19 13:54:26.097867+00	Ubicación inicial	\N	1	\N
2	\N	\N	\N	\N	2025-09-19 13:56:37.527993+00	\N	\N	\N	\N
3	9	2	3	TRASLADO	2025-09-19 14:37:32.140067+00	Arriendo	\N	\N	\N
4	9	3	2	TRASLADO	2025-09-19 14:41:58.655188+00	manteniemiento	\N	\N	\N
5	9	2	1	TRASLADO	2025-09-20 14:36:39.849011+00	Arriendo	\N	\N	\N
6	9	1	2	TRASLADO	2025-09-20 14:39:02.699254+00	Manteniemiento	\N	\N	\N
7	9	2	4	TRASLADO	2025-09-20 14:39:47.548811+00	Arriendo	\N	\N	\N
8	6	2	3	TRASLADO	2025-09-20 14:48:19.288615+00	Manteniemirno	\N	\N	\N
17	6	3	1	TRASLADO	2025-09-20 16:10:22.139868+00		\N	\N	\N
18	10	\N	\N	INGRESO	2025-09-20 16:14:52.20278+00	Ubicación inicial	\N	1	2025-09-20 16:14:52.2028+00
19	10	\N	5	TRASLADO	2025-09-20 16:15:19.045709+00		\N	\N	\N
20	10	5	3	TRASLADO	2025-09-20 16:25:59.008941+00		\N	\N	\N
21	10	5	2	TRASLADO	2025-09-20 16:27:44.031359+00		\N	\N	\N
22	9	4	1	TRASLADO	2025-09-20 16:31:18.864737+00		\N	\N	\N
23	9	1	3	TRASLADO	2025-09-20 16:32:09.804561+00		\N	\N	\N
24	9	3	2	TRASLADO	2025-09-20 16:32:25.159387+00		\N	\N	\N
25	9	2	4	TRASLADO	2025-09-20 16:32:41.21037+00		\N	\N	\N
26	9	4	2	TRASLADO	2025-09-20 16:40:12.542563+00		\N	\N	\N
27	9	2	1	TRASLADO	2025-09-20 16:40:53.012607+00		\N	\N	\N
28	9	1	3	TRASLADO	2025-09-20 16:41:02.86155+00		\N	\N	\N
29	9	3	2	TRASLADO	2025-09-20 16:58:35.245223+00		\N	\N	\N
30	9	2	3	TRASLADO	2025-09-20 16:58:54.471337+00		\N	\N	\N
31	9	3	2	TRASLADO	2025-09-20 16:59:13.109259+00		\N	\N	\N
32	9	2	4	TRASLADO	2025-09-20 16:59:23.887399+00		\N	\N	\N
33	9	4	1	TRASLADO	2025-09-20 17:02:55.46735+00		\N	\N	\N
34	7	2	1	TRASLADO	2025-09-20 17:18:33.526326+00		\N	\N	\N
35	1	\N	2	TRASLADO	2025-09-20 17:19:07.43478+00		\N	\N	\N
36	10	2	3	TRASLADO	2025-09-20 23:28:19.28151+00		\N	\N	\N
37	1	2	4	TRASLADO	2025-09-20 23:33:02.727686+00		\N	\N	\N
38	7	1	2	TRASLADO	2025-09-20 23:47:47.476124+00		\N	\N	\N
39	7	2	1	TRASLADO	2025-09-20 23:47:53.909784+00		\N	\N	\N
40	6	1	3	TRASLADO	2025-09-20 23:49:45.700409+00		\N	\N	\N
41	7	1	3	TRASLADO	2025-09-20 23:49:58.392768+00		\N	\N	\N
42	1	4	3	TRASLADO	2025-09-21 20:01:40.35203+00		\N	\N	\N
43	2	\N	5	TRASLADO	2025-09-21 20:51:55.569285+00		\N	\N	\N
\.


--
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.machines (id, company_serial, company_number, model, brand, year, current_location_id, status, current_contract_id, current_customer_id, purchase_date, created_at, notes) FROM stdin;
1	123	ABC-456	X500	Canon	2024	3	BODEGA	\N	3	\N	2025-09-17 14:29:55.89877+00	Máquina de prueba creada desde Postman
2	weqrqf14124	231wewd	301	RICOH	2025	5	BODEGA	\N	5	\N	2025-09-17 15:21:54.502024+00	
9	RIC-NEW-2025	002	GX-500	Kubota	2025	1	BODEGA	\N	2	\N	2025-09-19 13:54:25.133344+00	Máquina de prueba desde Postman
10	q23req3rq3r	qw114142	456	RICOH	2024	3	BODEGA	\N	3	\N	2025-09-20 16:14:52.112463+00	
6	21311	241535	301	TOSGIBA	2025	3	BODEGA	\N	3	\N	2025-09-18 19:07:08.543567+00	
7	RIC-XYZ-2025	M-003	Ricoh MP 305	Ricoh	2024	3	BODEGA	\N	3	\N	2025-09-19 13:44:35.420373+00	Máquina entregada al Cliente Demo
\.


--
-- Data for Name: meter_readings; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.meter_readings (id, machine_id, reading, reading_date, technician_id, notes) FROM stdin;
1	1	0	2025-09-17 14:30:00.064693+00	\N	Lectura inicial de instalación
2	2	100000	2025-09-17 15:21:55.401559+00	\N	
4	6	100000	2025-09-18 19:07:09.063572+00	\N	
5	9	0	2025-09-19 13:54:25.782874+00	\N	Lectura inicial Postman
6	10	10000000	2025-09-20 16:14:52.257639+00	\N	
7	1	12345	2025-09-22 17:24:44.787907+00	2	Lectura tomada después del ajuste
8	1	12345	2025-09-22 17:32:24.278698+00	2	Lectura tomada después del ajuste
9	1	50000	2025-09-23 15:17:42.098581+00	\N	\N
10	1	60000	2025-09-23 16:15:43.530605+00	1	\N
11	1	2500	2025-09-23 16:26:29.468064+00	2	Lectura tomada al finalizar la visita
12	1	2500	2025-09-23 16:28:26.731448+00	1	Lectura tomada al finalizar la visita
13	1	2500	2025-09-23 16:28:41.853845+00	1	Lectura tomada al finalizar la visita
14	7	125000	2025-09-23 18:50:12.474697+00	\N	\N
15	7	25000	2025-09-23 18:56:11.452532+00	\N	\N
\.


--
-- Data for Name: parts; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.parts (id, sku, brand, model_compatibility, name, part_type, stock, unit_price, notes, created_at) FROM stdin;
1	RICOH-DRUM-2018	RICOH	{"brands":["RICOH"],"models":["Aficio 2018","MP2554"]}	Cilindro fotosensible	cilindro	10	120.00	Cilindro OPC para Ricoh Aficio 2018/MP2554	2025-09-14 00:28:48.735464+00
2	TOSHIBA-DRUM-223	TOSHIBA	{"brands":["TOSHIBA"],"models":["e-Studio 223","e-Studio 283"]}	Cilindro fotosensible	cilindro	8	135.00	Drum Toshiba e-Studio 223/283	2025-09-14 00:28:48.735464+00
3	GEN-BLADE-01	GENERIC	{"brands":["RICOH","TOSHIBA"]}	Cuchilla de limpieza	cuchilla	20	15.00	Cleaning blade universal	2025-09-14 00:28:48.735464+00
4	GEN-FUSER-01	GENERIC	{"brands":["RICOH","TOSHIBA"]}	Unidad de Fuser	fuser	5	250.00	Fuser assembly	2025-09-14 00:28:48.735464+00
5	GEN-TONER-RIC2018	RICOH	{"brands":["RICOH"],"models":["Aficio 2018"]}	Cartucho de toner	toner	50	25.00	Toner negro Ricoh Aficio 2018	2025-09-14 00:28:48.735464+00
6	GEN-TONER-TOSH223	TOSHIBA	{"brands":["TOSHIBA"],"models":["e-Studio 223"]}	Cartucho de toner	toner	40	28.00	Toner negro Toshiba 223	2025-09-14 00:28:48.735464+00
7	GEN-ROLLER-01	GENERIC	{"brands":["RICOH","TOSHIBA"]}	Rodillo de transferencia	roller	30	12.00	Rubber roller	2025-09-14 00:28:48.735464+00
8	GEN-SENSOR-01	GENERIC	{"brands":["RICOH","TOSHIBA"]}	Sensor de papel	sensor	15	18.00	Paper jam sensor universal	2025-09-14 00:28:48.735464+00
\.


--
-- Data for Name: service_requests; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.service_requests (id, request_number, customer_id, machine_id, company_serial, company_number, created_by_user_id, reported_at, reported_channel, service_type, description, root_cause, status, is_repeated, repeated_of_request_id, assigned_technician_id, assigned_at, closed_at, resolution, created_at) FROM stdin;
3	SR-1758485018677	3	7	\N	\N	\N	2025-09-21 20:03:38.67724+00	whatsapp	diagnostico	qrewgwrgw	La maquina presenta inconvenientes en la unidad fusora	abierto	t	2	\N	2025-09-21 20:03:38.94025+00	\N	\N	2025-09-21 20:03:38.677276+00
4	SR-1758485063435	2	9	\N	\N	\N	2025-09-21 20:04:23.435828+00	email	toma_contador	qrrqfafeaadf	La maquina presenta inconvenientes en la unidad fusora	abierto	f	\N	\N	2025-09-21 20:04:23.496659+00	\N	\N	2025-09-21 20:04:23.435855+00
5	SR-1758487966564	5	2	\N	\N	\N	2025-09-21 20:52:46.564618+00	email	toner	No se con que llenarlo	La maquina presenta inconvenientes en la unidad fusora	abierto	f	\N	\N	2025-09-21 20:52:46.627779+00	\N	\N	2025-09-21 20:52:46.564674+00
2	SR-1758476431442	3	7	\N	\N	\N	2025-09-21 17:40:31.443114+00	telefono	correctivo	adafefaefa	La maquina presenta inconvenientes en la unidad fusora	EN_PROCESO	f	\N	\N	2025-09-21 17:40:31.882799+00	\N	\N	2025-09-21 17:40:31.443183+00
1	SR-1758474656899	3	10	\N	\N	\N	2025-09-21 17:10:56.900672+00	telefono	correctivo	La máquina se atasca cada vez que imprime más de 50 hojas.	Atasco recurrente	resuelto	f	\N	\N	2025-09-21 17:10:57.604119+00	\N	\N	2025-09-21 17:10:56.900672+00
\.


--
-- Data for Name: service_visits; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.service_visits (id, service_request_id, visit_datetime, technician_id, travel_time, start_time, end_time, visit_notes, parts_used, meter_reading_before, meter_reading_after, solved, created_at, meter_reading_id, updated_at) FROM stdin;
4	1	2025-09-22 21:00:00+00	2	\N	\N	\N	No quiere ir	\N	\N	\N	f	2025-09-22 21:00:26.267636+00	\N	\N
2	1	2025-09-23 14:30:00+00	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-09-22 20:31:58.255116+00	10	\N
1	1	2025-09-22 17:21:04.230781+00	1	\N	\N	\N	Se tomó lectura y se ajustó el fusor	{"fusor": 1, "rodillo": 2}	\N	\N	f	2025-09-22 17:21:04.230781+00	13	\N
5	2	2025-09-22 21:11:00+00	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-09-22 21:12:06.038734+00	15	\N
3	1	2025-09-22 20:39:00+00	\N	\N	\N	\N	\N	{"1": 1, "3": 1}	\N	\N	f	2025-09-22 20:40:11.382181+00	\N	\N
\.


--
-- Data for Name: technicians; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.technicians (id, identification, full_name, phone, email, address, hire_date, active, certifications, created_at) FROM stdin;
1	12321424	Brian Alexander	3187684389	brianbastidas72@gmail.com	\N	\N	t	\N	\N
2	321442	Alejandro Estrada	2106001943	alejoveinte72@gmail.com	\N	\N	t	\N	\N
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.user_sessions (id, user_id, session_token, ip_address, user_agent, logged_in_at, logged_out_at, meta) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.users (id, username, password_hash, full_name, role, phone, email, identification, created_at, last_login_at) FROM stdin;
1	admin	$2a$10$r8Z5R6S7T8U9V0W1X2Y3Z4A5B6C7D8E9F0G1H2I3J4K5L6M7N8O9P0Q	Administrador General	admin	3001234567	admin@copymaster.com	CC123456	2025-09-14 20:19:26.756036+00	\N
4	jose	$2a$10$uHmtOT5vCv6E5bM6QQi2UOCxmm6ZbPYk6cU0RmBZTq/vlmsU5uN5C	José Pérez	admin	3001234567	jose@example.com	\N	2025-09-15 14:31:30.980992+00	\N
5	maria	$2a$10$xKiXdCGd2Le5ZwsfArJBG.svv57vOGTwoJ9sEY2tVAQ7LsBbJBQ8i	María Pérez	admin	3009876543	maria@example.com	\N	2025-09-15 14:40:31.032761+00	\N
\.


--
-- Data for Name: visit_parts; Type: TABLE DATA; Schema: public; Owner: dbcopymaster_zh9u_user
--

COPY public.visit_parts (id, service_visit_id, part_id, qty, serial_number, cost, created_at) FROM stdin;
\.


--
-- Name: audits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.audits_id_seq', 1, false);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.customers_id_seq', 5, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.locations_id_seq', 5, true);


--
-- Name: machine_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.machine_movements_id_seq', 43, true);


--
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.machines_id_seq', 10, true);


--
-- Name: meter_readings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.meter_readings_id_seq', 15, true);


--
-- Name: parts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.parts_id_seq', 8, true);


--
-- Name: service_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.service_requests_id_seq', 5, true);


--
-- Name: service_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.service_visits_id_seq', 5, true);


--
-- Name: technicians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.technicians_id_seq', 2, true);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: visit_parts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbcopymaster_zh9u_user
--

SELECT pg_catalog.setval('public.visit_parts_id_seq', 1, false);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: customers customers_location_id_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_location_id_key UNIQUE (location_id);


--
-- Name: customers customers_nit_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_nit_key UNIQUE (nit);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: locations locations_code_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_code_key UNIQUE (code);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: machine_movements machine_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machine_movements
    ADD CONSTRAINT machine_movements_pkey PRIMARY KEY (id);


--
-- Name: machines machines_company_number_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_company_number_key UNIQUE (company_number);


--
-- Name: machines machines_company_serial_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_company_serial_key UNIQUE (company_serial);


--
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- Name: meter_readings meter_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.meter_readings
    ADD CONSTRAINT meter_readings_pkey PRIMARY KEY (id);


--
-- Name: parts parts_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.parts
    ADD CONSTRAINT parts_pkey PRIMARY KEY (id);


--
-- Name: parts parts_sku_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.parts
    ADD CONSTRAINT parts_sku_key UNIQUE (sku);


--
-- Name: service_requests service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_pkey PRIMARY KEY (id);


--
-- Name: service_requests service_requests_request_number_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_request_number_key UNIQUE (request_number);


--
-- Name: service_visits service_visits_meter_reading_id_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_visits
    ADD CONSTRAINT service_visits_meter_reading_id_key UNIQUE (meter_reading_id);


--
-- Name: service_visits service_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_visits
    ADD CONSTRAINT service_visits_pkey PRIMARY KEY (id);


--
-- Name: technicians technicians_identification_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_identification_key UNIQUE (identification);


--
-- Name: technicians technicians_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: visit_parts visit_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.visit_parts
    ADD CONSTRAINT visit_parts_pkey PRIMARY KEY (id);


--
-- Name: machine_movements_effective_date_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX machine_movements_effective_date_idx ON public.machine_movements USING btree (effective_date);


--
-- Name: machine_movements_machine_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX machine_movements_machine_id_idx ON public.machine_movements USING btree (machine_id);


--
-- Name: machines_company_number_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX machines_company_number_idx ON public.machines USING btree (company_number);


--
-- Name: machines_company_serial_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX machines_company_serial_idx ON public.machines USING btree (company_serial);


--
-- Name: machines_current_customer_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX machines_current_customer_id_idx ON public.machines USING btree (current_customer_id);


--
-- Name: machines_current_location_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX machines_current_location_id_idx ON public.machines USING btree (current_location_id);


--
-- Name: meter_readings_machine_id_reading_date_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX meter_readings_machine_id_reading_date_idx ON public.meter_readings USING btree (machine_id, reading_date DESC);


--
-- Name: parts_part_type_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX parts_part_type_idx ON public.parts USING btree (part_type);


--
-- Name: service_requests_customer_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_requests_customer_id_idx ON public.service_requests USING btree (customer_id);


--
-- Name: service_requests_machine_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_requests_machine_id_idx ON public.service_requests USING btree (machine_id);


--
-- Name: service_requests_reported_at_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_requests_reported_at_idx ON public.service_requests USING btree (reported_at);


--
-- Name: service_requests_root_cause_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_requests_root_cause_idx ON public.service_requests USING btree (root_cause);


--
-- Name: service_requests_service_type_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_requests_service_type_idx ON public.service_requests USING btree (service_type);


--
-- Name: service_visits_service_request_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_visits_service_request_id_idx ON public.service_visits USING btree (service_request_id);


--
-- Name: service_visits_technician_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX service_visits_technician_id_idx ON public.service_visits USING btree (technician_id);


--
-- Name: user_sessions_logged_in_at_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX user_sessions_logged_in_at_idx ON public.user_sessions USING btree (logged_in_at);


--
-- Name: user_sessions_user_id_idx; Type: INDEX; Schema: public; Owner: dbcopymaster_zh9u_user
--

CREATE INDEX user_sessions_user_id_idx ON public.user_sessions USING btree (user_id);


--
-- Name: audits audits_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: customers fk_customers_locations; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customers_locations FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: service_visits fk_service_visits_meter_readings; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_visits
    ADD CONSTRAINT fk_service_visits_meter_readings FOREIGN KEY (meter_reading_id) REFERENCES public.meter_readings(id);


--
-- Name: machine_movements machine_movements_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machine_movements
    ADD CONSTRAINT machine_movements_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- Name: machine_movements machine_movements_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machine_movements
    ADD CONSTRAINT machine_movements_from_location_id_fkey FOREIGN KEY (from_location_id) REFERENCES public.locations(id);


--
-- Name: machine_movements machine_movements_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machine_movements
    ADD CONSTRAINT machine_movements_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id) ON DELETE CASCADE;


--
-- Name: machine_movements machine_movements_to_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machine_movements
    ADD CONSTRAINT machine_movements_to_location_id_fkey FOREIGN KEY (to_location_id) REFERENCES public.locations(id);


--
-- Name: machines machines_current_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_current_customer_id_fkey FOREIGN KEY (current_customer_id) REFERENCES public.customers(id);


--
-- Name: machines machines_current_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_current_location_id_fkey FOREIGN KEY (current_location_id) REFERENCES public.locations(id);


--
-- Name: meter_readings meter_readings_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.meter_readings
    ADD CONSTRAINT meter_readings_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id) ON DELETE CASCADE;


--
-- Name: meter_readings meter_readings_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.meter_readings
    ADD CONSTRAINT meter_readings_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: service_requests service_requests_assigned_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_assigned_technician_id_fkey FOREIGN KEY (assigned_technician_id) REFERENCES public.technicians(id);


--
-- Name: service_requests service_requests_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- Name: service_requests service_requests_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: service_requests service_requests_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id);


--
-- Name: service_visits service_visits_service_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_visits
    ADD CONSTRAINT service_visits_service_request_id_fkey FOREIGN KEY (service_request_id) REFERENCES public.service_requests(id) ON DELETE CASCADE;


--
-- Name: service_visits service_visits_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.service_visits
    ADD CONSTRAINT service_visits_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.technicians(id);


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: visit_parts visit_parts_part_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.visit_parts
    ADD CONSTRAINT visit_parts_part_id_fkey FOREIGN KEY (part_id) REFERENCES public.parts(id);


--
-- Name: visit_parts visit_parts_service_visit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbcopymaster_zh9u_user
--

ALTER TABLE ONLY public.visit_parts
    ADD CONSTRAINT visit_parts_service_visit_id_fkey FOREIGN KEY (service_visit_id) REFERENCES public.service_visits(id) ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO dbcopymaster_zh9u_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO dbcopymaster_zh9u_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO dbcopymaster_zh9u_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO dbcopymaster_zh9u_user;


--
-- PostgreSQL database dump complete
--

\unrestrict PtY7zNxn2DH6P3kYnBO4TjasZhxSzsN4dsQYr62NlBA2WLQjnYV6B6jI7zLXYBN

