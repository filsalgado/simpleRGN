'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

interface Place {
  id: number;
  name: string;
  parishId: number;
  parish?: {
    id: number;
    name: string;
    municipality?: string;
    district?: string;
  };
}

interface Parish {
  id: number;
  name: string;
  municipality?: string;
  district?: string;
}

// Searchable Select Component
function SearchableSelect({ options, value, onChange, placeholder = "Selecionar...", disabled = false }: {
  options: { id: string | number, name: string }[];
  value: string | number;
  onChange: (val: string) => void;
  placeholder?: string;
  disabled?: boolean;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  
  const safeOptions = Array.isArray(options) ? options : [];
  const selectedObj = safeOptions.find(o => o.id.toString() === value.toString());
  const displayValue = isOpen ? search : (selectedObj ? selectedObj.name : '');
  const filteredOptions = safeOptions.filter(o => o.name && o.name.toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="position-relative">
      <input 
        type="text"
        className="form-control"
        placeholder={placeholder}
        value={displayValue}
        onChange={(e) => { setSearch(e.target.value); setIsOpen(true); }}
        onFocus={() => { setIsOpen(true); setSearch(''); }}
        onBlur={() => setTimeout(() => setIsOpen(false), 200)}
        disabled={disabled}
      />
      {isOpen && (
        <div className="position-absolute w-100 mt-1 border rounded bg-white shadow-sm" style={{ zIndex: 1050, maxHeight: '250px', overflowY: 'auto' }}>
          {filteredOptions.length > 0 ? (
            filteredOptions.map(opt => (
              <div 
                key={opt.id} 
                className="px-3 py-2 cursor-pointer"
                style={{ cursor: 'pointer', fontSize: '14px' }}
                onMouseDown={() => { onChange(opt.id.toString()); setIsOpen(false); setSearch(''); }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'white'}
              >
                {opt.name}
              </div>
            ))
          ) : (
            <div className="px-3 py-2 text-muted">Nenhum resultado</div>
          )}
        </div>
      )}
    </div>
  );
}

export default function PlacesPage() {
  const [places, setPlaces] = useState<Place[]>([]);
  const [parishes, setParishes] = useState<Parish[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState('');
  const [newParishId, setNewParishId] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingName, setEditingName] = useState('');
  const [editingParishId, setEditingParishId] = useState('');
  const [filterParishId, setFilterParishId] = useState<string>('');
  const [sortBy, setSortBy] = useState<'name' | 'parish'>('name');
  const [sortAsc, setSortAsc] = useState(true);
  const router = useRouter();

  useEffect(() => {
    Promise.all([
      fetch('/api/places').then(res => res.json()),
      fetch('/api/parishes').then(res => res.json())
    ]).then(([placesData, parishesData]) => {
      if (Array.isArray(placesData)) {
        setPlaces(placesData);
      }
      if (Array.isArray(parishesData)) {
        setParishes(parishesData);
      }
      setLoading(false);
    }).catch(err => {
      console.error('Error loading:', err);
      setLoading(false);
    });
  }, []);

  const getDisplayParish = (parish: Parish | undefined) => {
    if (!parish) return '';
    return `${parish.name} - ${parish.municipality} - ${parish.district}`;
  };

  const filteredAndSortedPlaces = places
    .filter(p => !filterParishId || p.parishId === parseInt(filterParishId))
    .sort((a, b) => {
      let aVal, bVal;
      if (sortBy === 'name') {
        aVal = a.name.toLowerCase();
        bVal = b.name.toLowerCase();
      } else {
        aVal = getDisplayParish(a.parish).toLowerCase();
        bVal = getDisplayParish(b.parish).toLowerCase();
      }
      return sortAsc ? aVal.localeCompare(bVal) : bVal.localeCompare(aVal);
    });

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim() || !newParishId) return;

    try {
      const res = await fetch('/api/places', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: newName, parishId: parseInt(newParishId) })
      });

      if (res.status === 403) {
        alert('Acesso negado.');
        router.push('/');
        return;
      }

      if (res.ok) {
        const place = await res.json();
        setPlaces([...places, place]);
        setNewName('');
        setNewParishId('');
      } else {
        alert('Erro ao criar local');
      }
    } catch (e) {
      alert('Erro: ' + e);
    }
  };

  const handleUpdate = async (id: number) => {
    if (!editingName.trim() || !editingParishId) return;

    try {
      const res = await fetch(`/api/places/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: editingName, parishId: parseInt(editingParishId) })
      });

      if (res.ok) {
        const updatedPlace = await res.json();
        setPlaces(places.map(p => p.id === id ? updatedPlace : p));
        setEditingId(null);
        setEditingName('');
        setEditingParishId('');
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
      const res = await fetch(`/api/places/${id}`, { method: 'DELETE' });
      if (res.ok) {
        setPlaces(places.filter(p => p.id !== id));
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
          <h1 className="h4 mb-3 fw-bold">Gerir Locais</h1>
          
          <form onSubmit={handleAdd} className="mb-4">
            <div className="row g-2">
              <div className="col">
                <input
                  type="text"
                  className="form-control"
                  placeholder="Novo local..."
                  value={newName}
                  onChange={e => setNewName(e.target.value)}
                />
              </div>
              <div className="col-auto" style={{ minWidth: '300px' }}>
                <SearchableSelect
                  options={parishes.map(p => ({ id: p.id, name: getDisplayParish(p) }))}
                  value={newParishId}
                  onChange={setNewParishId}
                  placeholder="Selecionar paróquia..."
                />
              </div>
              <div className="col-auto">
                <button className="btn btn-primary" type="submit">
                  Adicionar
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>

      <div className="card border-0 shadow-sm">
        <div className="card-body p-0">
          {/* Filtros */}
          <div className="p-3 border-bottom bg-light">
            <div className="row g-2">
              <div className="col-md-6">
                <label className="form-label small fw-semibold mb-1">Filtrar por Paróquia</label>
                <select
                  className="form-select form-select-sm"
                  value={filterParishId}
                  onChange={e => setFilterParishId(e.target.value)}
                >
                  <option value="">Todas as paróquias</option>
                  {parishes.map(p => (
                    <option key={p.id} value={p.id}>{getDisplayParish(p)}</option>
                  ))}
                </select>
              </div>
              <div className="col-md-4">
                <label className="form-label small fw-semibold mb-1">Ordenar por</label>
                <select
                  className="form-select form-select-sm"
                  value={sortBy}
                  onChange={e => setSortBy(e.target.value as 'name' | 'parish')}
                >
                  <option value="name">Nome</option>
                  <option value="parish">Paróquia</option>
                </select>
              </div>
              <div className="col-md-2 d-flex align-items-end">
                <button
                  className="btn btn-sm btn-outline-secondary w-100"
                  onClick={() => setSortAsc(!sortAsc)}
                >
                  {sortAsc ? '↑ Asc' : '↓ Desc'}
                </button>
              </div>
            </div>
          </div>

          {/* Tabela */}
          {loading ? (
            <div className="text-center py-5">
              <div className="spinner-border text-primary" role="status">
                <span className="visually-hidden">Carregando...</span>
              </div>
            </div>
          ) : filteredAndSortedPlaces.length === 0 ? (
            <div className="text-center py-5 text-muted">
              {places.length === 0 ? 'Nenhum local registado' : 'Nenhum resultado com os filtros selecionados'}
            </div>
          ) : (
            <div className="table-responsive">
              <table className="table table-hover mb-0">
                <thead className="table-light">
                  <tr>
                    <th className="fw-semibold">Nome</th>
                    <th className="fw-semibold">Paróquia</th>
                    <th className="fw-semibold text-end">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredAndSortedPlaces.map(place => (
                    <tr key={place.id}>
                      <td>
                        {editingId === place.id ? (
                          <input
                            type="text"
                            className="form-control form-control-sm"
                            value={editingName}
                            onChange={e => setEditingName(e.target.value)}
                          />
                        ) : (
                          place.name
                        )}
                      </td>
                      <td>
                        {editingId === place.id ? (
                          <SearchableSelect
                            options={parishes.map(p => ({ id: p.id, name: getDisplayParish(p) }))}
                            value={editingParishId}
                            onChange={setEditingParishId}
                            placeholder="Selecionar paróquia..."
                          />
                        ) : (
                          <span className="badge bg-primary">{getDisplayParish(place.parish)}</span>
                        )}
                      </td>
                      <td className="text-end">
                        {editingId === place.id ? (
                          <>
                            <button
                              className="btn btn-sm btn-success me-2"
                              onClick={() => handleUpdate(place.id)}
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
                                setEditingId(place.id);
                                setEditingName(place.name);
                                setEditingParishId(place.parishId.toString());
                              }}
                            >
                              Editar
                            </button>
                            <button
                              className="btn btn-sm btn-outline-danger"
                              onClick={() => handleDelete(place.id)}
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
