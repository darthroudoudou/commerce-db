
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
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 3566
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 239 (class 1255 OID 24742)
-- Name: archive_deleted_product(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.archive_deleted_product() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO product_archive (product_id, reference, name, unit_price, stock,
active, category_id, supplier_id)
VALUES (OLD.id, OLD.reference, OLD.name, OLD.unit_price, OLD.stock,
OLD.active, OLD.category_id, OLD.supplier_id);
RETURN OLD;
END; $$;


ALTER FUNCTION public.archive_deleted_product() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 24702)
-- Name: fn_normalize_client_email(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_normalize_client_email() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.email IS NOT NULL THEN
        NEW.email := lower(NEW.email);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_normalize_client_email() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 24720)
-- Name: log_price_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_price_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO product_price_history (product_id, old_price, new_price)
VALUES (NEW.id, OLD.unit_price, NEW.unit_price);
RETURN NEW;
END; $$;


ALTER FUNCTION public.log_price_change() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 24744)
-- Name: warn_low_stock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.warn_low_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
RAISE WARNING 'Stock bas : le produit % n a plus que % unités', NEW.name,
NEW.stock;
RETURN NEW;
END; $$;


ALTER FUNCTION public.warn_low_stock() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16384)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    label character varying(50) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16389)
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
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- TOC entry 221 (class 1259 OID 16390)
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
-- TOC entry 222 (class 1259 OID 16399)
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
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 222
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.client.id;


--
-- TOC entry 223 (class 1259 OID 16400)
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
-- TOC entry 224 (class 1259 OID 16407)
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
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 224
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;


--
-- TOC entry 225 (class 1259 OID 16408)
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    employee_id integer,
    CONSTRAINT order_item_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16416)
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
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_item_id_seq OWNED BY public.order_item.id;


--
-- TOC entry 227 (class 1259 OID 16417)
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
-- TOC entry 228 (class 1259 OID 16427)
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
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 228
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 229 (class 1259 OID 16428)
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
-- TOC entry 234 (class 1259 OID 24705)
-- Name: product_archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_archive (
    id integer NOT NULL,
    product_id integer NOT NULL,
    reference character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    active boolean NOT NULL,
    category_id integer,
    supplier_id integer,
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product_archive OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 24704)
-- Name: product_archive_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_archive_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_archive_id_seq OWNER TO postgres;

--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 233
-- Name: product_archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_archive_id_seq OWNED BY public.product_archive.id;


--
-- TOC entry 230 (class 1259 OID 16442)
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
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 230
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- TOC entry 236 (class 1259 OID 24723)
-- Name: product_price_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_price_history (
    id integer NOT NULL,
    product_id integer NOT NULL,
    old_price numeric(10,2) NOT NULL,
    new_price numeric(10,2) NOT NULL,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.product_price_history OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 24722)
-- Name: product_price_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_price_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_price_history_id_seq OWNER TO postgres;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 235
-- Name: product_price_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_price_history_id_seq OWNED BY public.product_price_history.id;


--
-- TOC entry 231 (class 1259 OID 16443)
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
-- TOC entry 232 (class 1259 OID 16451)
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
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 232
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_id_seq OWNED BY public.supplier.id;


--
-- TOC entry 3333 (class 2604 OID 16452)
-- Name: category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- TOC entry 3334 (class 2604 OID 16453)
-- Name: client id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- TOC entry 3336 (class 2604 OID 16454)
-- Name: employee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN id SET DEFAULT nextval('public.employee_id_seq'::regclass);


--
-- TOC entry 3337 (class 2604 OID 16455)
-- Name: order_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item ALTER COLUMN id SET DEFAULT nextval('public.order_item_id_seq'::regclass);


--
-- TOC entry 3338 (class 2604 OID 16456)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3341 (class 2604 OID 16457)
-- Name: product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- TOC entry 3347 (class 2604 OID 24708)
-- Name: product_archive id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_archive ALTER COLUMN id SET DEFAULT nextval('public.product_archive_id_seq'::regclass);


--
-- TOC entry 3349 (class 2604 OID 24726)
-- Name: product_price_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history ALTER COLUMN id SET DEFAULT nextval('public.product_price_history_id_seq'::regclass);


--
-- TOC entry 3344 (class 2604 OID 16458)
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN id SET DEFAULT nextval('public.supplier_id_seq'::regclass);


--
-- TOC entry 3543 (class 0 OID 16384)
-- Dependencies: 219
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.category VALUES (1, 'Électronique');
INSERT INTO public.category VALUES (2, 'Mobilier');
INSERT INTO public.category VALUES (3, 'Papeterie');
INSERT INTO public.category VALUES (4, 'Alimentation');
INSERT INTO public.category VALUES (5, 'Plomberie');
INSERT INTO public.category VALUES (6, 'Informatique');
INSERT INTO public.category VALUES (7, 'Médical');


--
-- TOC entry 3545 (class 0 OID 16390)
-- Dependencies: 221
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client VALUES (1, 'Dupont', 'Marie', 'marie.dupont@email.fr', 'Lyon', '2024-09-12');
INSERT INTO public.client VALUES (2, 'Martin', 'Julien', 'julien.martin@email.fr', 'Paris', '2024-10-03');
INSERT INTO public.client VALUES (3, 'Bernard', 'Sophie', NULL, 'Lyon', '2024-11-20');
INSERT INTO public.client VALUES (4, 'Petit', 'Thomas', 'thomas.petit@email.fr', 'Marseille', '2025-01-15');
INSERT INTO public.client VALUES (5, 'Durand', 'Emma', 'emma.durand@email.fr', 'Paris', '2025-03-08');
INSERT INTO public.client VALUES (6, 'Moreau', 'Lucas', 'lucas.moreau@email.fr', 'Nantes', '2025-06-21');
INSERT INTO public.client VALUES (7, 'Burgun', 'Frederic', 'frederic.burgun@email.fr', 'Nice', '2026-11-03');
INSERT INTO public.client VALUES (8, 'Duchmoll', 'Julien', 'julien.duchmoll@email.fr', 'Perpignan', '2024-10-03');
INSERT INTO public.client VALUES (9, 'Vader', 'Darth', 'darthvader@email.fr', 'Tatooine', '2024-11-20');
INSERT INTO public.client VALUES (10, 'Grand', 'Thomas', 'thomasgrand@email.fr', 'Pointe-à-Pitre', '2025-01-15');
INSERT INTO public.client VALUES (11, 'Durand', 'Emma', 'emmadurand@autreemail.fr', 'Paris', '2023-10-08');


--
-- TOC entry 3547 (class 0 OID 16400)
-- Dependencies: 223
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employee VALUES (1, 'Martin', 'Claire', 'claire.martin@boutique.fr', 'cmartin');
INSERT INTO public.employee VALUES (2, 'Lefevre', 'Antoine', 'antoine.lefevre@boutique.fr', 'alefevre');
INSERT INTO public.employee VALUES (3, 'Nguyen', 'Linh', 'linh.nguyen@boutique.fr', 'lnguyen');
INSERT INTO public.employee VALUES (4, 'Roux', 'Bastien', 'bastien.roux@boutique.fr', 'broux');
INSERT INTO public.employee VALUES (5, 'Zimmer', 'Marie', NULL, 'mzimmer');


--
-- TOC entry 3549 (class 0 OID 16408)
-- Dependencies: 225
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_item VALUES (1, 1, 1, 2, NULL);
INSERT INTO public.order_item VALUES (2, 1, 6, 5, NULL);
INSERT INTO public.order_item VALUES (3, 2, 2, 1, NULL);
INSERT INTO public.order_item VALUES (4, 2, 5, 1, NULL);
INSERT INTO public.order_item VALUES (5, 3, 4, 2, NULL);
INSERT INTO public.order_item VALUES (6, 3, 7, 3, NULL);
INSERT INTO public.order_item VALUES (7, 4, 9, 1, NULL);
INSERT INTO public.order_item VALUES (8, 5, 8, 4, NULL);
INSERT INTO public.order_item VALUES (9, 5, 1, 1, NULL);
INSERT INTO public.order_item VALUES (10, 6, 6, 10, NULL);
INSERT INTO public.order_item VALUES (11, 6, 7, 2, NULL);
INSERT INTO public.order_item VALUES (12, 7, 2, 1, NULL);
INSERT INTO public.order_item VALUES (13, 8, 5, 2, NULL);
INSERT INTO public.order_item VALUES (14, 8, 8, 2, NULL);
INSERT INTO public.order_item VALUES (15, 9, 9, 1, NULL);
INSERT INTO public.order_item VALUES (16, 9, 1, 3, NULL);
INSERT INTO public.order_item VALUES (17, 10, 4, 1, NULL);
INSERT INTO public.order_item VALUES (18, 11, 6, 8, NULL);
INSERT INTO public.order_item VALUES (19, 11, 8, 1, NULL);
INSERT INTO public.order_item VALUES (20, 11, 11, 10, NULL);
INSERT INTO public.order_item VALUES (21, 12, 2, 2, NULL);
INSERT INTO public.order_item VALUES (22, 12, 5, 1, NULL);


--
-- TOC entry 3551 (class 0 OID 16417)
-- Dependencies: 227
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders VALUES (1, 1, '2025-02-10', 'livree');
INSERT INTO public.orders VALUES (2, 1, '2025-03-05', 'livree');
INSERT INTO public.orders VALUES (3, 2, '2025-04-18', 'livree');
INSERT INTO public.orders VALUES (4, 3, '2025-05-02', 'annulee');
INSERT INTO public.orders VALUES (5, 2, '2025-06-14', 'expediee');
INSERT INTO public.orders VALUES (6, 4, '2025-09-30', 'livree');
INSERT INTO public.orders VALUES (7, 5, '2025-11-11', 'en_cours');
INSERT INTO public.orders VALUES (8, 5, '2025-12-24', 'en_cours');
INSERT INTO public.orders VALUES (9, 6, '2026-01-19', 'expediee');
INSERT INTO public.orders VALUES (10, 3, '2026-02-08', 'livree');
INSERT INTO public.orders VALUES (11, 1, '2026-03-12', 'en_cours');
INSERT INTO public.orders VALUES (12, 2, '2026-04-25', 'expediee');


--
-- TOC entry 3553 (class 0 OID 16428)
-- Dependencies: 229
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product VALUES (2, 'P-002', 'Casque audio', 59.99, 12, true, 1, NULL);
INSERT INTO public.product VALUES (3, 'P-003', 'Souris sans fil', 24.50, 0, true, 1, NULL);
INSERT INTO public.product VALUES (4, 'P-004', 'Chaise de bureau', 149.00, 8, true, 2, NULL);
INSERT INTO public.product VALUES (5, 'P-005', 'Lampe LED', 29.90, 25, true, 2, NULL);
INSERT INTO public.product VALUES (6, 'P-006', 'Ramette papier A4', 4.99, 200, true, 3, NULL);
INSERT INTO public.product VALUES (7, 'P-007', 'Stylo bille (lot de 10)', 3.50, 150, true, 3, NULL);
INSERT INTO public.product VALUES (8, 'P-008', 'Café en grains 1 kg', 18.50, 30, true, 4, NULL);
INSERT INTO public.product VALUES (9, 'P-009', 'Écran 24 pouces', 189.00, 4, true, 1, NULL);
INSERT INTO public.product VALUES (10, 'P-010', 'Bureau réglable', 449.00, 2, false, 2, NULL);
INSERT INTO public.product VALUES (11, 'P-011', 'Tuyau PVC diamètre 10cm longueur 2m', 15.99, 50, true, 5, 3);
INSERT INTO public.product VALUES (12, 'P-013', 'Tuyau PVC diamètre 5cm longueur 2m', 22.99, 300, true, 5, 3);
INSERT INTO public.product VALUES (13, 'P-014', 'Cable HDMI', 5.00, 1000, true, 1, 1);
INSERT INTO public.product VALUES (14, 'P-015', 'Cable coaxial', 5.00, 100, false, 1, NULL);
INSERT INTO public.product VALUES (1, 'P-001', 'Clé USB 32 Go', 10.32, 45, true, 1, NULL);


--
-- TOC entry 3558 (class 0 OID 24705)
-- Dependencies: 234
-- Data for Name: product_archive; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_archive VALUES (1, 18, 'P-016', 'RAM SODIMM 16Go DDR5', 100.00, 10, true, 6, NULL, '2026-11-10 10:49:43.217723');


--
-- TOC entry 3560 (class 0 OID 24723)
-- Dependencies: 236
-- Data for Name: product_price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_price_history VALUES (1, 1, 12.90, 10.32, '2026-11-10 10:43:19.296445');


--
-- TOC entry 3555 (class 0 OID 16443)
-- Dependencies: 231
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supplier VALUES (1, 'Amazon', false, true, 'amazon@amazon.com');
INSERT INTO public.supplier VALUES (2, 'Microsoft', false, true, 'satya.nadella@microsoft.com');
INSERT INTO public.supplier VALUES (3, 'Plomberie Mario', false, true, 'itsame@gmail.com');
INSERT INTO public.supplier VALUES (4, 'CDiscount', false, true, NULL);
INSERT INTO public.supplier VALUES (5, 'Legallais', false, true, NULL);
INSERT INTO public.supplier VALUES (6, 'Leroy Merlin', false, true, NULL);
INSERT INTO public.supplier VALUES (7, 'Lapeyre', false, true, NULL);
INSERT INTO public.supplier VALUES (8, 'Kiloutou', false, true, NULL);


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 7, true);


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 222
-- Name: client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_id_seq', 11, true);


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 224
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_id_seq', 5, true);


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_item_id_seq', 22, true);


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 228
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 12, true);


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 233
-- Name: product_archive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_archive_id_seq', 1, true);


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 230
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_seq', 18, true);


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 235
-- Name: product_price_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_price_history_id_seq', 1, true);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 232
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_id_seq', 8, true);


--
-- TOC entry 3356 (class 2606 OID 16460)
-- Name: category category_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_label_key UNIQUE (label);


--
-- TOC entry 3358 (class 2606 OID 16462)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 16464)
-- Name: client client_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_email_key UNIQUE (email);


--
-- TOC entry 3362 (class 2606 OID 16466)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 2606 OID 16468)
-- Name: employee employee_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_email_key UNIQUE (email);


--
-- TOC entry 3366 (class 2606 OID 16470)
-- Name: employee employee_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_login_key UNIQUE (login);


--
-- TOC entry 3368 (class 2606 OID 16472)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 16474)
-- Name: order_item order_item_order_product_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_product_key UNIQUE (order_id, product_id);


--
-- TOC entry 3372 (class 2606 OID 16476)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 16478)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 24719)
-- Name: product_archive product_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_archive
    ADD CONSTRAINT product_archive_pkey PRIMARY KEY (id);


--
-- TOC entry 3376 (class 2606 OID 16480)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 24734)
-- Name: product_price_history product_price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT product_price_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3378 (class 2606 OID 16482)
-- Name: product product_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_reference_key UNIQUE (reference);


--
-- TOC entry 3380 (class 2606 OID 16484)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- TOC entry 3392 (class 2620 OID 24703)
-- Name: client trg_client_lower_email; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_client_lower_email BEFORE INSERT ON public.client FOR EACH ROW EXECUTE FUNCTION public.fn_normalize_client_email();


--
-- TOC entry 3393 (class 2620 OID 24743)
-- Name: product trg_product_archive_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_product_archive_delete AFTER DELETE ON public.product FOR EACH ROW EXECUTE FUNCTION public.archive_deleted_product();


--
-- TOC entry 3394 (class 2620 OID 24721)
-- Name: product trg_product_log_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_product_log_price AFTER UPDATE OF unit_price ON public.product FOR EACH ROW WHEN ((old.unit_price IS DISTINCT FROM new.unit_price)) EXECUTE FUNCTION public.log_price_change();


--
-- TOC entry 3395 (class 2620 OID 24745)
-- Name: product trg_product_low_stock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_product_low_stock AFTER UPDATE OF stock ON public.product FOR EACH ROW WHEN (((old.stock >= 5) AND (new.stock < 5))) EXECUTE FUNCTION public.warn_low_stock();


--
-- TOC entry 3391 (class 2606 OID 24735)
-- Name: product_price_history fk_product_price_history_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT fk_product_price_history_product FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE CASCADE;


--
-- TOC entry 3385 (class 2606 OID 32894)
-- Name: order_item order_item_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id) ON DELETE RESTRICT;


--
-- TOC entry 3386 (class 2606 OID 16485)
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 3387 (class 2606 OID 16490)
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE RESTRICT;


--
-- TOC entry 3388 (class 2606 OID 16495)
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(id) ON DELETE RESTRICT;


--
-- TOC entry 3389 (class 2606 OID 16500)
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- TOC entry 3390 (class 2606 OID 16505)
-- Name: product product_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


-- Completed on 2026-11-10 11:27:35
