--
-- PostgreSQL database dump
--

<<<<<<< HEAD
=======


>>>>>>> aaead4c8ac26bf41d7ea353cf083bce3b6ebdff3
-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-08-06 10:10:58

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
-- TOC entry 219 (class 1259 OID 18125)
-- Name: approval_rule_approvers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval_rule_approvers (
    rule_approver_id bigint NOT NULL,
    rule_id bigint NOT NULL,
    sequence_no integer NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.approval_rule_approvers OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18133)
-- Name: approval_rule_approvers_rule_approver_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.approval_rule_approvers_rule_approver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.approval_rule_approvers_rule_approver_id_seq OWNER TO postgres;

--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 220
-- Name: approval_rule_approvers_rule_approver_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.approval_rule_approvers_rule_approver_id_seq OWNED BY public.approval_rule_approvers.rule_approver_id;


--
-- TOC entry 221 (class 1259 OID 18134)
-- Name: approval_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval_rules (
    rule_id bigint NOT NULL,
    department_id bigint NOT NULL,
    category_id bigint NOT NULL,
    min_amount numeric(12,2) NOT NULL,
    max_amount numeric(12,2) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.approval_rules OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18144)
-- Name: approval_rules_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.approval_rules_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.approval_rules_rule_id_seq OWNER TO postgres;

--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 222
-- Name: approval_rules_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.approval_rules_rule_id_seq OWNED BY public.approval_rules.rule_id;


--
-- TOC entry 223 (class 1259 OID 18145)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    audit_id bigint NOT NULL,
    user_id bigint,
    module character varying(100),
    action character varying(100),
    entity_name character varying(100),
    entity_id bigint,
    remarks text,
    action_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18152)
-- Name: audit_logs_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_audit_id_seq OWNER TO postgres;

--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 224
-- Name: audit_logs_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_audit_id_seq OWNED BY public.audit_logs.audit_id;


--
-- TOC entry 260 (class 1259 OID 19575)
-- Name: budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budgets (
    budget_id bigint NOT NULL,
    department_id bigint NOT NULL,
    cost_center_id bigint,
    allocated_budget numeric(18,2) DEFAULT 0 NOT NULL,
    used_budget numeric(18,2) DEFAULT 0 NOT NULL,
    remaining_budget numeric(18,2) DEFAULT 0 NOT NULL,
    financial_year character varying(10) NOT NULL,
    status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_budget_values CHECK (((allocated_budget >= (0)::numeric) AND (used_budget >= (0)::numeric) AND (remaining_budget >= (0)::numeric)))
);


ALTER TABLE public.budgets OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 19574)
-- Name: budgets_budget_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.budgets_budget_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budgets_budget_id_seq OWNER TO postgres;

--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 259
-- Name: budgets_budget_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.budgets_budget_id_seq OWNED BY public.budgets.budget_id;


--
-- TOC entry 225 (class 1259 OID 18153)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id bigint NOT NULL,
    category_code character varying(20) NOT NULL,
    category_name character varying(100) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    icon character varying(100),
    color character varying(50)
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 18163)
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 226
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- TOC entry 227 (class 1259 OID 18164)
-- Name: cost_centers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cost_centers (
    cost_center_id bigint NOT NULL,
    cost_center_code character varying(20) NOT NULL,
    cost_center_name character varying(100) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    budget_limit numeric(18,2) DEFAULT 0,
    financial_year character varying(10)
);


ALTER TABLE public.cost_centers OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 18174)
-- Name: cost_centers_cost_center_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cost_centers_cost_center_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cost_centers_cost_center_id_seq OWNER TO postgres;

--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 228
-- Name: cost_centers_cost_center_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cost_centers_cost_center_id_seq OWNED BY public.cost_centers.cost_center_id;


--
-- TOC entry 266 (class 1259 OID 19642)
-- Name: dashboard_metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_metrics (
    metric_id bigint NOT NULL,
    metric_name character varying(100) NOT NULL,
    metric_value numeric(18,2),
    metric_scope character varying(100),
    calculated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.dashboard_metrics OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 19641)
-- Name: dashboard_metrics_metric_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboard_metrics_metric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboard_metrics_metric_id_seq OWNER TO postgres;

--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 265
-- Name: dashboard_metrics_metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboard_metrics_metric_id_seq OWNED BY public.dashboard_metrics.metric_id;


--
-- TOC entry 229 (class 1259 OID 18175)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id bigint NOT NULL,
    cost_center_id bigint NOT NULL,
    department_code character varying(20) NOT NULL,
    department_name character varying(100) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    department_head character varying(100),
    email character varying(100),
    phone character varying(20)
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 18186)
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_department_id_seq OWNER TO postgres;

--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 230
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- TOC entry 258 (class 1259 OID 19556)
-- Name: login_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_history (
    login_id bigint NOT NULL,
    user_id bigint,
    login_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    logout_time timestamp without time zone,
    ip_address character varying(100),
    device character varying(255),
    browser character varying(255),
    success boolean DEFAULT true NOT NULL
);


ALTER TABLE public.login_history OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 19555)
-- Name: login_history_login_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_history_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_history_login_id_seq OWNER TO postgres;

--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 257
-- Name: login_history_login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_history_login_id_seq OWNED BY public.login_history.login_id;


--
-- TOC entry 252 (class 1259 OID 19484)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    notification_type character varying(50),
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 19483)
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO postgres;

--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 251
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- TOC entry 231 (class 1259 OID 18187)
-- Name: po_line_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.po_line_items (
    po_line_item_id bigint NOT NULL,
    po_id bigint NOT NULL,
    description text,
    ordered_qty integer,
    received_qty integer DEFAULT 0,
    unit_price numeric(12,2)
);


ALTER TABLE public.po_line_items OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 18195)
-- Name: po_line_items_po_line_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.po_line_items_po_line_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.po_line_items_po_line_item_id_seq OWNER TO postgres;

--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 232
-- Name: po_line_items_po_line_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.po_line_items_po_line_item_id_seq OWNED BY public.po_line_items.po_line_item_id;


--
-- TOC entry 233 (class 1259 OID 18196)
-- Name: po_receipts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.po_receipts (
    receipt_id bigint NOT NULL,
    po_id bigint NOT NULL,
    description text,
    qty_received integer,
    received_date date,
    received_by bigint
);


ALTER TABLE public.po_receipts OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 18203)
-- Name: po_receipts_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.po_receipts_receipt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.po_receipts_receipt_id_seq OWNER TO postgres;

--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 234
-- Name: po_receipts_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.po_receipts_receipt_id_seq OWNED BY public.po_receipts.receipt_id;


--
-- TOC entry 235 (class 1259 OID 18204)
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_orders (
    po_id bigint NOT NULL,
    po_number character varying(30) NOT NULL,
    requisition_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    created_date date,
    stage character varying(50),
    status character varying(30),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expected_delivery date,
    actual_delivery date,
    shipping_cost numeric(18,2) DEFAULT 0,
    tax_amount numeric(18,2) DEFAULT 0,
    discount numeric(18,2) DEFAULT 0
);


ALTER TABLE public.purchase_orders OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 18212)
-- Name: purchase_orders_po_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_orders_po_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_orders_po_id_seq OWNER TO postgres;

--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 236
-- Name: purchase_orders_po_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_orders_po_id_seq OWNED BY public.purchase_orders.po_id;


--
-- TOC entry 254 (class 1259 OID 19506)
-- Name: requisition_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisition_comments (
    comment_id bigint NOT NULL,
    requisition_id bigint NOT NULL,
    user_id bigint NOT NULL,
    comment text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.requisition_comments OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 19505)
-- Name: requisition_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requisition_comments_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requisition_comments_comment_id_seq OWNER TO postgres;

--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 253
-- Name: requisition_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisition_comments_comment_id_seq OWNED BY public.requisition_comments.comment_id;


--
-- TOC entry 256 (class 1259 OID 19531)
-- Name: requisition_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisition_documents (
    document_id bigint NOT NULL,
    requisition_id bigint NOT NULL,
    document_name character varying(255) NOT NULL,
    document_type character varying(100),
    document_path text NOT NULL,
    uploaded_by bigint,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.requisition_documents OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 19530)
-- Name: requisition_documents_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requisition_documents_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requisition_documents_document_id_seq OWNER TO postgres;

--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 255
-- Name: requisition_documents_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisition_documents_document_id_seq OWNED BY public.requisition_documents.document_id;


--
-- TOC entry 237 (class 1259 OID 18213)
-- Name: requisition_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisition_history (
    history_id bigint NOT NULL,
    requisition_id bigint NOT NULL,
    action_by bigint NOT NULL,
    step character varying(100),
    remarks text,
    action_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.requisition_history OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 18222)
-- Name: requisition_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requisition_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requisition_history_history_id_seq OWNER TO postgres;

--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 238
-- Name: requisition_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisition_history_history_id_seq OWNED BY public.requisition_history.history_id;


--
-- TOC entry 239 (class 1259 OID 18223)
-- Name: requisition_line_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisition_line_items (
    line_item_id bigint NOT NULL,
    requisition_id bigint NOT NULL,
    description text NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(12,2) NOT NULL
);


ALTER TABLE public.requisition_line_items OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18233)
-- Name: requisition_line_items_line_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requisition_line_items_line_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requisition_line_items_line_item_id_seq OWNER TO postgres;

--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 240
-- Name: requisition_line_items_line_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisition_line_items_line_item_id_seq OWNED BY public.requisition_line_items.line_item_id;


--
-- TOC entry 241 (class 1259 OID 18234)
-- Name: requisitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisitions (
    requisition_id bigint NOT NULL,
    requisition_number character varying(30) NOT NULL,
    created_by bigint NOT NULL,
    department_id bigint NOT NULL,
    supplier_id bigint,
    category_id bigint NOT NULL,
    title character varying(150) NOT NULL,
    justification text,
    needed_by date,
    total_amount numeric(12,2),
    status character varying(30) DEFAULT 'PENDING'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    priority character varying(20) DEFAULT 'MEDIUM'::character varying,
    estimated_delivery date,
    project_code character varying(50),
    delivery_location character varying(255),
    budget_code character varying(50),
    returned_at timestamp without time zone,
    returned_by bigint,
    return_reason text,
    CONSTRAINT chk_requisition_priority CHECK (((priority)::text = ANY ((ARRAY['LOW'::character varying, 'MEDIUM'::character varying, 'HIGH'::character varying, 'CRITICAL'::character varying])::text[])))
);


ALTER TABLE public.requisitions OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 18247)
-- Name: requisitions_requisition_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requisitions_requisition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requisitions_requisition_id_seq OWNER TO postgres;

--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 242
-- Name: requisitions_requisition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisitions_requisition_id_seq OWNED BY public.requisitions.requisition_id;


--
-- TOC entry 243 (class 1259 OID 18248)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id bigint NOT NULL,
    role_name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 18256)
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 244
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- TOC entry 264 (class 1259 OID 19627)
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    setting_id bigint NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value text,
    description text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 19626)
-- Name: settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.settings_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.settings_setting_id_seq OWNER TO postgres;

--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 263
-- Name: settings_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_setting_id_seq OWNED BY public.settings.setting_id;


--
-- TOC entry 262 (class 1259 OID 19608)
-- Name: supplier_contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier_contacts (
    contact_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    contact_name character varying(100) NOT NULL,
    designation character varying(100),
    email character varying(150),
    phone character varying(30),
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.supplier_contacts OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 19607)
-- Name: supplier_contacts_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_contacts_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_contacts_contact_id_seq OWNER TO postgres;

--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 261
-- Name: supplier_contacts_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_contacts_contact_id_seq OWNED BY public.supplier_contacts.contact_id;


--
-- TOC entry 245 (class 1259 OID 18257)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplier_id bigint NOT NULL,
    supplier_code character varying(20) NOT NULL,
    supplier_name character varying(150) NOT NULL,
    contact_name character varying(100),
    email character varying(100),
    phone character varying(20),
    address text,
    gst_number character varying(30),
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    pan_number character varying(20),
    contact_person character varying(100),
    payment_terms character varying(100),
    rating numeric(3,2),
    website character varying(255),
    preferred_supplier boolean DEFAULT false,
    CONSTRAINT chk_suppliers_rating CHECK (((rating IS NULL) OR ((rating >= (0)::numeric) AND (rating <= (5)::numeric))))
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 18267)
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_supplier_id_seq OWNER TO postgres;

--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 246
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_supplier_id_seq OWNED BY public.suppliers.supplier_id;


--
-- TOC entry 247 (class 1259 OID 18268)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_role_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18275)
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_user_role_id_seq OWNER TO postgres;

--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 248
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_user_role_id_seq OWNED BY public.user_roles.user_role_id;


--
-- TOC entry 249 (class 1259 OID 18276)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    department_id bigint NOT NULL,
    employee_id character varying(20) NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20),
    designation character varying(100),
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    manager_id bigint,
    last_login timestamp without time zone,
    profile_photo text,
    employee_type character varying(50),
    office_location character varying(100)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 18290)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 250
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4971 (class 2604 OID 19321)
-- Name: approval_rule_approvers rule_approver_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rule_approvers ALTER COLUMN rule_approver_id SET DEFAULT nextval('public.approval_rule_approvers_rule_approver_id_seq'::regclass);


--
-- TOC entry 4973 (class 2604 OID 19300)
-- Name: approval_rules rule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rules ALTER COLUMN rule_id SET DEFAULT nextval('public.approval_rules_rule_id_seq'::regclass);


--
-- TOC entry 4976 (class 2604 OID 19456)
-- Name: audit_logs audit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN audit_id SET DEFAULT nextval('public.audit_logs_audit_id_seq'::regclass);


--
-- TOC entry 5024 (class 2604 OID 19578)
-- Name: budgets budget_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets ALTER COLUMN budget_id SET DEFAULT nextval('public.budgets_budget_id_seq'::regclass);


--
-- TOC entry 4978 (class 2604 OID 19272)
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- TOC entry 4981 (class 2604 OID 19183)
-- Name: cost_centers cost_center_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cost_centers ALTER COLUMN cost_center_id SET DEFAULT nextval('public.cost_centers_cost_center_id_seq'::regclass);


--
-- TOC entry 5036 (class 2604 OID 19645)
-- Name: dashboard_metrics metric_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_metrics ALTER COLUMN metric_id SET DEFAULT nextval('public.dashboard_metrics_metric_id_seq'::regclass);


--
-- TOC entry 4985 (class 2604 OID 19192)
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- TOC entry 5021 (class 2604 OID 19559)
-- Name: login_history login_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history ALTER COLUMN login_id SET DEFAULT nextval('public.login_history_login_id_seq'::regclass);


--
-- TOC entry 5014 (class 2604 OID 19487)
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- TOC entry 4988 (class 2604 OID 19431)
-- Name: po_line_items po_line_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_line_items ALTER COLUMN po_line_item_id SET DEFAULT nextval('public.po_line_items_po_line_item_id_seq'::regclass);


--
-- TOC entry 4990 (class 2604 OID 19441)
-- Name: po_receipts receipt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_receipts ALTER COLUMN receipt_id SET DEFAULT nextval('public.po_receipts_receipt_id_seq'::regclass);


--
-- TOC entry 4991 (class 2604 OID 19405)
-- Name: purchase_orders po_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN po_id SET DEFAULT nextval('public.purchase_orders_po_id_seq'::regclass);


--
-- TOC entry 5017 (class 2604 OID 19509)
-- Name: requisition_comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_comments ALTER COLUMN comment_id SET DEFAULT nextval('public.requisition_comments_comment_id_seq'::regclass);


--
-- TOC entry 5019 (class 2604 OID 19534)
-- Name: requisition_documents document_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_documents ALTER COLUMN document_id SET DEFAULT nextval('public.requisition_documents_document_id_seq'::regclass);


--
-- TOC entry 4996 (class 2604 OID 19389)
-- Name: requisition_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_history ALTER COLUMN history_id SET DEFAULT nextval('public.requisition_history_history_id_seq'::regclass);


--
-- TOC entry 4998 (class 2604 OID 19379)
-- Name: requisition_line_items line_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_line_items ALTER COLUMN line_item_id SET DEFAULT nextval('public.requisition_line_items_line_item_id_seq'::regclass);


--
-- TOC entry 4999 (class 2604 OID 19337)
-- Name: requisitions requisition_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions ALTER COLUMN requisition_id SET DEFAULT nextval('public.requisitions_requisition_id_seq'::regclass);


--
-- TOC entry 5003 (class 2604 OID 19169)
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- TOC entry 5034 (class 2604 OID 19630)
-- Name: settings setting_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN setting_id SET DEFAULT nextval('public.settings_setting_id_seq'::regclass);


--
-- TOC entry 5031 (class 2604 OID 19611)
-- Name: supplier_contacts contact_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_contacts ALTER COLUMN contact_id SET DEFAULT nextval('public.supplier_contacts_contact_id_seq'::regclass);


--
-- TOC entry 5005 (class 2604 OID 19286)
-- Name: suppliers supplier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN supplier_id SET DEFAULT nextval('public.suppliers_supplier_id_seq'::regclass);


--
-- TOC entry 5009 (class 2604 OID 19252)
-- Name: user_roles user_role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN user_role_id SET DEFAULT nextval('public.user_roles_user_role_id_seq'::regclass);


--
-- TOC entry 5011 (class 2604 OID 19217)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5042 (class 2606 OID 19323)
-- Name: approval_rule_approvers approval_rule_approvers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rule_approvers
    ADD CONSTRAINT approval_rule_approvers_pkey PRIMARY KEY (rule_approver_id);


--
-- TOC entry 5044 (class 2606 OID 19302)
-- Name: approval_rules approval_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rules
    ADD CONSTRAINT approval_rules_pkey PRIMARY KEY (rule_id);


--
-- TOC entry 5046 (class 2606 OID 19458)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 5113 (class 2606 OID 19596)
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (budget_id);


--
-- TOC entry 5048 (class 2606 OID 18314)
-- Name: categories categories_category_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_code_key UNIQUE (category_code);


--
-- TOC entry 5050 (class 2606 OID 19274)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 5052 (class 2606 OID 18318)
-- Name: cost_centers cost_centers_cost_center_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cost_centers
    ADD CONSTRAINT cost_centers_cost_center_code_key UNIQUE (cost_center_code);


--
-- TOC entry 5054 (class 2606 OID 19185)
-- Name: cost_centers cost_centers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cost_centers
    ADD CONSTRAINT cost_centers_pkey PRIMARY KEY (cost_center_id);


--
-- TOC entry 5123 (class 2606 OID 19651)
-- Name: dashboard_metrics dashboard_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_metrics
    ADD CONSTRAINT dashboard_metrics_pkey PRIMARY KEY (metric_id);


--
-- TOC entry 5056 (class 2606 OID 18322)
-- Name: departments departments_department_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_code_key UNIQUE (department_code);


--
-- TOC entry 5058 (class 2606 OID 19194)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- TOC entry 5111 (class 2606 OID 19568)
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (login_id);


--
-- TOC entry 5102 (class 2606 OID 19499)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- TOC entry 5060 (class 2606 OID 19433)
-- Name: po_line_items po_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_line_items
    ADD CONSTRAINT po_line_items_pkey PRIMARY KEY (po_line_item_id);


--
-- TOC entry 5062 (class 2606 OID 19443)
-- Name: po_receipts po_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_receipts
    ADD CONSTRAINT po_receipts_pkey PRIMARY KEY (receipt_id);


--
-- TOC entry 5065 (class 2606 OID 19407)
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (po_id);


--
-- TOC entry 5067 (class 2606 OID 18332)
-- Name: purchase_orders purchase_orders_po_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_po_number_key UNIQUE (po_number);


--
-- TOC entry 5105 (class 2606 OID 19519)
-- Name: requisition_comments requisition_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_comments
    ADD CONSTRAINT requisition_comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 5108 (class 2606 OID 19544)
-- Name: requisition_documents requisition_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_documents
    ADD CONSTRAINT requisition_documents_pkey PRIMARY KEY (document_id);


--
-- TOC entry 5069 (class 2606 OID 19391)
-- Name: requisition_history requisition_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_history
    ADD CONSTRAINT requisition_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 5071 (class 2606 OID 19381)
-- Name: requisition_line_items requisition_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_line_items
    ADD CONSTRAINT requisition_line_items_pkey PRIMARY KEY (line_item_id);


--
-- TOC entry 5076 (class 2606 OID 19339)
-- Name: requisitions requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT requisitions_pkey PRIMARY KEY (requisition_id);


--
-- TOC entry 5078 (class 2606 OID 18340)
-- Name: requisitions requisitions_requisition_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT requisitions_requisition_number_key UNIQUE (requisition_number);


--
-- TOC entry 5080 (class 2606 OID 19171)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 5082 (class 2606 OID 18344)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 5119 (class 2606 OID 19638)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (setting_id);


--
-- TOC entry 5121 (class 2606 OID 19640)
-- Name: settings settings_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_setting_key_key UNIQUE (setting_key);


--
-- TOC entry 5117 (class 2606 OID 19620)
-- Name: supplier_contacts supplier_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_contacts
    ADD CONSTRAINT supplier_contacts_pkey PRIMARY KEY (contact_id);


--
-- TOC entry 5084 (class 2606 OID 19288)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);


--
-- TOC entry 5086 (class 2606 OID 18348)
-- Name: suppliers suppliers_supplier_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_supplier_code_key UNIQUE (supplier_code);


--
-- TOC entry 5088 (class 2606 OID 19265)
-- Name: user_roles uq_user_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT uq_user_role UNIQUE (user_id, role_id);


--
-- TOC entry 5090 (class 2606 OID 19254)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_role_id);


--
-- TOC entry 5092 (class 2606 OID 18354)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5094 (class 2606 OID 18356)
-- Name: users users_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 5096 (class 2606 OID 19219)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5098 (class 2606 OID 18360)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 5114 (class 1259 OID 19661)
-- Name: idx_budgets_department; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_department ON public.budgets USING btree (department_id);


--
-- TOC entry 5109 (class 1259 OID 19660)
-- Name: idx_login_history_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_history_user ON public.login_history USING btree (user_id);


--
-- TOC entry 5099 (class 1259 OID 19657)
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at);


--
-- TOC entry 5100 (class 1259 OID 19656)
-- Name: idx_notifications_user_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_read ON public.notifications USING btree (user_id, is_read);


--
-- TOC entry 5063 (class 1259 OID 19655)
-- Name: idx_purchase_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_orders_status ON public.purchase_orders USING btree (status);


--
-- TOC entry 5103 (class 1259 OID 19658)
-- Name: idx_requisition_comments_requisition; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_requisition_comments_requisition ON public.requisition_comments USING btree (requisition_id);


--
-- TOC entry 5106 (class 1259 OID 19659)
-- Name: idx_requisition_documents_requisition; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_requisition_documents_requisition ON public.requisition_documents USING btree (requisition_id);


--
-- TOC entry 5072 (class 1259 OID 19654)
-- Name: idx_requisitions_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_requisitions_created_at ON public.requisitions USING btree (created_at);


--
-- TOC entry 5073 (class 1259 OID 19653)
-- Name: idx_requisitions_priority; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_requisitions_priority ON public.requisitions USING btree (priority);


--
-- TOC entry 5074 (class 1259 OID 19652)
-- Name: idx_requisitions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_requisitions_status ON public.requisitions USING btree (status);


--
-- TOC entry 5115 (class 1259 OID 19662)
-- Name: idx_supplier_contacts_supplier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_supplier_contacts_supplier ON public.supplier_contacts USING btree (supplier_id);


--
-- TOC entry 5128 (class 2606 OID 19460)
-- Name: audit_logs fk_audit_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5153 (class 2606 OID 19602)
-- Name: budgets fk_budgets_cost_center; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT fk_budgets_cost_center FOREIGN KEY (cost_center_id) REFERENCES public.cost_centers(cost_center_id) ON DELETE SET NULL;


--
-- TOC entry 5154 (class 2606 OID 19597)
-- Name: budgets fk_budgets_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT fk_budgets_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE RESTRICT;


--
-- TOC entry 5129 (class 2606 OID 19212)
-- Name: departments fk_department_costcenter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_department_costcenter FOREIGN KEY (cost_center_id) REFERENCES public.cost_centers(cost_center_id);


--
-- TOC entry 5135 (class 2606 OID 19394)
-- Name: requisition_history fk_history_req; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_history
    ADD CONSTRAINT fk_history_req FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- TOC entry 5136 (class 2606 OID 19400)
-- Name: requisition_history fk_history_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_history
    ADD CONSTRAINT fk_history_user FOREIGN KEY (action_by) REFERENCES public.users(user_id);


--
-- TOC entry 5137 (class 2606 OID 19384)
-- Name: requisition_line_items fk_lineitem_req; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_line_items
    ADD CONSTRAINT fk_lineitem_req FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- TOC entry 5152 (class 2606 OID 19569)
-- Name: login_history fk_login_history_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT fk_login_history_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 5147 (class 2606 OID 19500)
-- Name: notifications fk_notifications_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5133 (class 2606 OID 19420)
-- Name: purchase_orders fk_po_req; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT fk_po_req FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id);


--
-- TOC entry 5134 (class 2606 OID 19426)
-- Name: purchase_orders fk_po_supplier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id);


--
-- TOC entry 5130 (class 2606 OID 19436)
-- Name: po_line_items fk_poline_po; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_line_items
    ADD CONSTRAINT fk_poline_po FOREIGN KEY (po_id) REFERENCES public.purchase_orders(po_id);


--
-- TOC entry 5131 (class 2606 OID 19446)
-- Name: po_receipts fk_receipt_po; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_receipts
    ADD CONSTRAINT fk_receipt_po FOREIGN KEY (po_id) REFERENCES public.purchase_orders(po_id);


--
-- TOC entry 5132 (class 2606 OID 19451)
-- Name: po_receipts fk_receipt_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.po_receipts
    ADD CONSTRAINT fk_receipt_user FOREIGN KEY (received_by) REFERENCES public.users(user_id);


--
-- TOC entry 5138 (class 2606 OID 19374)
-- Name: requisitions fk_req_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT fk_req_category FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- TOC entry 5139 (class 2606 OID 19363)
-- Name: requisitions fk_req_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT fk_req_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- TOC entry 5140 (class 2606 OID 19368)
-- Name: requisitions fk_req_supplier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT fk_req_supplier FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id);


--
-- TOC entry 5141 (class 2606 OID 19357)
-- Name: requisitions fk_req_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT fk_req_user FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- TOC entry 5148 (class 2606 OID 19520)
-- Name: requisition_comments fk_requisition_comments_requisition; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_comments
    ADD CONSTRAINT fk_requisition_comments_requisition FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id) ON DELETE CASCADE;


--
-- TOC entry 5149 (class 2606 OID 19525)
-- Name: requisition_comments fk_requisition_comments_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_comments
    ADD CONSTRAINT fk_requisition_comments_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- TOC entry 5150 (class 2606 OID 19545)
-- Name: requisition_documents fk_requisition_documents_requisition; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_documents
    ADD CONSTRAINT fk_requisition_documents_requisition FOREIGN KEY (requisition_id) REFERENCES public.requisitions(requisition_id) ON DELETE CASCADE;


--
-- TOC entry 5151 (class 2606 OID 19550)
-- Name: requisition_documents fk_requisition_documents_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_documents
    ADD CONSTRAINT fk_requisition_documents_user FOREIGN KEY (uploaded_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 5142 (class 2606 OID 19474)
-- Name: requisitions fk_requisitions_returned_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisitions
    ADD CONSTRAINT fk_requisitions_returned_by FOREIGN KEY (returned_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 5126 (class 2606 OID 19316)
-- Name: approval_rules fk_rule_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rules
    ADD CONSTRAINT fk_rule_category FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- TOC entry 5127 (class 2606 OID 19310)
-- Name: approval_rules fk_rule_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rules
    ADD CONSTRAINT fk_rule_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- TOC entry 5124 (class 2606 OID 19332)
-- Name: approval_rule_approvers fk_ruleapprover_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rule_approvers
    ADD CONSTRAINT fk_ruleapprover_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- TOC entry 5125 (class 2606 OID 19326)
-- Name: approval_rule_approvers fk_ruleapprover_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_rule_approvers
    ADD CONSTRAINT fk_ruleapprover_rule FOREIGN KEY (rule_id) REFERENCES public.approval_rules(rule_id);


--
-- TOC entry 5155 (class 2606 OID 19621)
-- Name: supplier_contacts fk_supplier_contacts_supplier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_contacts
    ADD CONSTRAINT fk_supplier_contacts_supplier FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id) ON DELETE CASCADE;


--
-- TOC entry 5145 (class 2606 OID 19247)
-- Name: users fk_user_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- TOC entry 5143 (class 2606 OID 19267)
-- Name: user_roles fk_userroles_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_userroles_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- TOC entry 5144 (class 2606 OID 19259)
-- Name: user_roles fk_userroles_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_userroles_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5146 (class 2606 OID 19465)
-- Name: users fk_users_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_manager FOREIGN KEY (manager_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


-- Completed on 2026-08-06 10:10:58

--
-- PostgreSQL database dump complete
--

