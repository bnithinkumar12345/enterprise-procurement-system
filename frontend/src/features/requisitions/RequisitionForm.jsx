import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { apiFetch } from "../../api";
import { 
  Plus, 
  Trash2, 
  CheckCircle2, 
  FileText, 
  Building, 
  ShoppingCart, 
  Clock, 
  ChevronRight, 
  ArrowLeft 
} from "lucide-react";
import "./RequisitionForm.css";

export default function RequisitionForm({ user }) {
  const navigate = useNavigate();

  // Tab State: 'header' | 'allocations' | 'items' | 'review'
  const [activeTab, setActiveTab] = useState('header');

  // Form Fields State
  const [title, setTitle] = useState("");
  const [categoryId, setCategoryId] = useState("");
  const [supplierId, setSupplierId] = useState("");
  const [priority, setPriority] = useState("MEDIUM");
  const [neededBy, setNeededBy] = useState("");
  const [justification, setJustification] = useState("");
  const [projectCode, setProjectCode] = useState("");
  const [budgetCode, setBudgetCode] = useState("");
  const [deliveryAddress, setDeliveryAddress] = useState("");
  const [attachmentName, setAttachmentName] = useState("");
  const [remarks, setRemarks] = useState("");

  const [approvalChain, setApprovalChain] = useState([]);
  const [loadingChain, setLoadingChain] = useState(false);
  const [categories, setCategories] = useState([]);
  const [suppliers, setSuppliers] = useState([]);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [previewError, setPreviewError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  // Line items state
  const [lines, setLines] = useState([
    { description: "", quantity: 1, unitPrice: 0 },
  ]);

  // Load dropdown lists on mount
  useEffect(() => {
    async function loadDropdowns() {
      try {
        const [cats, sups] = await Promise.all([
          apiFetch("/api/categories", {}, user.token),
          apiFetch("/api/suppliers", {}, user.token),
        ]);
        setCategories(cats.filter((c) => c.status === "ACTIVE"));
        setSuppliers(sups.filter((s) => s.status === "ACTIVE"));
      } catch {
        setError("Failed to load category or supplier database entries.");
      }
    }
    loadDropdowns();
  }, [user.token]);

  const estimatedTotal = calculateTotal();

  // Dynamic preview timeline matches on Category or total Amount change
  useEffect(() => {
    if (!categoryId || estimatedTotal <= 0) {
      setApprovalChain([]);
      setPreviewError("");
      return;
    }

    let isMounted = true;
    async function fetchPreview() {
      setLoadingChain(true);
      try {
        const data = await apiFetch(
          `/api/requisitions/preview-approval?categoryId=${categoryId}&amount=${estimatedTotal}`,
          {},
          user.token
        );
        if (isMounted) {
          setApprovalChain(data);
          setPreviewError("");
        }
      } catch (err) {
        console.error("Failed to load approval chain preview", err);
        if (isMounted) {
          setApprovalChain([]);
          setPreviewError("No approval rule found for this Department, Category, and Amount.");
        }
      } finally {
        if (isMounted) {
          setLoadingChain(false);
        }
      }
    }

    const timer = setTimeout(() => {
      fetchPreview();
    }, 400);

    return () => {
      isMounted = false;
      clearTimeout(timer);
    };
  }, [categoryId, estimatedTotal, user.token]);

  function calculateTotal() {
    return lines.reduce((total, line) => {
      const qty = parseFloat(line.quantity) || 0;
      const price = parseFloat(line.unitPrice) || 0;
      return total + qty * price;
    }, 0);
  }

  function addLine() {
    setLines([...lines, { description: "", quantity: 1, unitPrice: 0 }]);
  }

  function removeLine(index) {
    setLines(lines.filter((_, i) => i !== index));
  }

  function updateLine(index, field, value) {
    setLines(
      lines.map((line, i) => (i === index ? { ...line, [field]: value } : line))
    );
  }

  const handleAttachmentChange = (e) => {
    if (e.target.files && e.target.files[0]) {
      setAttachmentName(e.target.files[0].name);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");

    if (!title || !neededBy || !categoryId || !supplierId) {
      setError("Requisition Title, Category, Supplier, and Needed By Date are required.");
      return;
    }

    const invalidLine = lines.some(
      (l) => !l.description || parseFloat(l.quantity) <= 0 || parseFloat(l.unitPrice) < 0
    );
    if (invalidLine) {
      setError("Please ensure all line items have description, valid quantity (>0) and price (>=0).");
      return;
    }

    setSubmitting(true);

    try {
      // Serialize structured enterprise fields inside the justification column
      const structuredJustification = JSON.stringify({
        justification,
        projectCode,
        budgetCode,
        deliveryAddress,
        attachmentName,
        remarks,
      });

      const payload = {
        title,
        justification: structuredJustification,
        neededBy,
        categoryId: parseInt(categoryId),
        supplierId: supplierId ? parseInt(supplierId) : null,
        priority,
        items: lines.map((line) => ({
          description: line.description,
          quantity: parseInt(line.quantity),
          unitPrice: parseFloat(line.unitPrice),
        })),
      };

      const result = await apiFetch(
        "/api/requisitions",
        {
          method: "POST",
          body: JSON.stringify(payload),
        },
        user.token
      );

      setSuccess(`Requisition ${result.requisitionNumber} successfully submitted for approval routing!`);
      
      // Reset form
      setTitle("");
      setCategoryId("");
      setSupplierId("");
      setPriority("MEDIUM");
      setNeededBy("");
      setJustification("");
      setProjectCode("");
      setBudgetCode("");
      setDeliveryAddress("");
      setAttachmentName("");
      setRemarks("");
      setLines([{ description: "", quantity: 1, unitPrice: 0 }]);
      
      setTimeout(() => {
        navigate("/requisitions");
      }, 1500);

    } catch (err) {
      setError(err.message || "Failed to submit purchase requisition.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="requisition-form-page">
      <div className="page-header-container">
        <div>
          <h1 className="page-title">New Purchase Requisition</h1>
          <p className="page-subtext">Submit a cost request for materials, software, or external services</p>
        </div>
      </div>

      {success && (
        <div className="alert alert-success" style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '24px' }}>
          <CheckCircle2 size={18} />
          <span>{success}</span>
        </div>
      )}

      {error && (
        <div className="alert alert-danger" style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '24px' }}>
          <span>⚠️ {error}</span>
        </div>
      )}

      {/* Tabs selectors row */}
      <div className="form-tabs-header">
        <button 
          type="button" 
          className={`tab-btn-trigger ${activeTab === 'header' ? 'active' : ''}`}
          onClick={() => setActiveTab('header')}
        >
          <FileText size={16} />
          <span>1. Header Info</span>
        </button>
        <button 
          type="button" 
          className={`tab-btn-trigger ${activeTab === 'allocations' ? 'active' : ''}`}
          onClick={() => setActiveTab('allocations')}
        >
          <Building size={16} />
          <span>2. Allocations</span>
        </button>
        <button 
          type="button" 
          className={`tab-btn-trigger ${activeTab === 'items' ? 'active' : ''}`}
          onClick={() => setActiveTab('items')}
        >
          <ShoppingCart size={16} />
          <span>3. Line Items</span>
        </button>
        <button 
          type="button" 
          className={`tab-btn-trigger ${activeTab === 'review' ? 'active' : ''}`}
          onClick={() => setActiveTab('review')}
        >
          <Clock size={16} />
          <span>4. Routing Review</span>
        </button>
      </div>

      <form onSubmit={handleSubmit} className="requisition-form-grid">
        {/* Left Form Content */}
        <div className="form-main-content">
          
          {/* Tab 1: Header Information */}
          {activeTab === 'header' && (
            <div className="form-card animate-fade">
              <h3>1. Header Information</h3>
              
              <div className="form-group" style={{ marginBottom: '16px' }}>
                <label>Requisition Title / Subject *</label>
                <input
                  type="text"
                  placeholder="e.g. Q3 Software License renewals"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  required
                />
              </div>

              <div className="form-row-split">
                <div className="form-group">
                  <label>Procurement Category *</label>
                  <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)} required>
                    <option value="">Select Category...</option>
                    {categories.map((c) => (
                      <option key={c.categoryId} value={c.categoryId}>{c.categoryName}</option>
                    ))}
                  </select>
                </div>

                <div className="form-group">
                  <label>Supplier *</label>
                  <select value={supplierId} onChange={(e) => setSupplierId(e.target.value)}>
                    <option value="">Direct / Select Supplier...</option>
                    {suppliers.map((s) => (
                      <option key={s.supplierId} value={s.supplierId}>{s.supplierName}</option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="form-row-split" style={{ marginTop: '12px' }}>
                <div className="form-group">
                  <label>Priority Level</label>
                  <select value={priority} onChange={(e) => setPriority(e.target.value)}>
                    <option value="LOW">Low (Routine)</option>
                    <option value="MEDIUM">Medium (Standard)</option>
                    <option value="HIGH">High (Urgent)</option>
                    <option value="CRITICAL">Critical (Immediate Action)</option>
                  </select>
                </div>

                <div className="form-group">
                  <label>Required Date *</label>
                  <input
                    type="date"
                    value={neededBy}
                    onChange={(e) => setNeededBy(e.target.value)}
                    required
                  />
                </div>
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '24px' }}>
                <button type="button" className="btn-enterprise primary" onClick={() => setActiveTab('allocations')} style={{ height: '40px' }}>
                  <span>Next: Allocations</span>
                  <ChevronRight size={16} />
                </button>
              </div>
            </div>
          )}

          {/* Tab 2: Allocations & Logistics */}
          {activeTab === 'allocations' && (
            <div className="form-card animate-fade">
              <h3>2. Cost Allocations & Logistics</h3>
              
              <div className="form-row-split">
                <div className="form-group">
                  <label>Project Cost Code</label>
                  <input
                    type="text"
                    placeholder="e.g. PRJ-2026-ENG"
                    value={projectCode}
                    onChange={(e) => setProjectCode(e.target.value)}
                  />
                </div>

                <div className="form-group">
                  <label>GL Budget Code</label>
                  <input
                    type="text"
                    placeholder="e.g. GL-5400-IT"
                    value={budgetCode}
                    onChange={(e) => setBudgetCode(e.target.value)}
                  />
                </div>
              </div>

              <div className="form-group" style={{ marginTop: "12px", marginBottom: "12px" }}>
                <label>Delivery Address / Warehouse Dock</label>
                <textarea
                  rows="2"
                  placeholder="Central Warehouse Dock B, Tech City Campus..."
                  value={deliveryAddress}
                  onChange={(e) => setDeliveryAddress(e.target.value)}
                />
              </div>

              <div className="form-group">
                <label>Business Justification (Why is this required?)</label>
                <textarea
                  rows="3"
                  placeholder="Provide audit description of why this is needed..."
                  value={justification}
                  onChange={(e) => setJustification(e.target.value)}
                />
              </div>

              <div className="form-row-split" style={{ marginTop: "12px" }}>
                <div className="form-group">
                  <label>Quote / SLA Attachment (PDF/Image)</label>
                  <div className="file-input-wrapper">
                    <input type="file" id="fileQuote" onChange={handleAttachmentChange} style={{ display: "none" }} />
                    <label htmlFor="fileQuote" className="btn-file-select" style={{ height: '44px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      {attachmentName ? "Attached: " + attachmentName : "Attach Quote Document..."}
                    </label>
                  </div>
                </div>

                <div className="form-group">
                  <label>Internal Remarks / Notes</label>
                  <input
                    type="text"
                    placeholder="Additional logistics notes..."
                    value={remarks}
                    onChange={(e) => setRemarks(e.target.value)}
                    style={{ height: '44px' }}
                  />
                </div>
              </div>

              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '24px' }}>
                <button type="button" className="btn-enterprise secondary" onClick={() => setActiveTab('header')} style={{ height: '40px' }}>
                  <ArrowLeft size={16} style={{ marginRight: '8px' }} />
                  <span>Back</span>
                </button>
                <button type="button" className="btn-enterprise primary" onClick={() => setActiveTab('items')} style={{ height: '40px' }}>
                  <span>Next: Line Items</span>
                  <ChevronRight size={16} />
                </button>
              </div>
            </div>
          )}

          {/* Tab 3: Line Items */}
          {activeTab === 'items' && (
            <div className="form-card animate-fade">
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
                <h3 style={{ margin: 0 }}>3. Requested Items</h3>
                <button type="button" className="btn-enterprise secondary" onClick={addLine} style={{ height: '36px', padding: '0 12px' }}>
                  <Plus size={14} /> Add Line Item
                </button>
              </div>

              <div className="line-items-header">
                <span className="col-desc">Item Description</span>
                <span className="col-qty">Qty</span>
                <span className="col-price">Unit Price</span>
                <span className="col-total">Line Total</span>
                <span className="col-action"></span>
              </div>

              <div className="line-items-list">
                {lines.map((line, index) => {
                  const total = (parseFloat(line.quantity) || 0) * (parseFloat(line.unitPrice) || 0);
                  return (
                    <div key={index} className="line-item-row">
                      <div className="col-desc">
                        <input
                          type="text"
                          placeholder="Item name / specification..."
                          value={line.description}
                          onChange={(e) => updateLine(index, "description", e.target.value)}
                          required
                        />
                      </div>
                      <div className="col-qty">
                        <input
                          type="number"
                          min="1"
                          value={line.quantity}
                          onChange={(e) => updateLine(index, "quantity", e.target.value)}
                          required
                        />
                      </div>
                      <div className="col-price">
                        <input
                          type="number"
                          min="0"
                          step="0.01"
                          placeholder="0.00"
                          value={line.unitPrice}
                          onChange={(e) => updateLine(index, "unitPrice", e.target.value)}
                          required
                        />
                      </div>
                      <div className="col-total">
                        <span>₹ {total.toLocaleString(undefined, { minimumFractionDigits: 2 })}</span>
                      </div>
                      <div className="col-action">
                        <button
                          type="button"
                          className="btn-remove-line"
                          onClick={() => removeLine(index)}
                          disabled={lines.length === 1}
                        >
                          <Trash2 size={14} />
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="requisition-form-summary">
                <span>Estimated Request Total</span>
                <strong>₹ {estimatedTotal.toLocaleString(undefined, { minimumFractionDigits: 2 })}</strong>
              </div>

              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '24px' }}>
                <button type="button" className="btn-enterprise secondary" onClick={() => setActiveTab('allocations')} style={{ height: '40px' }}>
                  <ArrowLeft size={16} style={{ marginRight: '8px' }} />
                  <span>Back</span>
                </button>
                <button type="button" className="btn-enterprise primary" onClick={() => setActiveTab('review')} style={{ height: '40px' }}>
                  <span>Next: Routing Review</span>
                  <ChevronRight size={16} />
                </button>
              </div>
            </div>
          )}

          {/* Tab 4: Final Routing Review & Submission */}
          {activeTab === 'review' && (
            <div className="form-card animate-fade">
              <h3>4. Final Review & Approval Chain</h3>
              
              <div style={{ backgroundColor: 'var(--bg-color)', padding: '20px', borderRadius: '12px', border: '1px solid var(--border-color)', marginBottom: '24px' }}>
                <h4 style={{ fontSize: '14px', fontWeight: '700', marginBottom: '12px' }}>Summary of Purchase Request</h4>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', fontSize: '13px' }}>
                  <div><span>Title:</span> <strong>{title || '—'}</strong></div>
                  <div><span>Needed Date:</span> <strong>{neededBy || '—'}</strong></div>
                  <div><span>Priority:</span> <strong style={{ color: 'var(--primary-color)' }}>{priority}</strong></div>
                  <div><span>Total Lines Amount:</span> <strong style={{ fontSize: '14px' }}>₹ {estimatedTotal.toLocaleString()}</strong></div>
                </div>
              </div>

              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '24px' }}>
                <button type="button" className="btn-enterprise secondary" onClick={() => navigate("/requisitions")} style={{ height: '40px' }}>
                  <span>Cancel</span>
                </button>
                
                <div style={{ display: 'flex', gap: '12px' }}>
                  <button type="button" className="btn-enterprise secondary" onClick={() => setActiveTab('items')} style={{ height: '40px' }}>
                    <ArrowLeft size={16} style={{ marginRight: '8px' }} />
                    <span>Back</span>
                  </button>
                  
                  <button type="submit" className="btn-enterprise primary" disabled={submitting} style={{ height: '40px' }}>
                    {submitting ? "Submitting..." : "Submit Requisition"}
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Right Preview Timeline */}
        <div className="form-preview-panel">
          <div className="sticky-preview-card">
            <h3>Approval Routing Path</h3>
            <p className="preview-help-text">Preview timeline based on active category limits</p>

            {loadingChain ? (
              <div className="preview-state-message">
                <span className="spinner"></span>
                <p>Recalculating routing preview...</p>
              </div>
            ) : previewError ? (
              <div className="preview-state-message empty" style={{ color: "#b91c1c", backgroundColor: "#fef2f2", borderColor: "#fecaca" }}>
                <p>{previewError}</p>
              </div>
            ) : approvalChain.length === 0 ? (
              <div className="preview-state-message empty">
                <p>Select a Category and add requested items to display the approval sequence timeline.</p>
              </div>
            ) : (
              <div className="preview-timeline-wrapper">
                <div className="timeline-step requester-step">
                  <div className="badge-col">
                    <span className="badge-dot active">✓</span>
                    <span className="timeline-connector active"></span>
                  </div>
                  <div className="content-col">
                    <h4>Requester Submitted</h4>
                    <p>{user?.fullName || user?.username}</p>
                  </div>
                </div>

                {approvalChain.map((roleName, idx) => {
                  const isLast = idx === approvalChain.length - 1;
                  return (
                    <div key={idx} className="timeline-step">
                      <div className="badge-col">
                        <span className="badge-dot">{idx + 1}</span>
                        {!isLast && <span className="timeline-connector"></span>}
                      </div>
                      <div className="content-col">
                        <h4>{roleName} Review</h4>
                        <p>Limit Threshold Level {idx + 1}</p>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </form>
    </div>
  );
}