'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

interface Profession {
  id: number;
  name: string;
}

export default function ProfessionsPage() {
  const [professions, setProfessions] = useState<Profession[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingName, setEditingName] = useState('');
  const router = useRouter();

  useEffect(() => {
    fetch('/api/professions')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setProfessions(data);
        }
        setLoading(false);
      })
      .catch(err => {
        console.error('Error loading professions:', err);
        setLoading(false);
      });
  }, []);

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;

    try {
      const res = await fetch('/api/professions', {
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
        const profession = await res.json();
        setProfessions([...professions, profession]);
        setNewName('');
      } else {
        alert('Erro ao criar profissão');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  const handleUpdate = async (id: number) => {
    if (!editingName.trim()) return;

    try {
      const res = await fetch(`/api/professions/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: editingName })
      });

      if (res.ok) {
        setProfessions(professions.map(p => p.id === id ? { ...p, name: editingName } : p));
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
      const res = await fetch(`/api/professions/${id}`, { method: 'DELETE' });
      if (res.ok) {
        setProfessions(professions.filter(p => p.id !== id));
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
          <h1 className="h4 mb-3 fw-bold">Gerir Profissões</h1>
          
          <form onSubmit={handleAdd} className="mb-4">
            <div className="input-group">
              <input
                type="text"
                className="form-control"
                placeholder="Nova profissão..."
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
          ) : professions.length === 0 ? (
            <div className="text-center py-5 text-muted">
              Nenhuma profissão registada
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
                  {professions.map(profession => (
                    <tr key={profession.id}>
                      <td>
                        {editingId === profession.id ? (
                          <input
                            type="text"
                            className="form-control form-control-sm"
                            value={editingName}
                            onChange={e => setEditingName(e.target.value)}
                          />
                        ) : (
                          profession.name
                        )}
                      </td>
                      <td className="text-end">
                        {editingId === profession.id ? (
                          <>
                            <button
                              className="btn btn-sm btn-success me-2"
                              onClick={() => handleUpdate(profession.id)}
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
                                setEditingId(profession.id);
                                setEditingName(profession.name);
                              }}
                            >
                              Editar
                            </button>
                            <button
                              className="btn btn-sm btn-outline-danger"
                              onClick={() => handleDelete(profession.id)}
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
