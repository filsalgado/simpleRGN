'use client';

import { useSession } from 'next-auth/react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';

export default function AdminPage() {
  const { data: session } = useSession();
  const router = useRouter();

  useEffect(() => {
    if (!session) return;
    if ((session.user as any)?.role !== 'ADMIN') {
      alert('Acesso negado. Apenas administradores podem aceder a esta página.');
      router.push('/');
    }
  }, [session, router]);

  if (!session || (session.user as any)?.role !== 'ADMIN') {
    return (
      <div className="container py-5">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">A Carregar...</span>
          </div>
        </div>
      </div>
    );
  }

  const adminSections = [
    {
      title: 'Gestão de Utilizadores',
      description: 'Criar, editar e eliminar utilizadores do sistema',
      icon: '👥',
      link: '/admin/users',
      color: 'primary'
    },
    {
      title: 'Profissões',
      description: 'Gerir profissões disponíveis no sistema',
      icon: '💼',
      link: '/admin/professions',
      color: 'info'
    },
    {
      title: 'Títulos',
      description: 'Gerir títulos',
      icon: '👑',
      link: '/admin/titles',
      color: 'warning'
    },
    {
      title: 'Locais',
      description: 'Gerir locais e paróquias',
      icon: '📍',
      link: '/admin/places',
      color: 'success'
    },
    {
      title: 'Parentesco',
      description: 'Gerir tipos de parentesco',
      icon: '🔗',
      link: '/admin/kinships',
      color: 'danger'
    },
    {
      title: 'Funções de Participação',
      description: 'Gerir funções e papéis nos registos',
      icon: '🎭',
      link: '/admin/participation-roles',
      color: 'secondary'
    }
  ];

  return (
    <div className="container py-5">
      <div className="mb-5">
        <h1 className="h3 fw-bold mb-2">Painel de Administração</h1>
        <p className="text-muted">Gerir dados e configurações do sistema</p>
      </div>

      <div className="row g-4">
        {adminSections.map((section) => (
          <div key={section.link} className="col-md-6 col-lg-4">
            <Link href={section.link} className="text-decoration-none">
              <div className="card h-100 border-0 shadow-sm hover-shadow" style={{ cursor: 'pointer', transition: 'box-shadow 0.3s' }}>
                <div className={`card-body text-center bg-light`}>
                  <div className="fs-1 mb-3">{section.icon}</div>
                  <h5 className="card-title fw-bold">{section.title}</h5>
                  <p className="card-text text-muted small">{section.description}</p>
                  <div className={`badge bg-${section.color}`}>Gerir →</div>
                </div>
              </div>
            </Link>
          </div>
        ))}
      </div>

      <style>{`
        .hover-shadow:hover {
          box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
        }
      `}</style>
    </div>
  );
}
