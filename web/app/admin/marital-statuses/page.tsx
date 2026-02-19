'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

interface MaritalStatus {
  id: number;
  name: string;
}

export default function MaritalStatusesPage() {
  const [maritalStatuses, setMaritalStatuses] = useState<MaritalStatus[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingName, setEditingName] = useState('');
  const router = useRouter();

  useEffect(() => {
    fetch('/api/marital-statuses')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setMaritalStatuses(data);
        }
        setLoading(false);
      })
      .catch(err => {
        console.error('Error loading marital statuses:', err);
        setLoading(false);
      });
  }, []);

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;

    try {
      const res = await fetch('/api/marital-statuses', {
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
        const maritalStatus = await res.json();
        setMaritalStatuses([...maritalStatuses, maritalStatus]);
        setNewName('');
      } else {
        alert('Erro ao criar estado civil');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  const handleUpdate = async (id: number) => {
    if (!editingName.trim()) return;

    try {
      const res = await fetch(`/api/marital-statuses/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: editingName })
      });

      if (res.ok) {
        setMaritalStatuses(maritalStatuses.map(ms => ms.id === id ? { ...ms, name: editingName } : ms));
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
      const res = await fetch(`/api/marital-statuses/${id}`, { method: 'DELETE' });
      if (res.ok) {
        setMaritalStatuses(maritalStatuses.filter(ms => ms.id !== id));
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
          <h1 className="h4 mb-3 fw-bold">Gerir Estados Civis</h1>
          
          <form onSubmit={handleAdd} className="mb-4">
            <div className="input-group">
              <input
                type="text"
                className="form-control"
                placeholder="Novo estado civil..."
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
          ) : maritalStatuses.length === 0 ? (
            <div className="text-center py-5 text-muted">
              Nenhum estado civil registado
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
                  {maritalStatuses.map(maritalStatus => (
                    <tr key={maritalStatus.id}>
                      <td>
                        {editingId === maritalStatus.id ? (
                          <input
                            type="text"
                            className="form-control form-control-sm"
                            value={editingName}
                            onChange={e => setEditingName(e.target.value)}
                          />
                        ) : (
                          maritalStatus.name
                        )}
                      </td>
                      <td className="text-end">
                        {editingId === maritalStatus.id ? (
                          <>
                            <button
                              className="btn btn-sm btn-success me-2"
                              onClick={() => handleUpdate(maritalStatus.id)}
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
                                setEditingId(maritalStatus.id);
                                setEditingName(maritalStatus.name);
                              }}
                            >
                              Editar
                            </button>
                            <button
                              className="btn btn-sm btn-outline-danger"
                              onClick={() => handleDelete(maritalStatus.id)}
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
