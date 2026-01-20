'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useSession } from 'next-auth/react';

type RecordSummary = {
    id: string;
    type: 'BAPTISM' | 'MARRIAGE' | 'DEATH';
    date: string;
    parish: string;
    mainName: string;
    createdAt: string;
    createdBy: {
        id: number;
        name: string | null;
    };
    updatedBy: {
        id: number;
        name: string | null;
    } | null;
    updatedAt: string;
};

type Parish = { id: string | number; name: string; municipality?: string; district?: string; };

// Searchable Select Component
function SearchableSelect({ options, value, onChange, placeholder = "Selecionar..." }: {
    options: Parish[];
    value: string;
    onChange: (val: string) => void;
    placeholder?: string;
}) {
    const [isOpen, setIsOpen] = useState(false);
    const [search, setSearch] = useState('');
    
    const safeOptions = Array.isArray(options) ? options : [];
    const selectedObj = safeOptions.find(o => o.id.toString() === value.toString());
    const displayValue = isOpen ? search : (selectedObj ? `${selectedObj.name} - ${selectedObj.municipality || 'N/A'} - ${selectedObj.district || 'N/A'}` : '');
    const filteredOptions = safeOptions.filter(o => {
        const fullText = `${o.name} ${o.municipality || ''} ${o.district || ''}`.toLowerCase();
        return fullText.includes(search.toLowerCase());
    });

    return (
        <div className="position-relative" style={{ zIndex: 1000 }}>
            <input 
                type="text"
                className="form-control"
                placeholder={placeholder}
                value={displayValue}
                onChange={(e) => { setSearch(e.target.value); setIsOpen(true); }}
                onFocus={() => { setIsOpen(true); setSearch(''); }}
                onBlur={() => setTimeout(() => setIsOpen(false), 200)}
            />
            {isOpen && (
                <div className="position-absolute w-100 mt-1 border rounded bg-white shadow-sm" style={{ zIndex: 1050, maxHeight: '250px', overflowY: 'auto' }}>
                    {filteredOptions.length > 0 ? (
                        filteredOptions.map(opt => (
                            <div 
                                key={opt.id} 
                                className="px-3 py-2"
                                style={{ cursor: 'pointer', fontSize: '14px' }}
                                onMouseDown={() => { onChange(opt.id.toString()); setIsOpen(false); setSearch(''); }}
                                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
                                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'white'}
                            >
                                {opt.name} - {opt.municipality || 'N/A'} - {opt.district || 'N/A'}
                            </div>
                        ))
                    ) : (
                        <div className="px-3 py-2 text-muted" style={{ fontSize: '14px' }}>
                            Nenhuma paróquia encontrada
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}

export default function RecordsListPage() {
    const { data: session } = useSession();
    const [records, setRecords] = useState<RecordSummary[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [page, setPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    
    // Filtros
    const [filterType, setFilterType] = useState<string>('');
    const [filterParish, setFilterParish] = useState<string>('');
    const [parishes, setParishes] = useState<Parish[]>([]);
    const [showAllParishes, setShowAllParishes] = useState(false);
    
    // Ordenação
    const [sortBy, setSortBy] = useState<'date' | 'type' | 'parish' | 'name'>('date');
    const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');

    // Carregar paróquias
    useEffect(() => {
        const loadParishes = async () => {
            try {
                const res = await fetch('/api/parishes');
                const data = await res.json();
                setParishes(data || []);
            } catch (error) {
                console.error("Failed to load parishes", error);
            }
        };
        loadParishes();
    }, []);

    const fetchRecords = async (pageNum: number) => {
        setIsLoading(true);
        try {
            const params = new URLSearchParams({
                page: pageNum.toString(),
                limit: '10',
                sortBy,
                sortOrder,
            });

            if (filterType) params.append('type', filterType);
            if (filterParish) params.append('parish', filterParish);
            if (showAllParishes && (session?.user as any)?.role === 'ADMIN') {
                params.append('allParishes', 'true');
            }

            const res = await fetch(`/api/records?${params.toString()}`);
            const data = await res.json();
            if (data.data) {
                setRecords(data.data);
                setTotalPages(data.meta.totalPages);
            }
        } catch (error) {
            console.error("Failed to load records", error);
        } finally {
            setIsLoading(false);
        }
    };

    useEffect(() => {
        setPage(1);
    }, [filterType, filterParish, showAllParishes, sortBy, sortOrder]);

    useEffect(() => {
        fetchRecords(page);
    }, [page, filterType, filterParish, showAllParishes, sortBy, sortOrder]);

    const getTypeLabel = (type: string) => {
        switch (type) {
            case 'BAPTISM': return <span className="badge bg-info text-white">Batismo</span>;
            case 'MARRIAGE': return <span className="badge bg-secondary text-white">Casamento</span>;
            case 'DEATH': return <span className="badge bg-dark text-white">Óbito</span>;
            default: return type;
        }
    };

    const handleSort = (column: 'date' | 'type' | 'parish' | 'name') => {
        if (sortBy === column) {
            setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
        } else {
            setSortBy(column);
            setSortOrder('asc');
        }
    };

    const getSortIcon = (column: string) => {
        if (sortBy !== column) return ' ⇅';
        return sortOrder === 'asc' ? ' ↑' : ' ↓';
    };

    const handleDeleteRecord = async (recordId: string) => {
        if (!confirm('Tem a certeza que pretende apagar este assento?')) {
            return;
        }

        try {
            const res = await fetch(`/api/records/${recordId}`, {
                method: 'DELETE',
            });

            if (res.ok) {
                fetchRecords(page);
            } else {
                alert('Erro ao apagar o assento');
            }
        } catch (error) {
            console.error("Failed to delete record", error);
            alert('Erro ao apagar o assento');
        }
    };

    return (
        <div className="container-fluid py-4">
            {/* Header */}
            <div className="card mb-4 border-0 shadow-sm">
                <div className="card-body">
                    <div className="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 className="h4 mb-1 fw-bold">Registos Paroquiais</h1>
                            <p className="text-muted small mb-0">
                                {showAllParishes ? 'Listagem de todos os assentos da base de dados' : 'Listagem de assentos da paróquia ativa'}
                            </p>
                        </div>
                        <Link href="/records/new" className="btn btn-primary">
                            + Novo Registo
                        </Link>
                    </div>
                </div>
            </div>

            {/* Filtros e Controles */}
            <div className="card mb-4 border-0 shadow-sm">
                <div className="card-body">
                    <div className="row g-3 align-items-end">
                        {/* Filtro por Tipo */}
                        <div className="col-md-3">
                            <label className="form-label fw-semibold">Filtrar por Tipo</label>
                            <select
                                className="form-select"
                                value={filterType}
                                onChange={(e) => setFilterType(e.target.value)}
                            >
                                <option value="">Todos os tipos</option>
                                <option value="BAPTISM">Batismo</option>
                                <option value="MARRIAGE">Casamento</option>
                                <option value="DEATH">Óbito</option>
                            </select>
                        </div>

                        {/* Filtro por Paróquia */}
                        <div className="col-md-3">
                            <label className="form-label fw-semibold">Filtrar por Paróquia</label>
                            <SearchableSelect
                                options={parishes}
                                value={filterParish}
                                onChange={setFilterParish}
                                placeholder="Selecionar paróquia..."
                            />
                        </div>

                        {/* Botão Ver Todos (apenas para Admin) */}
                        {(session?.user as any)?.role === 'ADMIN' && (
                            <div className="col-md-2">
                                <button
                                    className={`btn w-100 ${showAllParishes ? 'btn-primary' : 'btn-outline-primary'}`}
                                    onClick={() => setShowAllParishes(!showAllParishes)}
                                >
                                    {showAllParishes ? '✓ Todas' : 'Ver Todas'}
                                </button>
                            </div>
                        )}

                        {/* Botão Limpar Filtros */}
                        <div className="col-md-2">
                            <button
                                className="btn btn-outline-secondary w-100"
                                onClick={() => {
                                    setFilterType('');
                                    setFilterParish('');
                                    setShowAllParishes(false);
                                }}
                            >
                                Limpar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            {/* Tabela de Registos */}
            <div className="card border-0 shadow-sm">
                <div className="card-body">
                    {isLoading ? (
                        <div className="text-center py-5">
                            <div className="spinner-border text-primary mb-2" role="status">
                                <span className="visually-hidden">A carregar...</span>
                            </div>
                            <p className="text-muted">A carregar registos...</p>
                        </div>
                    ) : records.length === 0 ? (
                        <div className="text-center py-5">
                            <p className="text-muted">Não existem registos com estes critérios.</p>
                            <Link href="/records/new" className="btn btn-link">
                                Criar novo registo
                            </Link>
                        </div>
                    ) : (
                        <div className="table-responsive">
                            <table className="table table-hover">
                                <thead>
                                    <tr>
                                        <th 
                                            style={{ cursor: 'pointer' }}
                                            onClick={() => handleSort('name')}
                                            className="user-select-none"
                                        >
                                            Assento {getSortIcon('name')}
                                        </th>
                                        <th 
                                            style={{ cursor: 'pointer' }}
                                            onClick={() => handleSort('type')}
                                            className="user-select-none"
                                        >
                                            Tipo {getSortIcon('type')}
                                        </th>
                                        <th 
                                            style={{ cursor: 'pointer' }}
                                            onClick={() => handleSort('date')}
                                            className="user-select-none"
                                        >
                                            Data {getSortIcon('date')}
                                        </th>
                                        <th 
                                            style={{ cursor: 'pointer' }}
                                            onClick={() => handleSort('parish')}
                                            className="user-select-none"
                                        >
                                            Paróquia {getSortIcon('parish')}
                                        </th>
                                        <th style={{ width: '50px' }} className="text-center">Info</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {records.map((record) => (
                                        <tr key={record.id}>
                                            <td className="fw-semibold">{record.mainName}</td>
                                            <td>{getTypeLabel(record.type)}</td>
                                            <td>{record.date}</td>
                                            <td className="text-muted">{record.parish}</td>
                                            <td className="text-center">
                                                <span 
                                                    className="badge bg-light text-dark cursor-help"
                                                    title={`Criado por: ${record.createdBy.name || 'Desconhecido'} em ${new Date(record.createdAt).toLocaleString('pt-PT')}\nÚltima edição por: ${record.updatedBy?.name || 'Não editado'} em ${record.updatedBy ? new Date(record.updatedAt).toLocaleString('pt-PT') : 'N/A'}`}
                                                    style={{ cursor: 'help' }}
                                                >
                                                    ⓘ
                                                </span>
                                            </td>
                                            <td>
                                                <div className="btn-group btn-group-sm" role="group">
                                                    <Link 
                                                        href={`/records/${record.id}`} 
                                                        className="btn btn-outline-primary"
                                                        title="Ver"
                                                    >
                                                        👁️
                                                    </Link>
                                                    <Link 
                                                        href={`/records/${record.id}/edit`} 
                                                        className="btn btn-outline-warning"
                                                        title="Editar"
                                                    >
                                                        ✏️
                                                    </Link>
                                                    <button 
                                                        onClick={() => handleDeleteRecord(record.id)}
                                                        className="btn btn-outline-danger"
                                                        title="Apagar"
                                                    >
                                                        🗑️
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                    
                    {!isLoading && records.length > 0 && (
                        <div className="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                            <small className="text-muted">Página {page} de {totalPages}</small>
                            <div className="btn-group" role="group">
                                <button 
                                    onClick={() => setPage(p => Math.max(1, p - 1))}
                                    disabled={page === 1}
                                    className="btn btn-sm btn-outline-secondary"
                                >
                                    &larr; Anterior
                                </button>
                                <button 
                                    onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                                    disabled={page === totalPages}
                                    className="btn btn-sm btn-outline-secondary"
                                >
                                    Seguinte &rarr;
                                </button>
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
