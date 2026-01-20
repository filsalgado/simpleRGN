'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

interface Title {
  id: number;
  name: string;
}

export default function TitlesPage() {
  const [titles, setTitles] = useState<Title[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingName, setEditingName] = useState('');
  const router = useRouter();

  useEffect(() => {
    fetch('/api/titles')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setTitles(data);
        }
        setLoading(false);
      })
      .catch(err => {
        console.error('Error loading titles:', err);
        setLoading(false);
      });
  }, []);

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;

    try {
      const res = await fetch('/api/titles', {
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
        const title = await res.json();
        setTitles([...titles, title]);
        setNewName('');
      } else {
        alert('Erro ao criar título');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  const handleUpdate = async (id: number) => {
    if (!editingName.trim()) return;

    try {
      const res = await fetch(`/api/titles/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: editingName })
      });

      if (res.ok) {
        setTitles(titles.map(t => t.id === id ? { ...t, name: editingName } : t));
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
      const res = await fetch(`/api/titles/${id}`, { method: 'DELETE' });
      if (res.ok) {
        setTitles(titles.filter(t => t.id !== id));
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
          <h1 className="h4 mb-3 fw-bold">Gerir Títulos</h1>
          
          <form onSubmit={handleAdd} className="mb-4">
            <div className="input-group">
              <input
                type="text"
                className="form-control"
                placeholder="Novo título..."
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
          ) : titles.length === 0 ? (
            <div className="text-center py-5 text-muted">
              Nenhum título registado
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
                  {titles.map(title => (
                    <tr key={title.id}>
                      <td>
                        {editingId === title.id ? (
                          <input
                            type="text"
                            className="form-control form-control-sm"
                            value={editingName}
                            onChange={e => setEditingName(e.target.value)}
                          />
                        ) : (
                          title.name
                        )}
                      </td>
                      <td className="text-end">
                        {editingId === title.id ? (
                          <>
                            <button
                              className="btn btn-sm btn-success me-2"
                              onClick={() => handleUpdate(title.id)}
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
                                setEditingId(title.id);
                                setEditingName(title.name);
                              }}
                            >
                              Editar
                            </button>
                            <button
                              className="btn btn-sm btn-outline-danger"
                              onClick={() => handleDelete(title.id)}
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
