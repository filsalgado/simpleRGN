'use client';

import { useSession, signOut } from "next-auth/react";
import { useState } from "react";

export function UserMenu() {
    const { data: session } = useSession();
    const [isOpen, setIsOpen] = useState(false);

    if (!session) return null;

    return (
        <div className="dropdown" style={{ position: 'relative' }}>
            <button 
                className="btn btn-light d-flex align-items-center gap-2"
                type="button"
                onClick={() => setIsOpen(!isOpen)}
            >
                <div className="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style={{ width: '32px', height: '32px' }}>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
                    </svg>
                </div>
                <div className="text-start d-none d-md-block">
                    <div className="fw-semibold small">{session.user?.name}</div>
                </div>
            </button>

            {isOpen && (
                <div className="dropdown-menu dropdown-menu-end show position-fixed" style={{ 
                    minWidth: '200px', 
                    zIndex: 9999,
                    top: 'auto',
                    right: '20px',
                    left: 'auto'
                }}>
                    {(session.user as any)?.role === 'ADMIN' && (
                        <>
                            <a href="/admin" className="dropdown-item">
                                Painel de Administração
                            </a>
                            {/* <a href="/admin/users" className="dropdown-item">
                                Gerir Utilizadores
                            </a> */}
                            <div className="dropdown-divider"></div>
                        </>
                    )}
                    <a href="/admin/users" className="dropdown-item">
                        Definições Utilizadores
                    </a>
                    <div className="dropdown-divider"></div>
                    <button 
                        onClick={() => signOut()}
                        className="dropdown-item text-danger"
                    >
                        Sair
                    </button>
                </div>
            )}
        </div>
    );
}
