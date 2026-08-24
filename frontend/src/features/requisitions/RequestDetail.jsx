import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import {
  getRequisitionById,
  getRequisitionHistory,
  getRequisitionLineItems,
} from '../../api/requisitionApi';
import { apiFetch } from '../../api';
import ProcurementTimeline from '../../components/ProcurementTimeline';
import './RequestDetail.css';



/**
 * Two ways to use this component:
 *  1. Route mode (no props): mounted at /requisitions/:id, fetches everything
 *     itself using the id from the URL.
 *  2. Prop mode (`request` + `onBack` passed in): caller (e.g. MyRequests.jsx)
 *     already fetched and pre-formatted the data — just render it inline
 *     without an extra network round-trip or route change.
 */
export default function RequestDetail({ request: propRequest, onBack, user }) {
  const { id } = useParams();
  const navigate = useNavigate();
  const isPropMode = propRequest != null;

  const [requisition, setRequisition] = useState(null);
  const [lineItems, setLineItems] = useState([]);
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(!isPropMode);
  const [error, setError] = useState('');

  const [remarks, setRemarks] = useState('');
  const [actioning, setActioning] = useState(false);
  const [actionError, setActionError] = useState('');

  
  const [suppliers, setSuppliers] = useState([]);
  const [selectedSupplierId, setSelectedSupplierId] = useState('');
  const [savingSupplier, setSavingSupplier] = useState(false);
  const [showRejectModal, setShowRejectModal] = useState(false);

  useEffect(() => {
    if (requisition?.supplier?.supplierId) {
      setSelectedSupplierId(requisition.supplier.supplierId);
    }
  }, [requisition]);


  async function handleVerifySupplier(approved) {
    if (approved && !selectedSupplierId && supplierName === 'Missing') {
      alert("Please select a supplier from the master list before approving.");
      return;
    }
    if (!approved && !remarks.trim()) {
      setActionError("Remarks are required for rejection.");
      return;
    }
    
    setSavingSupplier(true);
    setActionError('');
    try {
      const targetId = isPropMode ? propRequest.requisitionId : requisition?.requisitionId || id;
      
      // If a supplier was newly selected from dropdown, assign it first
      if (approved && selectedSupplierId) {
        await apiFetch(`/api/requisitions/${targetId}/supplier`, {
          method: 'PATCH',
          body: JSON.stringify({ supplierId: selectedSupplierId })
        }, user.token);
      }

      // Then verify
      await apiFetch(`/api/requisitions/${targetId}/supplier/verify`, {
        method: 'POST',
        body: JSON.stringify({ approved, remarks: remarks || 'Verified' })
      }, user.token);
      
      window.location.reload(); 
    } catch (e) {
      alert("Failed to verify supplier: " + e.message);
    } finally {
      setSavingSupplier(false);
    }
  }

  async function handleAction(action) {
    if (action === 'REJECT' && !remarks.trim()) {
      setActionError('Remarks are required for rejection.');
      return;
    }
    setActionError('');
    setActioning(true);

    try {
      const targetId = isPropMode ? propRequest.requisitionId : requisition?.requisitionId || id;
      await apiFetch(
        `/api/requisitions/${targetId}/actions`,
        {
          method: 'POST',
          body: JSON.stringify({ action, remarks: remarks || 'Actioned via detail page' }),
        },
        user.token
      );
      
      if (onBack) {
        onBack();
      } else {
        navigate('/approvals');
      }
    } catch (err) {
      setActionError(err.message || 'Action failed.');
    } finally {
      setActioning(false);
    }
  }

  useEffect(() => {
    if (isPropMode || !id) return;
    async function fetchAll() {
      try {
        setLoading(true);
        setError('');
        const promises = [
          getRequisitionById(id),
          getRequisitionHistory(id),
          getRequisitionLineItems(id),
        ];
        // Only fetch suppliers if admin
        const adminCheck = user && (user.roles?.includes('ROLE_Admin') || user.role === 'Admin' || user.role === 'Procurement Admin');
        if (adminCheck) {
            promises.push(apiFetch('/api/suppliers', {}, user.token));
        }

        const results = await Promise.all(promises);
        setRequisition(results[0]);
        setHistory(results[1]);
        setLineItems(results[2]);
        if (adminCheck && results[3]) {
            setSuppliers(results[3].filter(s => s.status === 'ACTIVE'));
        }
      } catch (err) {
        console.error('Failed to fetch requisition data:', err);
        setError('Failed to load requisition details. Please try again later.');
      } finally {
        setLoading(false);
      }
    }
    fetchAll();
  }, [id, isPropMode, user]);

  if (loading) {
    return (
      <div className="detail-page-loading" style={{ textAlign: "center", padding: "40px" }}>
        <p>Loading requisition details...</p>
      </div>
    );
  }

  if (error || (!isPropMode && !requisition)) {
    return (
      <div className="detail-page-error" style={{ padding: "40px", textAlign: "center" }}>
        <p style={{ color: '#dc2626', fontWeight: 600 }}>{error || "Requisition not found."}</p>
        <button className="btn-secondary" onClick={() => navigate(-1)} style={{ marginTop: "12px" }}>Back</button>
      </div>
    );
  }

  // Normalize details based on source mode
  let displayId, displayTitle, displayStatus, displayLineItems, displayHistory;
  let submittedDate, submittedBy;
  let rawJustification = '';
  let categoryName = '—';
  let supplierName = 'Direct';
  let departmentName = '—';
  let neededDate = '—';

  if (isPropMode) {
    displayId = propRequest.id;
    displayTitle = propRequest.title;
    displayStatus = propRequest.status;
    displayLineItems = (propRequest.items || []).map((item, idx) => ({
      lineItemId: idx,
      description: item.description,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
    }));
    displayHistory = (propRequest.history || []).map((h) => ({
      step: h.step,
      actionedBy: h.actionedBy,
      remarks: h.remarks,
      date: h.date,
    }));
  } else {
    displayId = requisition.requisitionNumber || `Requisition #${requisition.requisitionId}`;
    displayTitle = requisition.title;
    displayStatus = requisition.status;
    displayLineItems = lineItems;
    displayHistory = history.map((h) => ({
      step: h.step,
      actionedBy: h.actionBy?.fullName || h.actionBy?.username || null,
      remarks: h.remarks,
      date: h.actionDate ? new Date(h.actionDate).toLocaleDateString() : null,
    }));
    submittedDate = requisition.createdAt ? new Date(requisition.createdAt).toLocaleDateString() : null;
    submittedBy = requisition.createdBy?.fullName || requisition.createdBy?.username;
    rawJustification = requisition.justification || '';
    categoryName = requisition.category?.categoryName || '—';
    const hasSupplier = requisition.supplier != null;
    supplierName = hasSupplier ? requisition.supplier.supplierName : 'Missing';
    departmentName = requisition.department?.departmentName || '—';
    neededDate = requisition.neededBy || '—';
  }

  // Parse structured justification JSON if present
  let justificationText = rawJustification;
  let projectCode = '—';
  let budgetCode = '—';
  let deliveryAddress = '—';
  let attachmentName = '';
  let internalRemarks = '—';
  let preferredSupplierName = null;

  try {
    if (rawJustification && rawJustification.startsWith('{')) {
      const parsed = JSON.parse(rawJustification);
      justificationText = parsed.justification || '';
      projectCode = parsed.projectCode || '—';
      budgetCode = parsed.budgetCode || '—';
      deliveryAddress = parsed.deliveryAddress || '—';
      attachmentName = parsed.attachmentName || '';
      internalRemarks = parsed.remarks || '—';
      preferredSupplierName = parsed.preferredSupplierName || null;
    }
  } catch {
    // Treat as raw text
  }

  const badgeClass = displayStatus ? displayStatus.toLowerCase().replace(/_/g, '-') : 'pending';
  const totalAmount = displayLineItems.reduce(
    (sum, item) => sum + (item.quantity || 0) * (item.unitPrice || 0),
    0
  );

  const isActionable = user && (
    user.roles?.includes('ROLE_Manager') || 
    user.roles?.includes('ROLE_Finance') || 
    user.roles?.includes('ROLE_Admin') ||
    user.role === 'Manager' || 
    user.role === 'Finance' || 
    user.role === 'Admin' || 
    user.role === 'Approver' ||
    user.role === 'Procurement Admin'
  );

  const isAdmin = user && (
    user.roles?.includes('ROLE_Admin') || 
    user.role === 'Admin' || 
    user.role === 'Procurement Admin'
  );

  const supplierVerificationNode = (displayStatus === 'AWAITING_SUPPLIER_ASSIGNMENT' && isAdmin) ? (
    <>
      {showRejectModal && (
        <div className="modal-overlay" style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
          <div style={{ backgroundColor: '#fff', padding: '24px', borderRadius: '8px', width: '100%', maxWidth: '400px' }}>
            <h3 style={{ marginTop: 0, color: '#dc2626' }}>Reject Supplier</h3>
            <div style={{ marginBottom: '16px' }}>
              <label style={{ display: 'block', fontSize: '14px', fontWeight: 500, marginBottom: '8px' }}>Reason:</label>
              <textarea
                className="form-control"
                placeholder="Enter rejection reason..."
                value={remarks}
                onChange={(e) => setRemarks(e.target.value)}
                rows={3}
                style={{ width: '100%', fontSize: '14px', padding: '8px' }}
              />
            </div>
            {actionError && <div className="error-alert" style={{ marginBottom: '16px', fontSize: '13px' }}>{actionError}</div>}
            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px' }}>
              <button className="btn-secondary" onClick={() => { setShowRejectModal(false); setActionError(''); }}>Cancel</button>
              <button 
                className="btn-primary" 
                onClick={() => handleVerifySupplier(false)} 
                disabled={savingSupplier}
                style={{ backgroundColor: '#dc2626' }}
              >
                {savingSupplier ? 'Processing...' : 'Reject Supplier'}
              </button>
            </div>
          </div>
        </div>
      )}

      <div style={{ marginTop: '12px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
        <div>
          <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: '#374151', marginBottom: '4px' }}>Supplier:</label>
          <select 
             value={selectedSupplierId}
             onChange={e => setSelectedSupplierId(e.target.value)}
             style={{ padding: '6px', fontSize: '13px', borderRadius: '4px', border: '1px solid #d1d5db', width: '100%' }}
          >
             {supplierName === 'Missing' && preferredSupplierName && <option value="">{preferredSupplierName}</option>}
             {supplierName === 'Missing' && !preferredSupplierName && <option value="">-- Select Supplier --</option>}
             {suppliers.map(s => <option key={s.supplierId} value={s.supplierId}>{s.supplierName}</option>)}
          </select>
        </div>

        {actionError && !showRejectModal && <div className="error-alert" style={{ fontSize: '12px', padding: '6px' }}>{actionError}</div>}
        
        <div style={{ display: 'flex', gap: '8px' }}>
          <button 
            className="btn-primary" 
            onClick={() => handleVerifySupplier(true)} 
            disabled={savingSupplier}
            style={{ backgroundColor: '#16a34a', flex: 1, padding: '6px', fontSize: '12px', justifyContent: 'center' }}
          >
            {savingSupplier ? 'Processing...' : '✓ Approve Supplier'}
          </button>
          <button 
            className="btn-secondary" 
            onClick={() => setShowRejectModal(true)} 
            disabled={savingSupplier}
            style={{ color: '#dc2626', borderColor: '#f87171', flex: 1, padding: '6px', fontSize: '12px', justifyContent: 'center' }}
          >
            ✕ Reject Supplier
          </button>
        </div>
      </div>
    </>
  ) : null;

  return (
    <div className="requisition-detail-page">
      {/* Header section with PR summary */}
      <div className="detail-header-section">
        <button className="btn-back-link" onClick={onBack || (() => navigate(-1))}>
          &larr; Back to Requisitions List
        </button>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '12px' }}>
          <div>
            <h1 className="detail-title">{displayId}</h1>
            <p className="detail-title-desc">{displayTitle}</p>
          </div>
          <span className={`status-badge status-${badgeClass}`}>
            {(displayStatus || '').replace(/_/g, ' ')}
          </span>
        </div>
      </div>

      {/* Two column Grid layout */}
      <div className="detail-grid">
        {/* Left main content details column */}
        <div className="detail-col-main">
          {/* Card 1: Core metadata */}
          <div className="detail-card">
            <h3>Requisition Details</h3>
            <div className="meta-details-grid">
              <div className="meta-field">
                <span className="field-lbl">Department</span>
                <span className="field-val">{departmentName}</span>
              </div>
              <div className="meta-field">
                <span className="field-lbl">Procurement Category</span>
                <span className="field-val">{categoryName}</span>
              </div>
              <div className="meta-field">
                <span className="field-lbl">Preferred Supplier</span>
                <span className="field-val">
                  {supplierName !== 'Missing' ? (
                     supplierName
                  ) : preferredSupplierName ? (
                     <span style={{ color: '#d97706', fontWeight: 600 }}>{preferredSupplierName} (Unverified Entry)</span>
                  ) : (
                     <span style={{ color: '#ef4444', fontWeight: 600 }}>Not Provided</span>
                  )}
                </span>
              </div>
              <div className="meta-field">
                <span className="field-lbl">Required Date</span>
                <span className="field-val">{neededDate}</span>
              </div>
            </div>

            {justificationText && (
              <div style={{ marginTop: '16px', borderTop: '1px solid #f3f4f6', paddingTop: '16px' }}>
                <span className="field-lbl">Business Justification</span>
                <p style={{ margin: '4px 0 0 0', fontSize: '14px', color: '#4b5563', lineHeight: '1.5' }}>
                  {justificationText}
                </p>
              </div>
            )}
          </div>

          {/* Card 2: Requested Items Table */}
          <div className="detail-card">
            <h3>Requested Line Items</h3>
            <table className="items-detail-table">
              <thead>
                <tr>
                  <th>Item Details / Specifications</th>
                  <th style={{ textAlign: 'right' }}>Quantity</th>
                  <th style={{ textAlign: 'right' }}>Unit Price</th>
                  <th style={{ textAlign: 'right' }}>Line Total</th>
                </tr>
              </thead>
              <tbody>
                {displayLineItems.length === 0 ? (
                  <tr>
                    <td colSpan="4" style={{ textAlign: 'center', color: '#9ca3af', padding: '16px' }}>
                      No items requested.
                    </td>
                  </tr>
                ) : (
                  displayLineItems.map((item, idx) => (
                    <tr key={item.lineItemId || idx}>
                      <td><strong>{item.description}</strong></td>
                      <td style={{ textAlign: 'right' }}>{item.quantity}</td>
                      <td style={{ textAlign: 'right' }}>₹ {(item.unitPrice || 0).toLocaleString()}</td>
                      <td style={{ textAlign: 'right' }}>
                        ₹ {((item.quantity || 0) * (item.unitPrice || 0)).toLocaleString()}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
              {displayLineItems.length > 0 && (
                <tfoot>
                  <tr>
                    <td colSpan="3" style={{ textAlign: 'right', fontWeight: '600', color: '#4b5563' }}>Requisition Total</td>
                    <td style={{ textAlign: 'right', fontWeight: '700', color: '#111827', fontSize: '16px' }}>
                      ₹ {totalAmount.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                    </td>
                  </tr>
                </tfoot>
              )}
            </table>
          </div>

          {/* Card 3: Allocations & Codes */}
          <div className="detail-card">
            <h3>Logistics & Financial Allocations</h3>
            <div className="meta-details-grid">
              <div className="meta-field">
                <span className="field-lbl">Cost Center / Project Code</span>
                <span className="field-val">{projectCode}</span>
              </div>
              <div className="meta-field">
                <span className="field-lbl">GL Budget Code</span>
                <span className="field-val">{budgetCode}</span>
              </div>
              <div className="meta-field col-span-2">
                <span className="field-lbl">Warehouse Delivery Address</span>
                <span className="field-val">{deliveryAddress}</span>
              </div>
            </div>

            {internalRemarks && internalRemarks !== '—' && (
              <div style={{ marginTop: '16px', borderTop: '1px solid #f3f4f6', paddingTop: '16px' }}>
                <span className="field-lbl">Internal Remarks</span>
                <p style={{ margin: '4px 0 0 0', fontSize: '13px', color: '#6b7280' }}>
                  {internalRemarks}
                </p>
              </div>
            )}
          </div>

          {/* Card 4: Attachments */}
          {attachmentName && (
            <div className="detail-card">
              <h3>Documentation Attachments</h3>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 16px', border: '1px solid #e5e7eb', borderRadius: '6px', backgroundColor: '#f9fafb' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                  <span style={{ fontSize: '20px' }}>📄</span>
                  <div>
                    <strong style={{ fontSize: '13px', display: 'block', color: '#1f2937' }}>{attachmentName}</strong>
                    <span style={{ fontSize: '11px', color: '#9ca3af' }}>Vendor Quote Attachment</span>
                  </div>
                </div>
                <button
                  onClick={() => alert(`Downloading quote document: ${attachmentName}`)}
                  style={{
                    backgroundColor: '#ffffff', border: '1px solid #d1d5db', borderRadius: '4px',
                    padding: '6px 12px', fontSize: '12px', cursor: 'pointer', fontWeight: '600'
                  }}
                >
                  Download Quote
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Right timeline and approvals action column */}
        <div className="detail-col-sidebar">
          {/* Card 5: Timeline Progress */}
          <div className="detail-card">
            <h3>Approval Progress</h3>
            <ProcurementTimeline
              status={displayStatus}
              historyEvents={displayHistory}
              submittedDate={submittedDate}
              submittedBy={submittedBy}
              supplierVerificationNode={supplierVerificationNode}
            />
          </div>

          {/* Card 6: Action Panel */}
          {isActionable && displayStatus === 'PENDING_APPROVAL' && (
            <div className="detail-card approval-actions-card" style={{ borderLeft: '4px solid #d97706' }}>
              <h3 style={{ color: '#d97706' }}>Authorization Actions</h3>
              <p style={{ fontSize: '12px', color: '#6b7280', margin: '4px 0 16px 0' }}>
                You hold sign-off authority for this requisition. Provide remarks below to record your decision.
              </p>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '12px', fontWeight: '600', color: '#374151', marginBottom: '6px' }}>
                    Remarks / Audit Log Comments {actionError && <span style={{ color: '#dc2626' }}>*</span>}
                  </label>
                  <textarea
                    placeholder="Provide audit context or instructions..."
                    value={remarks}
                    onChange={(e) => setRemarks(e.target.value)}
                    rows="3"
                    style={{
                      width: '100%', padding: '10px', borderRadius: '6px', border: '1px solid #d1d5db',
                      fontSize: '13px', boxSizing: 'border-box', outline: 'none', fontFamily: 'inherit'
                    }}
                  />
                </div>

                {actionError && (
                  <p style={{ color: '#dc2626', fontSize: '13px', margin: 0, fontWeight: '500' }}>
                    ⚠️ {actionError}
                  </p>
                )}

                <div style={{ display: 'flex', gap: '8px' }}>
                  <button
                    className="btn-approve-card"
                    onClick={() => handleAction('APPROVE')}
                    disabled={actioning}
                    style={{ flex: 1, padding: '10px', fontSize: '13px' }}
                  >
                    {actioning ? 'Processing...' : '✓ Approve'}
                  </button>
                  <button
                    className="btn-return-card"
                    onClick={() => handleAction('RETURN')}
                    disabled={actioning}
                    style={{ flex: 1, padding: '10px', fontSize: '13px', backgroundColor: '#f59e0b', color: '#fff', border: 'none', borderRadius: '6px', cursor: 'pointer', fontWeight: '500' }}
                  >
                    {actioning ? 'Processing...' : '↩ Return'}
                  </button>
                  <button
                    className="btn-reject-card"
                    onClick={() => handleAction('REJECT')}
                    disabled={actioning}
                    style={{ flex: 1, padding: '10px', fontSize: '13px' }}
                  >
                    {actioning ? 'Processing...' : '✕ Reject'}
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
