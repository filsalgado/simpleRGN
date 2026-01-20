'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

type ParticipationDetail = {
    id: number;
    eventId: number;
    individualId: number;
    role: string;
    individual: {
        id: number;
        name: string;
        sex: string;
        familyOfOrigin?: {
            father?: { id: number; name: string };
            mother?: { id: number; name: string };
        } | null;
    };
    nickname?: string;
    professionOriginal?: string;
    profession?: { id: number; name: string };
    title?: { id: number; name: string };
    origin?: { id: number; name: string };
    residence?: { id: number; name: string };
    deathPlace?: { id: number; name: string };
    participationRole?: { id: number; name: string };
    kinship?: { id: number; name: string };
};

type EventDetail = {
    id: number;
    type: 'BAPTISM' | 'MARRIAGE' | 'DEATH';
    year?: number;
    month?: number;
    day?: number;
    sourceUrl?: string;
    notes?: string;
    parish: { id: number; name: string };
    participations: ParticipationDetail[];
    createdAt: string;
    updatedAt: string;
};

export default function ViewRecordPage({ params }: { params: Promise<{ id: string }> }) {
    const router = useRouter();
    const [event, setEvent] = useState<EventDetail | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [isDeleting, setIsDeleting] = useState(false);
    const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);

    useEffect(() => {
        const loadEvent = async () => {
            try {
                const resolvedParams = await params;
                const res = await fetch(`/api/records/${resolvedParams.id}`);
                if (!res.ok) throw new Error('Evento não encontrado');
                const data = await res.json();
                setEvent(data);
            } catch (err) {
                setError(err instanceof Error ? err.message : 'Erro ao carregar evento');
            } finally {
                setLoading(false);
            }
        };
        loadEvent();
    }, [params]);

    const handleDelete = async () => {
        if (!event) return;
        
        setIsDeleting(true);
        try {
            const res = await fetch(`/api/records/${event.id}`, {
                method: 'DELETE'
            });
            
            if (!res.ok) throw new Error('Erro ao eliminar evento');
            
            // Redirect to records list after successful deletion
            router.push('/records');
        } catch (err) {
            setError(err instanceof Error ? err.message : 'Erro ao eliminar evento');
            setIsDeleting(false);
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

    if (error || !event) {
        return (
            <div className="container py-4">
                <div className="alert alert-danger" role="alert">
                    {error || 'Evento não encontrado'}
                </div>
                <Link href="/records" className="btn btn-secondary">
                    ← Voltar à Lista
                </Link>
            </div>
        );
    }

    const getTypeLabel = (type: string) => {
        switch (type) {
            case 'BAPTISM': return 'Batismo';
            case 'MARRIAGE': return 'Casamento';
            case 'DEATH': return 'Óbito';
            default: return type;
        }
    };

    const getRoleLabel = (role: string) => {
        const roleMap: Record<string, string> = {
            'SUBJECT': 'Sujeito',
            'GROOM': 'Noivo',
            'BRIDE': 'Noiva',
            'FATHER': 'Pai',
            'MOTHER': 'Mãe',
            'GRANDFATHER_PATERNAL': 'Avô Paterno',
            'GRANDMOTHER_PATERNAL': 'Avó Paterna',
            'GRANDFATHER_MATERNAL': 'Avô Materno',
            'GRANDMOTHER_MATERNAL': 'Avó Materna',
            'PRIEST': 'Padre',
            'GODFATHER': 'Padrinho',
            'GODMOTHER': 'Madrinha',
            'OTHER': 'Outro'
        };
        return roleMap[role] || role;
    };

    const subjects = event.participations
        .filter(p => ['SUBJECT', 'GROOM', 'BRIDE'].includes(p.role))
        .sort((a, b) => {
            const order = ['GROOM', 'BRIDE', 'SUBJECT'];
            return order.indexOf(a.role) - order.indexOf(b.role);
        });

    const witnesses = event.participations
        .filter(p => ['GODFATHER', 'GODMOTHER', 'PRIEST'].includes(p.role))
        .sort((a, b) => a.role.localeCompare(b.role));

    const otherParticipants = event.participations
        .filter(p => !['SUBJECT', 'GROOM', 'BRIDE', 'GODFATHER', 'GODMOTHER', 'PRIEST', 'FATHER', 'MOTHER', 'GRANDFATHER_PATERNAL', 'GRANDMOTHER_PATERNAL', 'GRANDFATHER_MATERNAL', 'GRANDMOTHER_MATERNAL'].includes(p.role));

    return (
        <div className="container py-4">
            <Link href="/records" className="btn btn-link text-decoration-none mb-3">
                ← Voltar à Lista
            </Link>

            <div className="card border-0 shadow-sm mb-4">
                <div className="card-header bg-light">
                    <h1 className="h5 mb-0 fw-bold">{getTypeLabel(event.type)}</h1>
                </div>
                <div className="card-body">
                    <div className="row">
                        <div className="col-md-6">
                            <div className="mb-3">
                                <label className="form-label fw-semibold small text-muted">Paróquia</label>
                                <p className="mb-0">{event.parish.name}</p>
                            </div>
                            <div className="mb-3">
                                <label className="form-label fw-semibold small text-muted">Data</label>
                                <p className="mb-0">
                                    {event.day ? `${event.day}/` : ''}
                                    {event.month ? `${event.month}/` : ''}
                                    {event.year || '?'}
                                </p>
                            </div>
                        </div>
                        <div className="col-md-6">
                            {event.sourceUrl && (
                                <div className="mb-3">
                                    <label className="form-label fw-semibold small text-muted">Fonte</label>
                                    <p className="mb-0">
                                        <a href={event.sourceUrl} target="_blank" rel="noopener noreferrer" className="link-primary">
                                            {event.sourceUrl.substring(0, 50)}...
                                        </a>
                                    </p>
                                </div>
                            )}
                            {event.notes && (
                                <div className="mb-3">
                                    <label className="form-label fw-semibold small text-muted">Notas</label>
                                    <p className="mb-0 text-muted small">{event.notes}</p>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </div>

            {/* Main Subjects */}
            {subjects.length > 0 && (
                <div className="card border-0 shadow-sm mb-4">
                    <div className="card-header bg-light">
                        <h5 className="mb-0 fw-bold">Intervenientes Principais</h5>
                    </div>
                    <div className="card-body">
                        <div className="row">
                            {subjects.map((part) => (
                                <div key={part.id} className="col-md-6 mb-4">
                                    <div className="border rounded p-3">
                                        <div className="d-flex justify-content-between align-items-start mb-2">
                                            <h6 className="mb-0 fw-bold">{part.individual.name}</h6>
                                            <span className="badge bg-primary">{getRoleLabel(part.role)}</span>
                                        </div>
                                        <small className="text-muted d-block mb-2">
                                            {part.individual.sex === 'M' ? 'Masculino' : part.individual.sex === 'F' ? 'Feminino' : 'Indeterminado'}
                                        </small>
                                        
                                        {part.nickname && (
                                            <small className="text-muted d-block">Alcunha: {part.nickname}</small>
                                        )}

                                        {(part.title || part.professionOriginal || part.profession) && (
                                            <small className="text-muted d-block">
                                                {part.title?.name && `${part.title.name} `}
                                                {part.professionOriginal || part.profession?.name}
                                            </small>
                                        )}

                                        {(part.origin || part.residence || part.deathPlace) && (
                                            <small className="text-muted d-block mt-2">
                                                {part.origin?.name && <div>Origem: {part.origin.name}</div>}
                                                {part.residence?.name && <div>Residência: {part.residence.name}</div>}
                                                {part.deathPlace?.name && <div>Óbito: {part.deathPlace.name}</div>}
                                            </small>
                                        )}

                                        {part.individual.familyOfOrigin && (
                                            <small className="text-muted d-block mt-2">
                                                {part.individual.familyOfOrigin.father?.name && <div>Pai: {part.individual.familyOfOrigin.father.name}</div>}
                                                {part.individual.familyOfOrigin.mother?.name && <div>Mãe: {part.individual.familyOfOrigin.mother.name}</div>}
                                            </small>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}

            {/* Witnesses */}
            {witnesses.length > 0 && (
                <div className="card border-0 shadow-sm mb-4">
                    <div className="card-header bg-light">
                        <h5 className="mb-0 fw-bold">Testemunhas e Padrinhos</h5>
                    </div>
                    <div className="card-body">
                        <div className="row">
                            {witnesses.map((part) => (
                                <div key={part.id} className="col-md-4 mb-3">
                                    <div className="border rounded p-3">
                                        <div className="d-flex justify-content-between align-items-start mb-1">
                                            <h6 className="mb-0 fw-bold small">{part.individual.name}</h6>
                                            <span className="badge bg-info text-dark small">{getRoleLabel(part.role)}</span>
                                        </div>
                                        {(part.professionOriginal || part.profession?.name) && (
                                            <small className="text-muted d-block">{part.professionOriginal || part.profession?.name}</small>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}

            {/* Other Participants */}
            {otherParticipants.length > 0 && (
                <div className="card border-0 shadow-sm mb-4">
                    <div className="card-header bg-light">
                        <h5 className="mb-0 fw-bold">Outros Participantes</h5>
                    </div>
                    <div className="card-body">
                        <div className="row">
                            {otherParticipants.map((part) => (
                                <div key={part.id} className="col-md-4 mb-3">
                                    <div className="border rounded p-3">
                                        <div className="d-flex justify-content-between align-items-start mb-1">
                                            <h6 className="mb-0 fw-bold small">{part.individual.name}</h6>
                                            <span className="badge bg-secondary text-white small">{getRoleLabel(part.role)}</span>
                                        </div>
                                        {part.kinship?.name && (
                                            <small className="text-muted d-block">Parentesco: {part.kinship.name}</small>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}

            <div className="d-flex gap-2 mt-4">
                <Link href="/records" className="btn btn-secondary">
                    Voltar
                </Link>
                <Link href={`/records/${event.id}/edit`} className="btn btn-primary">
                    Editar Registo
                </Link>
                <button 
                    className="btn btn-danger ms-auto"
                    onClick={() => setShowDeleteConfirm(true)}
                >
                    Eliminar Registo
                </button>
            </div>

            {/* Delete Confirmation Modal */}
            {showDeleteConfirm && (
                <div className="modal fade show" style={{ display: 'block' }} tabIndex={-1}>
                    <div className="modal-dialog modal-dialog-centered">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h5 className="modal-title">Confirmar Eliminação</h5>
                                <button 
                                    type="button" 
                                    className="btn-close" 
                                    onClick={() => setShowDeleteConfirm(false)}
                                ></button>
                            </div>
                            <div className="modal-body">
                                <p>Tem a certeza que deseja eliminar este registo?</p>
                                <p className="text-muted small">
                                    Esta ação não pode ser desfeita. Todos os intervenientes e dados associados serão removidos.
                                </p>
                            </div>
                            <div className="modal-footer">
                                <button 
                                    type="button" 
                                    className="btn btn-secondary" 
                                    onClick={() => setShowDeleteConfirm(false)}
                                    disabled={isDeleting}
                                >
                                    Cancelar
                                </button>
                                <button 
                                    type="button" 
                                    className="btn btn-danger" 
                                    onClick={handleDelete}
                                    disabled={isDeleting}
                                >
                                    {isDeleting ? 'A eliminar...' : 'Eliminar'}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            )}
            {showDeleteConfirm && <div className="modal-backdrop fade show"></div>}
        </div>
    );
}
