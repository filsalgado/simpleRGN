'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

type Parish = { id: number; name: string; };

export default function NewUserPage() {
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
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetch('/api/parishes')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setParishes(data);
        }
      })
      .catch(e => console.error("Error loading parishes:", e));
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    try {
        const res = await fetch('/api/users', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
        
        if (res.status === 403) {
            alert('Acesso negado. Apenas administradores podem criar utilizadores.');
            router.push('/');
            setLoading(false);
            return;
        }

        if (res.ok) {
            router.push('/admin/users');
        } else {
            const error = await res.json();
            alert('Erro ao criar utilizador: ' + (error.error || 'Erro desconhecido'));
        }
    } catch(e) {
        alert('Erro de conexão: ' + e);
    } finally {
        setLoading(false);
    }
  };

  return (
    <div className="container py-4">
       <div className="row justify-content-center">
          <div className="col-lg-8">
             <Link href="/admin/users" className="btn btn-link text-decoration-none mb-3">
                ← Voltar à Lista
             </Link>

             <div className="card border-0 shadow-sm">
                <div className="card-header bg-white border-bottom">
                   <h1 className="h5 mb-0 fw-bold">Novo Utilizador</h1>
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
                         <label className="form-label fw-semibold">Password Inicial</label>
                         <input 
                            type="password" 
                            className="form-control"
                            required
                            value={formData.password} 
                            onChange={e => setFormData({...formData, password: e.target.value})}
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
                         <select 
                            className="form-select"
                            value={formData.currentParishId}
                            onChange={e => setFormData({...formData, currentParishId: e.target.value})}
                         >
                            <option value="">Selecionar...</option>
                            {parishes.map(p => (
                              <option key={p.id} value={p.id}>
                                {p.name} - {(p as any).municipality || 'N/A'} - {(p as any).district || 'N/A'}
                              </option>
                            ))}
                         </select>
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
                             disabled={loading}
                             className="btn btn-primary"
                         >
                             {loading ? 'A Gravar...' : 'Criar Utilizador'}
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
