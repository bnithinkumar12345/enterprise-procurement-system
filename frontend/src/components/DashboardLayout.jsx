import React, { useState, useEffect, useRef } from 'react';
import { NavLink, useNavigate, useLocation } from 'react-router-dom';
import { 
  LayoutDashboard, 
  ClipboardList, 
  BadgeCheck, 
  ShoppingCart, 
  Building2, 
  Building, 
  Users, 
  ShieldCheck, 
  BarChart3, 
  Wallet, 
  PackageCheck, 
  Bell, 
  Settings, 
  UserCircle, 
  LogOut,
  Calendar,
  UserCheck,
  Search
} from 'lucide-react';
import { CANONICAL_ROLES } from '../utils/roles';
import { apiFetch } from '../api';
import erpLogo from '../assets/logos/erplogo.png';
import './DashboardLayout.css';

const { ADMIN, APPROVER, FINANCE, RECEIVER, REQUESTER } = CANONICAL_ROLES;

export default function DashboardLayout({ user, onLogout, children }) {
  const navigate = useNavigate();
  const location = useLocation();

  const [showProfileMenu, setShowProfileMenu] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);
  const [globalSearch, setGlobalSearch] = useState('');
  const [notifications, setNotifications] = useState([]);

  const loadNotifications = async () => {
    if (!user?.token) return;
    try {
      const data = await apiFetch('/api/notifications', {}, user.token);
      setNotifications(data);
    } catch (err) {
      console.error('Failed to load notifications', err);
    }
  };

  // loadNotifications is redefined every render; adding it to the deps array
  // would restart the 30s poll interval on every render instead of once per
  // token change.
  useEffect(() => {
    loadNotifications();
    const interval = setInterval(loadNotifications, 30000); // poll every 30s
    return () => clearInterval(interval);
  }, [user?.token]); // eslint-disable-line react-hooks/exhaustive-deps

  const profileRef = useRef(null);
  const notifyRef = useRef(null);

  useEffect(() => {
    function handleClickOutside(event) {
      if (profileRef.current && !profileRef.current.contains(event.target)) {
        setShowProfileMenu(false);
      }
      if (notifyRef.current && !notifyRef.current.contains(event.target)) {
        setShowNotifications(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleLogoutConfirm = () => {
    setShowLogoutConfirm(false);
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    if (onLogout) onLogout(null);
    navigate('/login');
  };

  const pathSegments = location.pathname.split('/').filter(Boolean);
  const breadcrumbs = [
    { label: 'Procurement Platform', path: '/dashboard' },
    ...pathSegments.map((segment, idx) => {
      const path = `/${pathSegments.slice(0, idx + 1).join('/')}`;
      const label = segment.charAt(0).toUpperCase() + segment.slice(1).replace(/-/g, ' ');
      return { label, path };
    }),
  ];

  const getSidebarGroups = (userRole) => {
    const defaultGroups = [];

    if (userRole === REQUESTER) {
      defaultGroups.push({
        title: "Request Management",
        items: [
          { path: '/dashboard', label: 'Dashboard', icon: <LayoutDashboard size={20} /> },
          { path: '/requisitions/new', label: 'New Request', icon: <ClipboardList size={20} /> },
          { path: '/requisitions', label: 'My Requests', icon: <ClipboardList size={20} /> },
          { path: '/purchase-orders', label: 'Purchase Orders', icon: <ShoppingCart size={20} /> },
          { path: '/profile', label: 'Profile', icon: <UserCircle size={20} /> }
        ]
      });
    }

    if (userRole === APPROVER) {
      defaultGroups.push({
        title: "Approvals & History",
        items: [
          { path: '/dashboard', label: 'Dashboard', icon: <LayoutDashboard size={20} /> },
          { path: '/approvals', label: 'Pending Approvals', icon: <BadgeCheck size={20} /> },
          { path: '/approvals?tab=history', label: 'Approval History', icon: <BadgeCheck size={20} /> },
          { path: '/profile', label: 'Profile', icon: <UserCircle size={20} /> }
        ]
      });
    }

    if (userRole === FINANCE) {
      defaultGroups.push({
        title: "Financial Control",
        items: [
          { path: '/dashboard', label: 'Dashboard', icon: <LayoutDashboard size={20} /> },
          { path: '/approvals', label: 'Finance Approvals', icon: <Wallet size={20} /> },
          { path: '/approvals?tab=history', label: 'Approval History', icon: <Wallet size={20} /> },
          { path: '/reports', label: 'Reports', icon: <BarChart3 size={20} /> },
          { path: '/profile', label: 'Profile', icon: <UserCircle size={20} /> }
        ]
      });
    }

    if (userRole === RECEIVER) {
      defaultGroups.push({
        title: "Warehouse Operations",
        items: [
          { path: '/dashboard', label: 'Dashboard', icon: <LayoutDashboard size={20} /> },
          { path: '/receiving', label: 'Goods Receiving', icon: <PackageCheck size={20} /> },
          { path: '/purchase-orders', label: 'Completed Deliveries', icon: <ShoppingCart size={20} /> },
          { path: '/profile', label: 'Profile', icon: <UserCircle size={20} /> }
        ]
      });
    }

    if (userRole === ADMIN) {
      defaultGroups.push({
        title: "System Administration",
        items: [
          { path: '/dashboard', label: 'Dashboard', icon: <LayoutDashboard size={20} /> },
          { path: '/approvals', label: 'Pending Approvals', icon: <BadgeCheck size={20} /> },
          { path: '/approvals?tab=history', label: 'Approval History', icon: <BadgeCheck size={20} /> },
          { path: '/admin-requisitions', label: 'Requisitions', icon: <ClipboardList size={20} /> },
          { path: '/purchase-orders', label: 'Purchase Orders', icon: <ShoppingCart size={20} /> },
          { path: '/suppliers', label: 'Suppliers', icon: <Building2 size={20} /> },
          { path: '/catalog', label: 'Categories', icon: <Building size={20} /> },
          { path: '/approval-rules', label: 'Approval Rules', icon: <Settings size={20} /> },
          { path: '/users', label: 'Users', icon: <Users size={20} /> },
          { path: '/roles', label: 'Roles', icon: <Users size={20} /> },
          { path: '/reports', label: 'Reports', icon: <BarChart3 size={20} /> },
          { path: '/reports?tab=audit', label: 'Audit Logs', icon: <ShieldCheck size={20} /> },
          { path: '/profile', label: 'Settings', icon: <Settings size={20} /> }
        ]
      });
    }

    return defaultGroups;
  };

  // Each canonical role's distinctive nav items (excluding Dashboard/Profile,
  // which every role gets and which get de-duplicated below).
  const ROLE_ITEMS = {
    [REQUESTER]: [
      { path: '/requisitions/new', label: 'New Request', icon: <ClipboardList size={20} /> },
      { path: '/requisitions', label: 'My Requests', icon: <ClipboardList size={20} /> },
      { path: '/purchase-orders', label: 'Purchase Orders', icon: <ShoppingCart size={20} /> },
    ],
    [APPROVER]: [
      { path: '/approvals', label: 'Pending Approvals', icon: <BadgeCheck size={20} /> },
      { path: '/approvals?tab=history', label: 'Approval History', icon: <BadgeCheck size={20} /> },
    ],
    [FINANCE]: [
      { path: '/approvals', label: 'Finance Approvals', icon: <Wallet size={20} /> },
      { path: '/approvals?tab=history', label: 'Approval History', icon: <Wallet size={20} /> },
      { path: '/reports', label: 'Reports', icon: <BarChart3 size={20} /> },
    ],
    [RECEIVER]: [
      { path: '/receiving', label: 'Goods Receiving', icon: <PackageCheck size={20} /> },
      { path: '/purchase-orders', label: 'Completed Deliveries', icon: <ShoppingCart size={20} /> },
    ],
  };

  // A user can hold multiple roles (assigned via Admin > Roles). The base
  // sidebar above is built from just their highest-privilege role, so any
  // extra role's items (e.g. a Manager who was also granted Requester)
  // need to be merged in here - otherwise granting the extra role via the
  // Roles admin page has no visible effect.
  const applyAdditionalRoleItems = (groups, allRoles, primaryRole) => {
    if (!groups.length || !Array.isArray(allRoles)) return groups;
    const targetGroup = groups[0];
    const existingPaths = new Set(targetGroup.items.map((i) => i.path));

    allRoles
      .filter((r) => r !== primaryRole && ROLE_ITEMS[r])
      .forEach((extraRole) => {
        ROLE_ITEMS[extraRole].forEach((item) => {
          if (!existingPaths.has(item.path)) {
            // Insert right after Dashboard (index 0) rather than at the end,
            // so newly-granted actions like "New Request" are prominent.
            targetGroup.items.splice(1, 0, item);
            existingPaths.add(item.path);
          }
        });
      });

    return groups;
  };

  const primaryRole = user?.role || REQUESTER;
  const sidebarGroups = applyAdditionalRoleItems(getSidebarGroups(primaryRole), user?.roles, primaryRole);

  const unreadCount = notifications.filter(n => !n.isRead).length;

  const handleMarkAllRead = async () => {
    try {
      await apiFetch('/api/notifications/read-all', { method: 'PUT' }, user.token);
      setNotifications(notifications.map(n => ({ ...n, isRead: true })));
    } catch (err) {
      console.error('Failed to mark read', err);
    }
  };

  return (
    <div className="enterprise-layout">
      {/* Dark Sidebar background #111111 */}
      <aside className="enterprise-sidebar">
        <div className="sidebar-logo">
          <img 
            src={erpLogo} 
            alt="ERP Logo" 
            className="sidebar-logo-image"
          />
          <div className="sidebar-logo-text">
            <span className="logo-title-font app-title">ProcureFlow</span>
            <span className="app-subtitle">S2P Platform</span>
          </div>
        </div>

        {/* User Card */}
        <div className="sidebar-user-card">
          <div className="user-avatar-circle">
            {user?.fullName ? user.fullName.charAt(0) : user?.username?.charAt(0).toUpperCase()}
          </div>
          <div className="user-info-text">
            <span className="user-name-title">{user?.fullName || user?.username}</span>
            <span className="user-role-badge">{user?.role || 'Guest'}</span>
          </div>
        </div>

        <nav className="sidebar-navigation">
          {sidebarGroups.map((group, groupIdx) => (
            <div key={groupIdx} className="nav-group-section">
              <span className="nav-group-title">{group.title}</span>
              <ul>
                {group.items.map((item, itemIdx) => (
                  <li key={itemIdx}>
                    <NavLink
                      to={item.path}
                      className={({ isActive }) => {
                        let active = isActive;
                        const search = location.search;
                        // Custom logic to prevent dual active classes
                        if (item.label === 'Pending Approvals' && search.includes('tab=history')) active = false;
                        if (item.label === 'Approval History' && !search.includes('tab=history')) active = false;
                        if (item.label === 'Finance Approvals' && search.includes('tab=payments')) active = false;
                        if (item.label === 'Payments' && !search.includes('tab=payments')) active = false;
                        if (item.label === 'Reports' && search.includes('tab=audit')) active = false;
                        if (item.label === 'Audit Logs' && !search.includes('tab=audit')) active = false;
                        return active ? 'nav-item-link active' : 'nav-item-link';
                      }}
                      end={item.path === '/dashboard' || item.path === '/requisitions' || item.path === '/approvals'}
                    >
                      <span className="nav-item-icon">{item.icon}</span>
                      <span className="nav-item-label">{item.label}</span>
                    </NavLink>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </nav>

        <div className="sidebar-footer-action">
          <button className="btn-sidebar-signout" onClick={() => setShowLogoutConfirm(true)}>
            <LogOut size={18} />
            <span>Sign Out</span>
          </button>
        </div>
      </aside>

      {/* Main workspace container */}
      <div className="enterprise-main-wrapper">
        {/* Sticky topnav */}
        <header className="enterprise-topnav-header">
          {/* Breadcrumbs */}
          <div className="topnav-breadcrumbs-trail">
            {breadcrumbs.map((crumb, idx) => (
              <React.Fragment key={idx}>
                {idx > 0 && <span className="trail-separator">/</span>}
                <span
                  className={`trail-item ${idx === breadcrumbs.length - 1 ? 'active' : ''}`}
                  onClick={() => idx < breadcrumbs.length - 1 && navigate(crumb.path)}
                >
                  {crumb.label}
                </span>
              </React.Fragment>
            ))}
          </div>

          {/* Action parameters center */}
          <div className="topnav-meta-and-actions">
            {/* Metadata Tags */}
            <div className="topnav-meta-tags-grid">
              <div className="meta-tag-pill">
                <Calendar size={14} className="tag-icon" />
                <span>{new Date().toLocaleDateString(undefined, { weekday: 'short', month: 'short', day: 'numeric' })}</span>
              </div>
              <div className="meta-tag-pill">
                <UserCheck size={14} className="tag-icon" />
                <span>{user?.role}</span>
              </div>
              <div className="meta-tag-pill">
                <Building size={14} className="tag-icon" />
                <span>{user?.departmentName || 'General Office'}</span>
              </div>
            </div>

            {/* Search Bar */}
            <div className="topnav-search-box">
              <Search size={16} className="search-box-icon" />
              <input
                type="text"
                placeholder="Search requisitions..."
                value={globalSearch}
                onChange={(e) => setGlobalSearch(e.target.value)}
              />
            </div>

            {/* Notification bell icon */}
            <div className="topnav-dropdown-trigger" ref={notifyRef}>
              <button className="btn-circle-trigger" onClick={() => setShowNotifications(!showNotifications)}>
                <Bell size={20} />
                {unreadCount > 0 && <span className="badge-alert-dot">{unreadCount}</span>}
              </button>
              {showNotifications && (
                <div className="dropdown-panel-menu notifications-panel">
                  <div className="dropdown-panel-header">
                    <h4>Corporate Alerts</h4>
                    {unreadCount > 0 && <span className="unread-count-tag" onClick={handleMarkAllRead} style={{ cursor: 'pointer' }}>Mark all read</span>}
                  </div>
                  <ul>
                    {notifications.length === 0 ? (
                      <li className="alert-item" style={{ textAlign: 'center', color: '#9ca3af' }}>No new notifications</li>
                    ) : notifications.map(n => (
                      <li key={n.notificationId} className={n.isRead ? 'alert-item read' : 'alert-item unread'}>
                        <p>{n.message}</p>
                        <span className="alert-time-stamp">{new Date(n.createdAt).toLocaleString()}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>

            {/* Profile Dropdown icon */}
            <div className="topnav-dropdown-trigger" ref={profileRef}>
              <button className="btn-circle-trigger profile" onClick={() => setShowProfileMenu(!showProfileMenu)}>
                <UserCircle size={20} />
              </button>
              {showProfileMenu && (
                <div className="dropdown-panel-menu profile-panel">
                  <div className="dropdown-profile-header">
                    <strong>{user?.fullName || user?.username}</strong>
                    <span>{user?.role}</span>
                  </div>
                  <ul>
                    <li onClick={() => { navigate('/profile'); setShowProfileMenu(false); }}>
                      <Settings size={14} style={{ marginRight: '8px' }} />
                      <span>My Settings</span>
                    </li>
                    <li onClick={() => setShowLogoutConfirm(true)}>
                      <LogOut size={14} style={{ marginRight: '8px', color: 'var(--color-rejected)' }} />
                      <span style={{ color: 'var(--color-rejected)', fontWeight: '600' }}>Sign Out</span>
                    </li>
                  </ul>
                </div>
              )}
            </div>
          </div>
        </header>

        {/* Workspace content wrapper */}
        <main className="enterprise-workspace-canvas">
          {children}
        </main>
      </div>

      {/* Logout confirmation dialog */}
      {showLogoutConfirm && (
        <div className="modal-blur-overlay">
          <div className="zoho-card modal-panel-card" style={{ maxWidth: '400px', textAlign: 'center', border: 'none' }}>
            <h3 style={{ fontSize: '18px', fontWeight: '700', marginBottom: '12px' }}>
              Confirm Sign Out
            </h3>
            <p style={{ fontSize: '13px', color: '#4b5563', lineHeight: '1.6', marginBottom: '24px' }}>
              Are you sure you want to end your active procurement session? All unsaved inputs will be lost.
            </p>
            <div style={{ display: 'flex', gap: '12px' }}>
              <button 
                className="btn-enterprise secondary" 
                style={{ flex: 1, height: '40px' }} 
                onClick={() => setShowLogoutConfirm(false)}
              >
                Cancel
              </button>
              <button 
                className="btn-enterprise primary" 
                style={{ flex: 1, height: '40px' }} 
                onClick={handleLogoutConfirm}
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}