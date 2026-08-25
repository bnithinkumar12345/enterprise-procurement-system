import { Check, X, User, Clock } from 'lucide-react';
import './ProcurementTimeline.css';

export default function ProcurementTimeline({ status, historyEvents = [], submittedDate, submittedBy }) {
  const isRejected = status === 'REJECTED';
  const isOrderCreated = status === 'ORDER_CREATED';
  const isApproved = status === 'APPROVED' || isOrderCreated;
  const isReceived = status === 'RECEIVED';
  const isPending = status === 'PENDING_APPROVAL';

  // Build timeline steps
  const steps = [
    {
      title: 'Submitted',
      description: 'Requisition created and sent for review.',
      actionedBy: submittedBy || 'Requester',
      date: submittedDate,
      state: 'completed',
    },
  ];

  historyEvents.forEach((event) => {
    const rejected = event.step === 'Rejected' || event.remarks?.toLowerCase().includes('reject');
    steps.push({
      title: rejected ? 'Rejected' : 'Approved',
      description: event.remarks || (rejected ? 'This request was rejected.' : 'Signed off by approver.'),
      actionedBy: event.actionedBy,
      date: event.date,
      state: rejected ? 'rejected' : 'completed',
    });
  });

  if (isPending) {
    steps.push({
      title: 'Awaiting Sign-off',
      description: 'Pending signature review in cost-center routing.',
      actionedBy: 'Assigned Sequence',
      date: null,
      state: 'active',
    });
  }

  // PO Generation Step
  if (isApproved || isReceived) {
    steps.push({
      title: 'Purchase Order Generated',
      description: 'PO document auto-released to vendor system.',
      actionedBy: 'System Engine',
      date: null,
      state: 'completed',
    });
  } else if (!isRejected) {
    steps.push({
      title: 'Purchase Order Release',
      description: 'Will generate automatically once fully approved.',
      actionedBy: 'System Engine',
      date: null,
      state: 'upcoming',
    });
  }

  // Goods Receiving Step
  if (isReceived) {
    steps.push({
      title: 'Goods Received',
      description: 'Shipment received, verified, and closed.',
      actionedBy: 'Warehouse Desk',
      date: null,
      state: 'completed',
    });
  } else if (!isRejected) {
    steps.push({
      title: 'Goods Verification',
      description: 'Awaiting delivery receipt log.',
      actionedBy: 'Warehouse Desk',
      date: null,
      state: 'upcoming',
    });
  }

  return (
    <div className="timeline-container">
      {steps.map((step, index) => {
        const initials = step.actionedBy ? step.actionedBy.substring(0, 2).toUpperCase() : 'CC';
        return (
          <div key={index} className={`timeline-step-row timeline-step-${step.state}`}>
            <div className="timeline-badge-column">
              <div className="timeline-avatar-circle">
                {step.state === 'completed' ? (
                  <Check size={14} className="badge-check-icon" />
                ) : step.state === 'rejected' ? (
                  <X size={14} className="badge-reject-icon" />
                ) : step.state === 'active' ? (
                  <Clock size={14} className="badge-active-icon animate-pulse" />
                ) : (
                  <span className="badge-initials">{initials}</span>
                )}
              </div>
              {index !== steps.length - 1 && (
                <div className={`timeline-connector-line ${step.state === 'completed' ? 'completed' : ''}`} />
              )}
            </div>

            <div className="timeline-details-column">
              <div className="timeline-step-header">
                <h4>{step.title}</h4>
                {step.date && <span className="step-date-stamp">{step.date}</span>}
              </div>
              <p className="step-description-text">{step.description}</p>
              
              <div className="step-actor-info">
                <User size={12} className="actor-icon" />
                <span>{step.actionedBy}</span>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}