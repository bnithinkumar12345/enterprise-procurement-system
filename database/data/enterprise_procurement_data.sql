--
-- PostgreSQL database dump
--



-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-08-06 10:11:18

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
-- TOC entry 5239 (class 0 OID 18153)
-- Dependencies: 225
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_code, category_name, description, status, created_at, icon, color) FROM stdin;
1	CAT001	IT Hardware	Computers and Hardware	ACTIVE	2026-07-26 17:25:31.831599	\N	\N
2	CAT002	Office Supplies	Office Materials	ACTIVE	2026-07-26 17:25:31.831599	\N	\N
3	CAT003	Networking	Networking Equipment	ACTIVE	2026-07-26 17:25:31.831599	\N	\N
4	CAT004	Furniture	Office Furniture	ACTIVE	2026-07-26 17:25:31.831599	\N	\N
5	CAT005	Software	Software Licenses	ACTIVE	2026-07-26 17:25:31.831599	\N	\N
\.


--
-- TOC entry 5241 (class 0 OID 18164)
-- Dependencies: 227
-- Data for Name: cost_centers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cost_centers (cost_center_id, cost_center_code, cost_center_name, description, status, created_at, budget_limit, financial_year) FROM stdin;
1	CC001	Information Technology	IT Cost Center	ACTIVE	2026-07-26 17:24:46.736871	0.00	\N
2	CC002	Finance	Finance Cost Center	ACTIVE	2026-07-26 17:24:46.736871	0.00	\N
3	CC003	Human Resources	HR Cost Center	ACTIVE	2026-07-26 17:24:46.736871	0.00	\N
4	CC004	Operations	Operations Cost Center	ACTIVE	2026-07-26 17:24:46.736871	0.00	\N
\.


--
-- TOC entry 5243 (class 0 OID 18175)
-- Dependencies: 229
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, cost_center_id, department_code, department_name, description, status, created_at, department_head, email, phone) FROM stdin;
1	1	IT	Information Technology	IT Department	ACTIVE	2026-07-26 17:25:22.247404	\N	\N	\N
2	2	FIN	Finance	Finance Department	ACTIVE	2026-07-26 17:25:22.247404	\N	\N	\N
3	3	HR	Human Resources	HR Department	ACTIVE	2026-07-26 17:25:22.247404	\N	\N	\N
4	4	OPS	Operations	Operations Department	ACTIVE	2026-07-26 17:25:22.247404	\N	\N	\N
\.


--
-- TOC entry 5235 (class 0 OID 18134)
-- Dependencies: 221
-- Data for Name: approval_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approval_rules (rule_id, department_id, category_id, min_amount, max_amount, is_active, created_at) FROM stdin;
1	1	1	0.00	50000.00	t	2026-07-26 17:26:44.404231
2	1	1	50001.00	200000.00	t	2026-07-26 17:26:44.404231
3	2	2	0.00	100000.00	t	2026-07-26 17:26:44.404231
\.


--
-- TOC entry 5257 (class 0 OID 18248)
-- Dependencies: 243
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name, description, created_at) FROM stdin;
1	Admin	System Administrator	2026-07-26 17:24:24.351732
2	Requester	Can create requisitions	2026-07-26 17:24:24.351732
3	Manager	Approves requests	2026-07-26 17:24:24.351732
4	Finance	Finance Approval	2026-07-26 17:24:24.351732
5	Receiver	Receives Purchase Orders	2026-07-26 17:24:24.351732
\.


--
-- TOC entry 5233 (class 0 OID 18125)
-- Dependencies: 219
-- Data for Name: approval_rule_approvers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approval_rule_approvers (rule_approver_id, rule_id, sequence_no, role_id, created_at) FROM stdin;
1	1	1	3	2026-07-26 17:27:13.89039
2	2	1	3	2026-07-26 17:27:13.89039
3	2	2	4	2026-07-26 17:27:13.89039
4	3	1	4	2026-07-26 17:27:13.89039
\.


--
-- TOC entry 5263 (class 0 OID 18276)
-- Dependencies: 249
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, department_id, employee_id, username, password_hash, full_name, email, phone, designation, status, created_at, manager_id, last_login, profile_photo, employee_type, office_location) FROM stdin;
1	1	EMP001	admin	$2b$10$UUnqpLjVbmiWnLGMKlgvR.vaFlh3G3Kt0suKrxGS7sI66Vf58UJV.	System Admin	admin@company.com	9876500001	Administrator	ACTIVE	2026-07-26 17:26:12.748156	\N	\N	\N	\N	\N
2	1	EMP002	manager1	$2b$10$eCkLbMyGpBTnyL01ZXmRvuj5cCoJcm98kkt5Oe5cwoeqvuPtodpHq	IT Manager	manager@company.com	9876500002	Manager	ACTIVE	2026-07-26 17:26:12.748156	\N	\N	\N	\N	\N
3	2	EMP003	finance1	$2b$10$Iv4LPG/Wc/ahD5GXsOBKku/bgbcDz.l50JYCaqDADclAoDui1F/nm	Finance Officer	finance@company.com	9876500003	Finance	ACTIVE	2026-07-26 17:26:12.748156	\N	\N	\N	\N	\N
4	1	EMP004	requester1	$2b$10$szb4BYNh3R96eJ99AXXur.4u0VOp9ewN3tn.eGjThKJMMpUiI33Jm	John Doe	john@company.com	9876500004	Employee	ACTIVE	2026-07-26 17:26:12.748156	\N	\N	\N	\N	\N
5	4	EMP005	receiver1	$2b$10$Bh0HZxJ4nSfD5qi6FHm6QuTZawuWskjPi/8f.dKMN4R/8XAMb4N22	Warehouse User	receiver@company.com	9876500005	Receiver	ACTIVE	2026-07-26 17:26:12.748156	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5237 (class 0 OID 18145)
-- Dependencies: 223
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (audit_id, user_id, module, action, entity_name, entity_id, remarks, action_time) FROM stdin;
1	4	Requisition	CREATE	Requisition	1	Created REQ-2026-001	2026-07-26 17:29:56.651535
2	2	Approval	APPROVE	Requisition	2	Manager Approval	2026-07-26 17:29:56.651535
3	3	Approval	APPROVE	Requisition	2	Finance Approval	2026-07-26 17:29:56.651535
4	5	Receiving	RECEIVE	Purchase Order	2	Received Printer Paper	2026-07-26 17:29:56.651535
5	4	Requisition	CREATE	Requisition	6	Created Requisition REQ-20260803172041-3751	2026-08-03 17:20:41.743468
6	4	Requisition	CREATE	Requisition	7	Created Requisition REQ-20260803173747-6886	2026-08-03 17:37:47.638155
7	4	Requisition	CREATE	Requisition	8	Created Requisition REQ-20260803174037-7131	2026-08-03 17:40:37.55028
8	2	Approval	APPROVE	Requisition	8	Requisition APPROVE by manager1 — Approved	2026-08-03 17:41:09.779344
9	1	Approval	APPROVE	Requisition	7	Requisition APPROVE by admin — Approved	2026-08-03 17:41:54.782826
10	4	Requisition	CREATE	Requisition	9	Created Requisition REQ-20260803185917-5350	2026-08-03 18:59:18.037838
11	2	Approval	APPROVE	Requisition	9	Requisition APPROVE by manager1 — Approved via dashboard	2026-08-03 18:59:45.058633
12	4	Requisition	CREATE	Requisition	10	Created Requisition REQ-20260803192454-5816	2026-08-03 19:24:54.290753
13	2	Approval	APPROVE	Requisition	10	Requisition APPROVE by manager1 — Approved via dashboard	2026-08-03 19:25:22.42367
14	1	Approval	APPROVE	Requisition	10	Requisition APPROVE by admin — Approved	2026-08-03 19:26:06.693009
\.


--
-- TOC entry 5274 (class 0 OID 19575)
-- Dependencies: 260
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.budgets (budget_id, department_id, cost_center_id, allocated_budget, used_budget, remaining_budget, financial_year, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5280 (class 0 OID 19642)
-- Dependencies: 266
-- Data for Name: dashboard_metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_metrics (metric_id, metric_name, metric_value, metric_scope, calculated_at) FROM stdin;
\.


--
-- TOC entry 5272 (class 0 OID 19556)
-- Dependencies: 258
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_history (login_id, user_id, login_time, logout_time, ip_address, device, browser, success) FROM stdin;
\.


--
-- TOC entry 5266 (class 0 OID 19484)
-- Dependencies: 252
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, user_id, title, message, notification_type, is_read, created_at) FROM stdin;
\.


--
-- TOC entry 5259 (class 0 OID 18257)
-- Dependencies: 245
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (supplier_id, supplier_code, supplier_name, contact_name, email, phone, address, gst_number, status, created_at, pan_number, contact_person, payment_terms, rating, website, preferred_supplier) FROM stdin;
1	SUP001	Dell India	Rahul Sharma	dell@example.com	9876543210	Bangalore	29ABCDE1234F1Z5	ACTIVE	2026-07-26 17:25:56.598945	\N	\N	\N	\N	\N	f
2	SUP002	HP India	Amit Kumar	hp@example.com	9876543211	Chennai	29ABCDE1234F1Z6	ACTIVE	2026-07-26 17:25:56.598945	\N	\N	\N	\N	\N	f
3	SUP003	Lenovo India	Karan Singh	lenovo@example.com	9876543212	Hyderabad	29ABCDE1234F1Z7	ACTIVE	2026-07-26 17:25:56.598945	\N	\N	\N	\N	\N	f
\.


--
-- TOC entry 5255 (class 0 OID 18234)
-- Dependencies: 241
-- Data for Name: requisitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requisitions (requisition_id, requisition_number, created_by, department_id, supplier_id, category_id, title, justification, needed_by, total_amount, status, created_at, priority, estimated_delivery, project_code, delivery_location, budget_code, returned_at, returned_by, return_reason) FROM stdin;
1	REQ-2026-001	4	1	1	1	Purchase Dell Laptops	Need laptops for new employees	2026-08-10	45000.00	PENDING	2026-07-26 17:27:55.220487	MEDIUM	\N	\N	\N	\N	\N	\N	\N
2	REQ-2026-002	4	1	2	1	Purchase HP Desktop	Desktop replacement	2026-08-15	120000.00	APPROVED	2026-07-26 17:27:55.220487	MEDIUM	\N	\N	\N	\N	\N	\N	\N
3	REQ-2026-003	3	2	3	2	Office Stationery	Monthly office supplies	2026-08-05	15000.00	APPROVED	2026-07-26 17:27:55.220487	MEDIUM	\N	\N	\N	\N	\N	\N	\N
4	REQ-20260803151724-8507	4	1	\N	5	Softwares For Office	We Need To Provide To Everyone	2026-08-05	80000.00	SUBMITTED	2026-08-03 15:17:24.694526	MEDIUM	\N	\N	\N	\N	\N	\N	\N
5	REQ-20260803152255-7793	4	1	\N	5	Software	Software	2026-08-05	600.00	SUBMITTED	2026-08-03 15:22:55.019964	MEDIUM	\N	\N	\N	\N	\N	\N	\N
6	REQ-20260803172041-3751	4	1	\N	5	Software Service	software for dept	2026-08-06	8000.00	SUBMITTED	2026-08-03 17:20:41.715144	MEDIUM	\N	\N	\N	\N	\N	\N	\N
7	REQ-20260803173747-6886	4	1	\N	4	Wood	Table	2026-08-08	25200.00	PENDING_APPROVAL	2026-08-03 17:37:47.605095	MEDIUM	\N	\N	\N	\N	\N	\N	\N
8	REQ-20260803174037-7131	4	1	\N	4	Furniture	Wooden chairs	2026-08-27	25300.00	PENDING_APPROVAL	2026-08-03 17:40:37.545248	MEDIUM	\N	\N	\N	\N	\N	\N	\N
9	REQ-20260803185917-5350	4	1	\N	5	Office Software	Software liscense	2026-08-05	4400.00	PENDING_APPROVAL	2026-08-03 18:59:17.944929	MEDIUM	\N	\N	\N	\N	\N	\N	\N
10	REQ-20260803192454-5816	4	1	2	1	Laptops	We need Intel i5-12500,16gb Ram,512 SSD for our office work 	2026-08-06	1000000.00	ORDER_CREATED	2026-08-03 19:24:54.278795	MEDIUM	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5249 (class 0 OID 18204)
-- Dependencies: 235
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_orders (po_id, po_number, requisition_id, supplier_id, created_date, stage, status, created_at, expected_delivery, actual_delivery, shipping_cost, tax_amount, discount) FROM stdin;
2	PO-2026-002	3	3	2026-07-28	FULLY_DELIVERED	FULLY_DELIVERED	2026-07-26 17:29:07.760916	\N	\N	0.00	0.00	0.00
1	PO-2026-001	2	2	2026-07-28	FULLY_DELIVERED	FULLY_DELIVERED	2026-07-26 17:29:07.760916	\N	\N	0.00	0.00	0.00
7	PO-20260803192454-5816	10	2	2026-08-03	CREATED	CREATED	2026-08-03 19:26:06.675756	\N	\N	0.00	0.00	0.00
\.


--
-- TOC entry 5245 (class 0 OID 18187)
-- Dependencies: 231
-- Data for Name: po_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.po_line_items (po_line_item_id, po_id, description, ordered_qty, received_qty, unit_price) FROM stdin;
3	2	Pens	100	100	15.00
2	2	Printer Paper Bundle	30	40	500.00
1	1	HP EliteDesk Desktop	2	2	60000.00
4	7	HPI5-12500H	5	0	200000.00
\.


--
-- TOC entry 5247 (class 0 OID 18196)
-- Dependencies: 233
-- Data for Name: po_receipts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.po_receipts (receipt_id, po_id, description, qty_received, received_date, received_by) FROM stdin;
1	2	Printer Paper Bundle	20	2026-07-29	5
2	2	Pens	100	2026-07-29	5
3	2	Printer Paper Bundle	20	2026-08-03	\N
4	1	HP EliteDesk Desktop	2	2026-08-03	\N
\.


--
-- TOC entry 5268 (class 0 OID 19506)
-- Dependencies: 254
-- Data for Name: requisition_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requisition_comments (comment_id, requisition_id, user_id, comment, created_at) FROM stdin;
\.


--
-- TOC entry 5270 (class 0 OID 19531)
-- Dependencies: 256
-- Data for Name: requisition_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requisition_documents (document_id, requisition_id, document_name, document_type, document_path, uploaded_by, uploaded_at) FROM stdin;
\.


--
-- TOC entry 5251 (class 0 OID 18213)
-- Dependencies: 237
-- Data for Name: requisition_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requisition_history (history_id, requisition_id, action_by, step, remarks, action_date) FROM stdin;
1	1	4	Created	Requisition Submitted	2026-07-26 17:28:44.322121
2	2	4	Created	Submitted	2026-07-26 17:28:44.322121
3	2	2	Manager Approved	Approved by IT Manager	2026-07-26 17:28:44.322121
4	2	3	Finance Approved	Budget Approved	2026-07-26 17:28:44.322121
5	3	3	Created	Submitted	2026-07-26 17:28:44.322121
6	3	3	Finance Approved	Approved	2026-07-26 17:28:44.322121
7	4	4	Submitted	Request submitted for approval	2026-08-03 15:17:24.731938
8	5	4	Submitted	Request submitted for approval	2026-08-03 15:22:55.023668
9	6	4	Submitted	Request submitted for approval	2026-08-03 17:20:41.740627
10	7	4	Submitted	Request submitted for approval	2026-08-03 17:37:47.634542
11	8	4	Submitted	Request submitted for approval	2026-08-03 17:40:37.549155
12	8	2	Approved	Approved	2026-08-03 17:41:09.77274
14	7	1	Approved	Approved	2026-08-03 17:41:54.78056
15	9	4	Submitted	Request submitted for approval	2026-08-03 18:59:18.031163
16	9	2	Approved	Approved via dashboard	2026-08-03 18:59:45.046899
20	10	4	Submitted	Request submitted for approval	2026-08-03 19:24:54.287316
21	10	2	Approved	Approved via dashboard	2026-08-03 19:25:22.42158
22	10	1	Approved	Approved	2026-08-03 19:26:06.668172
\.


--
-- TOC entry 5253 (class 0 OID 18223)
-- Dependencies: 239
-- Data for Name: requisition_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requisition_line_items (line_item_id, requisition_id, description, quantity, unit_price) FROM stdin;
1	1	Dell Latitude Laptop	1	45000.00
2	2	HP EliteDesk Desktop	2	60000.00
3	3	Printer Paper Bundle	30	500.00
4	3	Pens	100	15.00
5	4	Os	8	10000.00
6	5	Software	30	20.00
7	6	Windows	10	800.00
8	7	Table	1200	21.00
9	8	Bench	1100	23.00
10	9	Matlab	20	220.00
11	10	HPI5-12500H	5	200000.00
\.


--
-- TOC entry 5278 (class 0 OID 19627)
-- Dependencies: 264
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (setting_id, setting_key, setting_value, description, updated_at) FROM stdin;
1	currency	INR	Default procurement currency	2026-08-06 10:06:41.083128
2	financial_year	2026-27	Current financial year	2026-08-06 10:06:41.083128
3	company_name	Enterprise Procurement System	Application display name	2026-08-06 10:06:41.083128
4	po_prefix	PO	Purchase order number prefix	2026-08-06 10:06:41.083128
5	pr_prefix	REQ	Purchase requisition number prefix	2026-08-06 10:06:41.083128
\.


--
-- TOC entry 5276 (class 0 OID 19608)
-- Dependencies: 262
-- Data for Name: supplier_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier_contacts (contact_id, supplier_id, contact_name, designation, email, phone, is_primary, created_at) FROM stdin;
\.


--
-- TOC entry 5261 (class 0 OID 18268)
-- Dependencies: 247
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_role_id, user_id, role_id, created_at) FROM stdin;
1	1	1	2026-07-26 17:26:28.291107
2	2	3	2026-07-26 17:26:28.291107
3	3	4	2026-07-26 17:26:28.291107
4	4	2	2026-07-26 17:26:28.291107
5	5	5	2026-07-26 17:26:28.291107
\.


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 220
-- Name: approval_rule_approvers_rule_approver_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.approval_rule_approvers_rule_approver_id_seq', 4, true);


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 222
-- Name: approval_rules_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.approval_rules_rule_id_seq', 3, true);


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 224
-- Name: audit_logs_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_audit_id_seq', 14, true);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 259
-- Name: budgets_budget_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.budgets_budget_id_seq', 1, false);


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 226
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 5, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 228
-- Name: cost_centers_cost_center_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cost_centers_cost_center_id_seq', 4, true);


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 265
-- Name: dashboard_metrics_metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboard_metrics_metric_id_seq', 1, false);


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 230
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 4, true);


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 257
-- Name: login_history_login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_history_login_id_seq', 1, false);


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 251
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 1, false);


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 232
-- Name: po_line_items_po_line_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.po_line_items_po_line_item_id_seq', 4, true);


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 234
-- Name: po_receipts_receipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.po_receipts_receipt_id_seq', 4, true);


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 236
-- Name: purchase_orders_po_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_orders_po_id_seq', 8, true);


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 253
-- Name: requisition_comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_comments_comment_id_seq', 1, false);


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 255
-- Name: requisition_documents_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_documents_document_id_seq', 1, false);


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 238
-- Name: requisition_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_history_history_id_seq', 23, true);


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 240
-- Name: requisition_line_items_line_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_line_items_line_item_id_seq', 11, true);


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 242
-- Name: requisitions_requisition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisitions_requisition_id_seq', 10, true);


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 244
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 5, true);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 263
-- Name: settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.settings_setting_id_seq', 5, true);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 261
-- Name: supplier_contacts_contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_contacts_contact_id_seq', 1, false);


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 246
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplier_id_seq', 3, true);


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 248
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_user_role_id_seq', 5, true);


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 250
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 5, true);


-- Completed on 2026-08-06 10:11:19

--
-- PostgreSQL database dump complete
--

\unrestrict zuigFYQ3ngcIKgenMI4jaw3U4fndM5WQcfJkayKrw4rMBK6VLBfgtkgHdxrm8Qn

