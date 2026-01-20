'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

interface ParticipationRole {
  id: number;
  name: string;
}

export default function ParticipationRolesPage() {
  const [roles, setRoles] = useState<ParticipationRole[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingName, setEditingName] = useState('');
  const router = useRouter();

  useEffect(() => {
    fetch('/api/participation-roles')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setRoles(data);
        }
        setLoading(false);
      })
      .catch(err => {
        console.error('Error loading roles:', err);
        setLoading(false);
      });
  }, []);

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;

    try {
      const res = await fetch('/api/participation-roles', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: newName })
      });

      if (res.status === 403) {
        alert('Acesso negado.');
        router.push('/');
        return;
      }

      if (res.ok) {
        const role = await res.json();
        setRoles([...roles, role]);
        setNewName('');
      } else {
        alert('Erro ao criar função');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  const handleUpdate = async (id: number) => {
    if (!editingName.trim()) return;

    try {
      const res = await fetch(`/api/participation-roles/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: editingName })
      });

      if (res.ok) {
        setRoles(roles.map(r => r.id === id ? { ...r, name: editingName } : r));
        setEditingId(null);
        setEditingName('');
      } else {
        alert('Erro ao atualizar');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm('Tem a certeza?')) return;

    try {
      const res = await fetch(`/api/participation-roles/${id}`, { method: 'DELETE' });
      if (res.ok) {
        setRoles(roles.filter(r => r.id !== id));
      } else {
        alert('Erro ao eliminar');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  return (
    <div className="container py-4">
      <div className="mb-4">
        <Link href="/admin" className="btn btn-link text-decoration-none">
          ← Voltar ao Painel
        </Link>
      </div>

      <div className="card mb-4 border-0 shadow-sm">
        <div className="card-body">
          <h1 className="h4 mb-3 fw-bold">Gerir Funções de Participação</h1>
          
          <form onSubmit={handleAdd} className="mb-4">
            <div className="input-group">
              <input
                type="text"
                className="form-control"
                placeholder="Nova função..."
                value={newName}
                onChange={e => setNewName(e.target.value)}
              />
              <button className="btn btn-primary" type="submit">
                Adicionar
              </button>
            </div>
          </form>
        </div>
      </div>

      <div className="card border-0 shadow-sm">
        <div className="card-body p-0">
          {loading ? (
            <div className="text-center py-5">
              <div className="spinner-border text-primary" role="status">
                <span className="visually-hidden">Carregando...</span>
              </div>
            </div>
          ) : roles.length === 0 ? (
            <div className="text-center py-5 text-muted">
              Nenhuma função registada
            </div>
          ) : (
            <div className="table-responsive">
              <table className="table table-hover mb-0">
                <thead className="table-light">
                  <tr>
                    <th className="fw-semibold">Nome</th>
                    <th className="fw-semibold text-end">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {roles.map(role => (
                    <tr key={role.id}>
                      <td>
                        {editingId === role.id ? (
                          <input
                            type="text"
                            className="form-control form-control-sm"
                            value={editingName}
                            onChange={e => setEditingName(e.target.value)}
                          />
                        ) : (
                          role.name
                        )}
                      </td>
                      <td className="text-end">
                        {editingId === role.id ? (
                          <>
                            <button
                              className="btn btn-sm btn-success me-2"
                              onClick={() => handleUpdate(role.id)}
                            >
                              Guardar
                            </button>
                            <button
                              className="btn btn-sm btn-secondary"
                              onClick={() => setEditingId(null)}
                            >
                              Cancelar
                            </button>
                          </>
                        ) : (
                          <>
                            <button
                              className="btn btn-sm btn-outline-primary me-2"
                              onClick={() => {
                                setEditingId(role.id);
                                setEditingName(role.name);
                              }}
                            >
                              Editar
                            </button>
                            <button
                              className="btn btn-sm btn-outline-danger"
                              onClick={() => handleDelete(role.id)}
                            >
                              Eliminar
                            </button>
                          </>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
