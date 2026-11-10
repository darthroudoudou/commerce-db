
-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-28 18:22:03

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16388)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    label character varying(50) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16393)
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_id_seq OWNER TO postgres;

--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- TOC entry 221 (class 1259 OID 16394)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    email character varying(100),
    city character varying(50) NOT NULL,
    registration_date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16403)
-- Name: client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_id_seq OWNER TO postgres;

--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 222
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.client.id;


--
-- TOC entry 223 (class 1259 OID 16404)
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    email character varying(100),
    login character varying(20) NOT NULL
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16411)
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_id_seq OWNER TO postgres;

--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 224
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;


--
-- TOC entry 225 (class 1259 OID 16412)
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT order_item_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16420)
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_item_id_seq OWNER TO postgres;

--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_item_id_seq OWNED BY public.order_item.id;


--
-- TOC entry 227 (class 1259 OID 16421)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    client_id integer NOT NULL,
    order_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'en_cours'::character varying NOT NULL,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY (ARRAY[('en_cours'::character varying)::text, ('expediee'::character varying)::text, ('livree'::character varying)::text, ('annulee'::character varying)::text])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16431)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 228
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 229 (class 1259 OID 16432)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id integer NOT NULL,
    reference character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    category_id integer NOT NULL,
    supplier_id integer,
    CONSTRAINT product_stock_check CHECK ((stock >= 0)),
    CONSTRAINT product_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16446)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_id_seq OWNER TO postgres;

--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 230
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- TOC entry 231 (class 1259 OID 16447)
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    id integer NOT NULL,
    supplier_name character varying(100),
    is_local boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    email character varying(100)
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16455)
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_id_seq OWNER TO postgres;

--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 232
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_id_seq OWNED BY public.supplier.id;


--
-- TOC entry 3319 (class 2604 OID 16456)
-- Name: category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 16457)
-- Name: client id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- TOC entry 3322 (class 2604 OID 16458)
-- Name: employee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN id SET DEFAULT nextval('public.employee_id_seq'::regclass);


--
-- TOC entry 3323 (class 2604 OID 16459)
-- Name: order_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item ALTER COLUMN id SET DEFAULT nextval('public.order_item_id_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 16460)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 16461)
-- Name: product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 16462)
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN id SET DEFAULT nextval('public.supplier_id_seq'::regclass);


--
-- TOC entry 3515 (class 0 OID 16388)
-- Dependencies: 219
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, label) FROM stdin;
1	Électronique
2	Mobilier
3	Papeterie
4	Alimentation
5	Plomberie
6	Informatique
7	Médical
\.


--
-- TOC entry 3517 (class 0 OID 16394)
-- Dependencies: 221
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (id, last_name, first_name, email, city, registration_date) FROM stdin;
1	Dupont	Marie	marie.dupont@email.fr	Lyon	2024-09-12
2	Martin	Julien	julien.martin@email.fr	Paris	2024-10-03
3	Bernard	Sophie	\N	Lyon	2024-11-20
4	Petit	Thomas	thomas.petit@email.fr	Marseille	2025-01-15
5	Durand	Emma	emma.durand@email.fr	Paris	2025-03-08
6	Moreau	Lucas	lucas.moreau@email.fr	Nantes	2025-06-21
7	Burgun	Frederic	frederic.burgun@email.fr	Nice	2026-11-03
8	Duchmoll	Julien	julien.duchmoll@email.fr	Perpignan	2024-10-03
9	Vader	Darth	darthvader@email.fr	Tatooine	2024-11-20
10	Grand	Thomas	thomasgrand@email.fr	Pointe-à-Pitre	2025-01-15
11	Durand	Emma	emmadurand@autreemail.fr	Paris	2023-10-08
\.


--
-- TOC entry 3519 (class 0 OID 16404)
-- Dependencies: 223
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (id, last_name, first_name, email, login) FROM stdin;
1	Martin	Claire	claire.martin@boutique.fr	cmartin
2	Lefevre	Antoine	antoine.lefevre@boutique.fr	alefevre
3	Nguyen	Linh	linh.nguyen@boutique.fr	lnguyen
4	Roux	Bastien	bastien.roux@boutique.fr	broux
5	Zimmer	Marie	\N	mzimmer
\.


--
-- TOC entry 3521 (class 0 OID 16412)
-- Dependencies: 225
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, order_id, product_id, quantity) FROM stdin;
1	1	1	2
2	1	6	5
3	2	2	1
4	2	5	1
5	3	4	2
6	3	7	3
7	4	9	1
8	5	8	4
9	5	1	1
10	6	6	10
11	6	7	2
12	7	2	1
13	8	5	2
14	8	8	2
15	9	9	1
16	9	1	3
17	10	4	1
18	11	6	8
19	11	8	1
20	11	11	10
21	12	2	2
22	12	5	1
\.


--
-- TOC entry 3523 (class 0 OID 16421)
-- Dependencies: 227
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, client_id, order_date, status) FROM stdin;
1	1	2025-02-10	livree
2	1	2025-03-05	livree
3	2	2025-04-18	livree
4	3	2025-05-02	annulee
5	2	2025-06-14	expediee
6	4	2025-09-30	livree
7	5	2025-11-11	en_cours
8	5	2025-12-24	en_cours
9	6	2026-01-19	expediee
10	3	2026-02-08	livree
11	1	2026-03-12	en_cours
12	2	2026-04-25	expediee
\.


--
-- TOC entry 3525 (class 0 OID 16432)
-- Dependencies: 229
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, reference, name, unit_price, stock, active, category_id, supplier_id) FROM stdin;
1	P-001	Clé USB 32 Go	12.90	45	t	1	\N
2	P-002	Casque audio	59.99	12	t	1	\N
3	P-003	Souris sans fil	24.50	0	t	1	\N
4	P-004	Chaise de bureau	149.00	8	t	2	\N
5	P-005	Lampe LED	29.90	25	t	2	\N
6	P-006	Ramette papier A4	4.99	200	t	3	\N
7	P-007	Stylo bille (lot de 10)	3.50	150	t	3	\N
8	P-008	Café en grains 1 kg	18.50	30	t	4	\N
9	P-009	Écran 24 pouces	189.00	4	t	1	\N
10	P-010	Bureau réglable	449.00	2	f	2	\N
11	P-011	Tuyau PVC diamètre 10cm longueur 2m	15.99	50	t	5	3
12	P-013	Tuyau PVC diamètre 5cm longueur 2m	22.99	300	t	5	3
13	P-014	Cable HDMI	5.00	1000	t	1	1
14	P-015	Cable coaxial	5.00	100	f	1	\N
\.


--
-- TOC entry 3527 (class 0 OID 16447)
-- Dependencies: 231
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier (id, supplier_name, is_local, is_active, email) FROM stdin;
1	Amazon	f	t	amazon@amazon.com
2	Microsoft	f	t	satya.nadella@microsoft.com
3	Plomberie Mario	f	t	itsame@gmail.com
4	CDiscount	f	t	\N
5	Legallais	f	t	\N
6	Leroy Merlin	f	t	\N
7	Lapeyre	f	t	\N
8	Kiloutou	f	t	\N
\.

--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 7, true);


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 222
-- Name: client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_id_seq', 11, true);


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 224
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_id_seq', 5, true);


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_item_id_seq', 22, true);


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 228
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 12, true);


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 230
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_seq', 14, true);


--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 232
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_id_seq', 8, true);


--
-- TOC entry 3338 (class 2606 OID 16464)
-- Name: category category_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_label_key UNIQUE (label);


--
-- TOC entry 3340 (class 2606 OID 16466)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 16468)
-- Name: client client_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_email_key UNIQUE (email);


--
-- TOC entry 3344 (class 2606 OID 16470)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 16472)
-- Name: employee employee_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_email_key UNIQUE (email);


--
-- TOC entry 3348 (class 2606 OID 16474)
-- Name: employee employee_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_login_key UNIQUE (login);


--
-- TOC entry 3350 (class 2606 OID 16476)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 16478)
-- Name: order_item order_item_order_product_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_product_key UNIQUE (order_id, product_id);


--
-- TOC entry 3354 (class 2606 OID 16480)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 3356 (class 2606 OID 16482)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 16484)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 16486)
-- Name: product product_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_reference_key UNIQUE (reference);


--
-- TOC entry 3362 (class 2606 OID 16488)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 16489)
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 3364 (class 2606 OID 16494)
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- TOC entry 3365 (class 2606 OID 16499)
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(id) ON DELETE RESTRICT;


--
-- TOC entry 3366 (class 2606 OID 16504)
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- TOC entry 3367 (class 2606 OID 16509)
-- Name: product product_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


-- Completed on 2026-10-28 18:22:03


