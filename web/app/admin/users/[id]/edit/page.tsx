'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

type Parish = { id: number; name: string; };

// Searchable Select Component
function SearchableSelect({ options, value, onChange, placeholder = "Selecionar..." }: {
  options: { id: number; name: string }[];
  value: string | number;
  onChange: (value: string | number) => void;
  placeholder?: string;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  
  const safeOptions = Array.isArray(options) ? options : [];
  const filtered = search.trim() === '' 
    ? safeOptions 
    : safeOptions.filter(o => o.name.toLowerCase().includes(search.toLowerCase()));
  
  const selectedObj = safeOptions.find(o => o.id.toString() === value.toString());
  const displayValue = isOpen ? search : (selectedObj ? selectedObj.name : '');

  return (
    <div style={{ position: 'relative' }}>
      <input
        type="text"
        className="form-control"
        placeholder={placeholder}
        value={displayValue}
        onChange={(e) => {
          setSearch(e.target.value);
          setIsOpen(true);
        }}
        onFocus={() => setIsOpen(true)}
        onBlur={() => setTimeout(() => setIsOpen(false), 100)}
        autoComplete="off"
      />
      {isOpen && filtered.length > 0 && (
        <div style={{
          position: 'absolute',
          top: '100%',
          left: 0,
          right: 0,
          backgroundColor: '#fff',
          border: '1px solid #ccc',
          borderTop: 'none',
          maxHeight: '200px',
          overflowY: 'auto',
          zIndex: 1000,
          listStyle: 'none',
          margin: 0,
          padding: 0
        }}>
          {filtered.map(option => (
            <div
              key={option.id}
              onClick={() => {
                onChange(option.id);
                setSearch('');
                setIsOpen(false);
              }}
              style={{
                padding: '8px 12px',
                cursor: 'pointer',
                backgroundColor: value === option.id ? '#e9ecef' : '#fff',
                borderBottom: '1px solid #f0f0f0'
              }}
              onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
              onMouseLeave={(e) => e.currentTarget.style.backgroundColor = value === option.id ? '#e9ecef' : '#fff'}
            >
              {option.name}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default function EditUserPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = require('react').use(params);
  const router = useRouter();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    role: 'USER',
    currentParishId: '',
    currentEventType: 'BAPTISM'
  });
  const [parishes, setParishes] = useState<Parish[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    Promise.all([
      fetch(`/api/users/${id}`).then(res => res.json()),
      fetch('/api/parishes').then(res => res.json())
    ]).then(([userData, parishData]) => {
      if (userData.error) {
        console.error('Error loading user:', userData.error);
        alert('Erro ao carregar utilizador: ' + userData.error);
        if (userData.error.includes('Access denied') || userData.error.includes('Unauthorized')) {
          router.push('/');
        }
        return;
      }
      setFormData({ 
        name: userData.name || '', 
        email: userData.email || '', 
        password: '',
        role: userData.role || 'USER',
        currentParishId: userData.currentParishId || '',
        currentEventType: userData.currentEventType || 'BAPTISM'
      });
      if (Array.isArray(parishData)) {
        setParishes(parishData);
      }
      setLoading(false);
    }).catch(err => {
      console.error('Fetch error:', err);
      alert('Erro ao carregar dados: ' + err.message);
      setLoading(false);
    });
  }, [id, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    
    const payload: any = { name: formData.name, email: formData.email };
    if (formData.password) payload.password = formData.password;
    if (formData.role) payload.role = formData.role;
    if (formData.currentParishId) payload.currentParishId = parseInt(formData.currentParishId);
    if (formData.currentEventType) payload.currentEventType = formData.currentEventType;

    try {
        const res = await fetch(`/api/users/${id}`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        
        if (res.status === 403) {
            alert('Acesso negado. Apenas administradores podem editar utilizadores.');
            router.push('/');
            setSaving(false);
            return;
        }

        if (res.ok) {
            router.push('/admin/users');
        } else {
            const error = await res.json();
            alert('Erro ao atualizar utilizador: ' + (error.error || 'Erro desconhecido'));
        }
    } catch(e) {
        alert('Erro de conexão: ' + e);
    } finally {
        setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="container py-5">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Carregando...</span>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="container py-4">
       <div className="row justify-content-center">
          <div className="col-lg-8">
             <Link href="/admin/users" className="btn btn-link text-decoration-none mb-3">
                ← Voltar à Lista
             </Link>

             <div className="card border-0 shadow-sm">
                <div className="card-header bg-white border-bottom">
                   <h1 className="h5 mb-0 fw-bold">Editar Utilizador</h1>
                </div>
                <div className="card-body p-4">
                   <form onSubmit={handleSubmit}>
                      <div className="mb-3">
                         <label className="form-label fw-semibold">Nome Completo</label>
                         <input 
                            type="text" 
                            className="form-control"
                            required
                            value={formData.name} 
                            onChange={e => setFormData({...formData, name: e.target.value})}
                         />
                      </div>

                      <div className="mb-3">
                         <label className="form-label fw-semibold">Email</label>
                         <input 
                            type="email" 
                            className="form-control"
                            required
                            value={formData.email} 
                            onChange={e => setFormData({...formData, email: e.target.value})}
                         />
                      </div>

                      <div className="mb-3">
                         <label className="form-label fw-semibold">
                             Nova Password 
                             <span className="text-muted fw-normal small">(Deixe em branco para manter)</span>
                         </label>
                         <input 
                            type="password" 
                            className="form-control"
                            value={formData.password} 
                            onChange={e => setFormData({...formData, password: e.target.value})}
                            placeholder="••••••"
                         />
                      </div>

                      <div className="mb-3">
                         <label className="form-label fw-semibold">Role</label>
                         <select 
                            className="form-select"
                            value={formData.role}
                            onChange={e => setFormData({...formData, role: e.target.value})}
                         >
                            <option value="USER">Utilizador</option>
                            <option value="ADMIN">Admin</option>
                         </select>
                      </div>

                      <hr className="my-4" />
                      <h6 className="fw-bold mb-3">Preferências do Utilizador</h6>

                      <div className="mb-3">
                         <label className="form-label fw-semibold">Paróquia Contexto</label>
                         <SearchableSelect
                            options={parishes}
                            value={formData.currentParishId}
                            onChange={(val) => setFormData({...formData, currentParishId: val.toString()})}
                            placeholder="Selecionar paróquia..."
                         />
                      </div>

                      <div className="mb-3">
                         <label className="form-label fw-semibold">Tipo de Evento Preferido</label>
                         <select 
                            className="form-select"
                            value={formData.currentEventType}
                            onChange={e => setFormData({...formData, currentEventType: e.target.value})}
                         >
                            <option value="BAPTISM">Batismo</option>
                            <option value="MARRIAGE">Casamento</option>
                            <option value="DEATH">Óbito</option>
                         </select>
                      </div>

                      <div className="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                         <Link href="/admin/users" className="btn btn-secondary">
                            Cancelar
                         </Link>
                         <button 
                             type="submit" 
                             disabled={saving}
                             className="btn btn-primary"
                         >
                             {saving ? 'A Atualizar...' : 'Atualizar Utilizador'}
                         </button>
                      </div>
                   </form>
                </div>
             </div>
          </div>
       </div>
    </div>
  );
}
