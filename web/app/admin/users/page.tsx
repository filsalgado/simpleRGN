'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

export default function UsersPage() {
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    fetch('/api/users')
      .then(res => {
        if (res.status === 403) {
          alert('Acesso negado. Apenas administradores podem gerir utilizadores.');
          router.push('/');
          return null;
        }
        return res.json();
      })
      .then(data => {
        if (!data) return;
        if (Array.isArray(data)) {
          setUsers(data);
        } else if (data.error) {
          console.error('Error loading users:', data.error);
          alert('Erro ao carregar utilizadores: ' + data.error);
        } else {
          console.error('Invalid response:', data);
          setUsers([]);
        }
        setLoading(false);
      })
      .catch(err => {
        console.error('Fetch error:', err);
        alert('Erro ao carregar utilizadores: ' + err.message);
        setLoading(false);
      });
  }, [router]);

  const handleDelete = async (id: number) => {
    if (!confirm('Tem a certeza que deseja eliminar este utilizador?')) return;
    try {
      const res = await fetch(`/api/users/${id}`, { method: 'DELETE' });
      if (!res.ok) {
        const error = await res.json();
        alert(error.error || 'Erro ao eliminar');
        return;
      }
      setUsers(users.filter(u => u.id !== id));
    } catch (e) {
      alert('Erro ao eliminar: ' + e);
    }
  };

  const getRoleBadge = (role: string) => {
    return role === 'ADMIN' ? 
      <span className="badge bg-danger">Admin</span> : 
      <span className="badge bg-secondary">Utilizador</span>;
  };

  return (
    <div className="container py-4">
      <div className="card mb-4 border-0 shadow-sm">
        <div className="card-body">
          <div className="d-flex justify-content-between align-items-center">
            <div>
              <h1 className="h4 mb-1 fw-bold">Gestão de Utilizadores</h1>
              <p className="text-muted small mb-0">Administração de contas e acessos</p>
            </div>
            <Link href="/admin/users/new" className="btn btn-primary">
              + Novo Utilizador
            </Link>
          </div>
        </div>
      </div>

      <div className="card border-0 shadow-sm">
        <div className="card-body p-0">
          <div className="table-responsive">
            <table className="table table-hover mb-0">
              <thead className="table-light">
                <tr>
                  <th className="fw-semibold">Nome</th>
                  <th className="fw-semibold">Email</th>
                  <th className="fw-semibold">Role</th>
                  <th className="fw-semibold">Paróquia Atual</th>
                  <th className="fw-semibold">Data Registo</th>
                  <th className="fw-semibold text-end">Ações</th>
                </tr>
              </thead>
              <tbody>
                {users.map(user => (
                  <tr key={user.id}>
                    <td className="fw-medium">{user.name}</td>
                    <td className="text-muted">{user.email}</td>
                    <td>{getRoleBadge(user.role)}</td>
                    <td>
                      {user.currentParish ? (
                        <span className="badge bg-primary">{user.currentParish.name}</span>
                      ) : (
                        <span className="text-muted small fst-italic">Nenhuma</span>
                      )}
                    </td>
                    <td className="text-muted small">
                      {new Date(user.createdAt).toLocaleDateString()}
                    </td>
                    <td className="text-end">
                      <div className="btn-group btn-group-sm" role="group">
                        <Link href={`/admin/users/${user.id}/edit`} className="btn btn-outline-primary">
                          Editar
                        </Link>
                        <button onClick={() => handleDelete(user.id)} className="btn btn-outline-danger">
                          Eliminar
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {users.length === 0 && !loading && (
            <div className="text-center py-5 text-muted">
              Nenhum utilizador encontrado.
            </div>
          )}
          {loading && (
            <div className="text-center py-5">
              <div className="spinner-border text-primary" role="status">
                <span className="visually-hidden">Carregando...</span>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
