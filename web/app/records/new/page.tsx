'use client';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';

// --- Types ---
type EventType = 'BAPTISM' | 'MARRIAGE' | 'DEATH';

type PersonData = {
  id: string;
  role: string;
  name: string;
  nickname: string;
  professionId: string;
  professionOriginal: string;
  origin: string;
  residence: string;
  deathPlace: string;
  titleId: string;
  sex: 'M' | 'F' | 'D';
  legitimacyStatusId: string;
  participationRoleId?: string;
  kinshipId?: string;
  lineageIndex?: string;
  father?: PersonData;
  mother?: PersonData;
};

type EventData = {
  type: EventType;
  year: string;
  month: string;
  day: string;
  sourceUrl: string;
  notes: string;
  parishId: string;
}

type Parish = { id: string; name: string; municipality?: string; district?: string; }
type Place = { id: string; name: string; parishId: string; parish?: Parish; }
type Title = { id: number; name: string; }
type Profession = { id: number; name: string; }
type ParticipationRole = { id: number; name: string; }
type Kinship = { id: number; name: string; }
type LegitimacyStatus = { id: number; name: string; }

const createEmptyPerson = (role: string, idSuffix: string): PersonData => ({
  id: `temp_${Date.now()}_${idSuffix}`,
  role,
  name: '',
  sex: 'D', 
  legitimacyStatusId: '',
  nickname: '',
  professionId: '',
  professionOriginal: '',
  origin: '',
  residence: '',
  deathPlace: '',
  titleId: '',
});

// Searchable Select Component
function SearchableSelect({ options, value, onChange, placeholder = "Selecionar...", onAddNew, disabled = false }: {
  options: { id: string | number, name: string }[];
  value: string | number;
  onChange: (val: string) => void;
  placeholder?: string;
  onAddNew?: () => void;
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
            <div className="px-3 py-2 text-muted" style={{ fontSize: '14px' }}>Sem resultados</div>
          )}
          {onAddNew && (
            <div 
              className="px-3 py-2 border-top text-primary fw-semibold cursor-pointer"
              style={{ cursor: 'pointer', fontSize: '14px' }}
              onMouseDown={() => { onAddNew(); setIsOpen(false); }}
              onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
              onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'white'}
            >
              + Criar Novo
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// Place Selector with Parish Search Component
function PlaceWithParishSelector({ 
  parishes, 
  places,
  contextParishId,
  value, 
  onChange, 
  placeholder = "...", 
  onAddNew, 
  disabled = false 
}: {
  parishes: Parish[];
  places?: { id: string | number; name: string; parishId: string }[];
  contextParishId: string;
  value: string;
  onChange: (val: string) => void;
  placeholder?: string;
  onAddNew?: () => void;
  disabled?: boolean;
}) {
  const [selectedParish, setSelectedParish] = useState<string>(contextParishId || '');
  const [placesOptions, setPlacesOptions] = useState<{ id: string | number; name: string }[]>([]);
  const [isOpenParish, setIsOpenParish] = useState(false);
  const [searchParish, setSearchParish] = useState('');
  const [isOpenPlace, setIsOpenPlace] = useState(false);
  const [searchPlace, setSearchPlace] = useState('');

  // Determine the correct parish for the selected place
  useEffect(() => {
    if (!value) {
      // No place selected, use context parish
      setSelectedParish(contextParishId || '');
      return;
    }

    // Fetch the place by ID to get its parish
    fetch(`/api/places/${value}`)
      .then(res => {
        if (res.ok) return res.json();
        throw new Error('Place not found');
      })
      .then(place => {
        if (place && place.parishId) {
          setSelectedParish(place.parishId.toString());
        } else {
          setSelectedParish(contextParishId || '');
        }
      })
      .catch(() => setSelectedParish(contextParishId || ''));
  }, [value, contextParishId]);

  // Load places for selected parish when it changes
  useEffect(() => {
    if (selectedParish) {
      fetch(`/api/places?parishId=${selectedParish}`)
        .then(res => res.json())
        .then(data => {
          if (Array.isArray(data)) {
            setPlacesOptions(data.map(p => ({ id: p.id, name: p.name })));
          }
        })
        .catch(() => setPlacesOptions([]));
    } else {
      setPlacesOptions([]);
    }
  }, [selectedParish]);

  const selectedPlace = placesOptions.find(p => p.id.toString() === value.toString());
  const selectedParishObj = parishes.find(p => p.id.toString() === selectedParish.toString());
  const getParishDisplay = (p: Parish) => `${p.name} - ${p.municipality || ''}`.trim();

  // Filter parishes by search
  const filteredParishes = searchParish.trim() === '' 
    ? parishes 
    : parishes.filter(p => getParishDisplay(p).toLowerCase().includes(searchParish.toLowerCase()));
  
  return (
    <div className="d-flex gap-2">
      <div className="flex-grow-1 position-relative">
        <input 
          type="text"
          className="form-control"
          placeholder="Paróquia..."
          value={isOpenParish ? searchParish : (selectedParishObj ? getParishDisplay(selectedParishObj) : '')}
          onChange={(e) => { setSearchParish(e.target.value); setIsOpenParish(true); }}
          onFocus={() => { setIsOpenParish(true); setSearchParish(''); }}
          onBlur={() => setTimeout(() => setIsOpenParish(false), 200)}
          disabled={disabled}
          style={value ? { backgroundColor: '#c8e6c9' } : {}}
        />
        {isOpenParish && (
          <div className="position-absolute w-100 mt-1 border rounded bg-white shadow-sm" style={{ zIndex: 1050, maxHeight: '250px', overflowY: 'auto' }}>
            {filteredParishes.length > 0 ? (
              filteredParishes.map(p => (
                <div 
                  key={p.id} 
                  className="px-3 py-2 cursor-pointer"
                  style={{ cursor: 'pointer', fontSize: '14px' }}
                  onMouseDown={() => { 
                    setSelectedParish(p.id);
                    setIsOpenParish(false); 
                    setSearchParish(''); 
                  }}
                  onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
                  onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'white'}
                >
                  {getParishDisplay(p)}
                </div>
              ))
            ) : (
              <div className="px-3 py-2 text-muted" style={{ fontSize: '14px' }}>Sem resultados</div>
            )}
          </div>
        )}
      </div>
      <div className="flex-grow-1 position-relative">
        <input 
          type="text"
          className="form-control"
          placeholder={placeholder}
          value={isOpenPlace ? searchPlace : (selectedPlace ? selectedPlace.name : '')}
          onChange={(e) => { setSearchPlace(e.target.value); setIsOpenPlace(true); }}
          onFocus={() => { setIsOpenPlace(true); setSearchPlace(''); }}
          onBlur={() => setTimeout(() => setIsOpenPlace(false), 200)}
          disabled={disabled || !selectedParish}
          style={value ? { backgroundColor: '#c8e6c9' } : {}}
        />
        {isOpenPlace && selectedParish && (
          <div className="position-absolute w-100 mt-1 border rounded bg-white shadow-sm" style={{ zIndex: 1050, maxHeight: '250px', overflowY: 'auto' }}>
            {placesOptions.filter(o => o.name.toLowerCase().includes(searchPlace.toLowerCase())).length > 0 ? (
              placesOptions
                .filter(o => o.name.toLowerCase().includes(searchPlace.toLowerCase()))
                .map(opt => (
                  <div 
                    key={opt.id} 
                    className="px-3 py-2 cursor-pointer"
                    style={{ cursor: 'pointer', fontSize: '14px' }}
                    onMouseDown={() => { onChange(opt.id.toString()); setIsOpenPlace(false); setSearchPlace(''); }}
                    onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
                    onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'white'}
                  >
                    {opt.name}
                  </div>
                ))
            ) : (
              <div className="px-3 py-2 text-muted" style={{ fontSize: '14px' }}>Sem resultados</div>
            )}
            {onAddNew && (
              <div 
                className="px-3 py-2 border-top text-primary fw-semibold cursor-pointer"
                style={{ cursor: 'pointer', fontSize: '14px' }}
                onMouseDown={() => { onAddNew(); setIsOpenPlace(false); }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f8f9fa'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'white'}
              >
                + Criar Novo Lugar
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default function NewRecordPageBootstrap() {
  const [eventType, setEventType] = useState<EventType>('BAPTISM');
  const [eventData, setEventData] = useState<EventData>({
    type: 'BAPTISM',
    year: '',
    month: '',
    day: '',
    sourceUrl: '',
    notes: '',
    parishId: ''
  });

  const [parishes, setParishes] = useState<Parish[]>([]);
  const [titles, setTitles] = useState<Title[]>([]);
  const [professions, setProfessions] = useState<Profession[]>([]);
  const [participationRoles, setParticipationRoles] = useState<ParticipationRole[]>([]);
  const [kinships, setKinships] = useState<Kinship[]>([]);
  const [legitimacyStatuses, setLegitimacyStatuses] = useState<LegitimacyStatus[]>([]);
  const [contextParishPlaces, setContextParishPlaces] = useState<Place[]>([]);
  const [allPlaces, setAllPlaces] = useState<(Place & { parishId: string })[]>([]);
  const [isLoadingMetadata, setIsLoadingMetadata] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  
  // Track expanded person for detailed editing
  const [expandedPersonIds, setExpandedPersonIds] = useState<Set<string>>(new Set());
  
  // Toggle expansion for a person
  const toggleExpandedPerson = (id: string) => {
    setExpandedPersonIds(prev => {
      const newSet = new Set(prev);
      if (newSet.has(id)) {
        newSet.delete(id);
      } else {
        newSet.add(id);
      }
      return newSet;
    });
  };
  
  // Modal states
  const [showPlaceModal, setShowPlaceModal] = useState(false);
  const [showTitleModal, setShowTitleModal] = useState(false);
  const [modalCallback, setModalCallback] = useState<((id: string) => void) | null>(null);
  
  const [primarySubject, setPrimarySubject] = useState<PersonData>(createEmptyPerson('SUBJECT', 'primary'));
  const [secondarySubject, setSecondarySubject] = useState<PersonData>(createEmptyPerson('SUBJECT', 'secondary'));
  const [participants, setParticipants] = useState<PersonData[]>([]);

  const router = useRouter();

  useEffect(() => {
    setIsLoadingMetadata(true);
    const fetchData = async () => {
        try {
            const [pRes, tRes, profRes, rRes, ctxRes, legRes, placesRes] = await Promise.all([
                fetch('/api/parishes'),
                fetch('/api/titles'),
                fetch('/api/professions'),
                fetch('/api/participation-roles'),
                fetch('/api/users/me/context/current'),
                fetch('/api/legitimacy-statuses'),
                fetch('/api/places')
            ]);
            
            const kinRes = await fetch('/api/kinships').catch(() => null);

            const pData = await pRes.json();
            const ctxData = await ctxRes.json();
            
            if (Array.isArray(pData)) {
                setParishes(pData);
                if (ctxData && ctxData.parishId) {
                    handleEventChange('parishId', ctxData.parishId);
                } else if (pData.length > 0 && !eventData.parishId) {
                    handleEventChange('parishId', pData[0].id);
                }
            }

            // Load event type preference
            if (ctxData && ctxData.eventType) {
              setEventType(ctxData.eventType as EventType);
              setEventData(prev => ({ ...prev, type: ctxData.eventType as EventType }));
            }

            const tData = await tRes.json();
            if(Array.isArray(tData)) setTitles(tData);

            const profData = await profRes.json();
            if(Array.isArray(profData)) setProfessions(profData);

            const rData = await rRes.json();
            if(Array.isArray(rData)) setParticipationRoles(rData);

            const lData = await legRes.json();
            if(Array.isArray(lData)) setLegitimacyStatuses(lData);
            
            if(kinRes && kinRes.ok) {
                const kData = await kinRes.json();
                if(Array.isArray(kData)) setKinships(kData);
            }

            const placesData = await placesRes.json();
            if(Array.isArray(placesData)) setAllPlaces(placesData);

        } catch (error) {
            console.error("Error loading metadata:", error);
        } finally {
            setIsLoadingMetadata(false);
        }
    };
    fetchData();
  }, []);

  useEffect(() => {
      if (eventData.parishId) {
          fetch(`/api/places?parishId=${eventData.parishId}`)
            .then(res => res.json())
            .then(data => { if (Array.isArray(data)) setContextParishPlaces(data); })
            .catch(e => console.error("Error fetching places:", e));
      }
  }, [eventData.parishId]);

  const handleEventChange = (field: keyof EventData, value: string) => {
    setEventData(prev => ({ ...prev, [field]: value }));
  };

  const updatePerson = (root: 'primary' | 'secondary', updatedPerson: PersonData) => {
    if (root === 'primary') setPrimarySubject(updatedPerson);
    else setSecondarySubject(updatedPerson);
  };
  
  const addParticipant = () => {
      setParticipants(prev => [...prev, createEmptyPerson('OTHER', `part_${prev.length}`)]);
  };

  const updateParticipant = (index: number, updated: PersonData) => {
      setParticipants(prev => {
          const newArr = [...prev];
          newArr[index] = updated;
          return newArr;
      });
  };

  const removeParticipant = (index: number) => {
      setParticipants(prev => prev.filter((_, i) => i !== index));
  };

  const reloadTitles = () => {
    fetch('/api/titles').then(res => res.json()).then(data => {
      if (Array.isArray(data)) setTitles(data);
    });
  };

  const reloadPlaces = () => {
    if (eventData.parishId) {
      fetch(`/api/places?parishId=${eventData.parishId}`)
        .then(res => res.json())
        .then(data => { if (Array.isArray(data)) setContextParishPlaces(data); });
    }
  };

  const openPlaceModal = (callback: (id: string) => void) => {
    setModalCallback(() => callback);
    setShowPlaceModal(true);
  };

  const openTitleModal = (callback: (id: string) => void) => {
    setModalCallback(() => callback);
    setShowTitleModal(true);
  };

  const handleSave = async () => {
      if (!eventData.parishId) {
          alert('Por favor selecione a Paróquia.');
          return;
      }
      if (!primarySubject.name) {
          alert('O interveniente principal deve ter um nome.');
          return;
      }

      // Validar data se todos os campos estiverem preenchidos
      if (eventData.year && eventData.month && eventData.day) {
          const year = parseInt(eventData.year);
          const month = parseInt(eventData.month);
          const day = parseInt(eventData.day);

          // Validar ranges
          if (year < 0 || year > 2100) {
              alert('Ano deve estar entre 0 e 2100.');
              return;
          }
          if (month < 1 || month > 12) {
              alert('Mês deve estar entre 1 e 12.');
              return;
          }
          if (day < 1 || day > 31) {
              alert('Dia deve estar entre 1 e 31.');
              return;
          }

          // Validar se é uma data válida usando Date
          const date = new Date(year, month - 1, day);
          if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) {
              alert(`A data ${day}/${month}/${year} não é válida. Verifique se a data existe (ex: fevereiro tem 28/29 dias).`);
              return;
          }
      }

      setIsSaving(true);
      
      // Helper function to add lineageIndex to person and their ancestors
      const addLineageIndex = (person: PersonData, lineageIndex: string): PersonData => {
        return {
          ...person,
          lineageIndex: lineageIndex,
          father: person.father ? addLineageIndex(person.father, lineageIndex + '.1') : undefined,
          mother: person.mother ? addLineageIndex(person.mother, lineageIndex + '.2') : undefined
        };
      };
      
      const payload = {
          event: eventData,
          subjects: {
            primary: addLineageIndex(primarySubject, '1'),
            secondary: secondarySubject && eventType === 'MARRIAGE' ? addLineageIndex(secondarySubject, '2') : secondarySubject
          },
          participants: participants
      };

      try {
          const res = await fetch('/api/records', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(payload)
          });
          
          if (!res.ok) {
              const err = await res.json();
              alert('Erro ao gravar: ' + (err.error || 'Erro desconhecido'));
              return;
          }
          
          alert('Registo gravado com sucesso!');
          window.location.reload();
      } catch (e) {
          console.error(e);
          alert('Erro de comunicação.');
      } finally {
          setIsSaving(false);
      }
  };

  const getPrimaryLabel = () => {
    switch (eventType) {
      case 'BAPTISM': return 'Batizando';
      case 'DEATH': return 'Defunto';
      case 'MARRIAGE': return 'Noivo';
    }
  };

  const getAutoSexFromLabel = (label: string): 'M' | 'F' | 'D' => {
    const feminineLables = ['Mãe', 'Avó', 'Avó Materna', 'Avó Paterno', 'Noiva', 'Bisavó', 'Tataravó'];
    const masculineLabels = ['Pai', 'Avô', 'Avô Materno', 'Avô Paterno', 'Noivo', 'Bisavô', 'Tataravô'];
    
    if (feminineLables.some(l => label.includes(l))) return 'F';
    if (masculineLabels.some(l => label.includes(l))) return 'M';
    return 'D';
  };

  return (
    <>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
      
      <style jsx global>{`
        body {
          background-color: #f8f9fa;
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        
        .form-label {
          font-size: 11px;
          font-weight: 600;
          color: #6c757d;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          margin-bottom: 0.25rem;
        }
        
        .form-control, .form-select {
          font-size: 14px;
          padding: 0.5rem 0.75rem;
          border: 1px solid #dee2e6;
          border-radius: 0.375rem;
        }
        
        .form-control:focus, .form-select:focus {
          border-color: #6366f1;
          box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.15);
        }
        
        .btn-primary {
          background-color: #6366f1;
          border-color: #6366f1;
          padding: 0.5rem 1.5rem;
          font-weight: 500;
        }
        
        .btn-primary:hover {
          background-color: #4f46e5;
          border-color: #4f46e5;
        }
        
        .btn-outline-secondary {
          font-size: 13px;
          padding: 0.375rem 0.75rem;
        }
        
        .card {
          border: 1px solid #e5e7eb;
          border-radius: 0.5rem;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        .card-header {
          background-color: #fff;
          border-bottom: 1px solid #e5e7eb;
          padding: 1rem 1.25rem;
          font-size: 13px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #374151;
        }
        
        .person-card {
          border: 1px solid #e5e7eb;
          border-radius: 0.375rem;
          padding: 1rem;
          background: white;
          margin-bottom: 1rem;
        }

        /* Cores por geração/relação */
        .person-card.gen-0 {
          background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
          border-color: #3b82f6;
          border-left: 4px solid #3b82f6;
        }

        .person-card.gen-1 {
          background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
          border-color: #f59e0b;
          border-left: 4px solid #f59e0b;
        }

        .person-card.gen-2 {
          background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
          border-color: #0ea5e9;
          border-left: 4px solid #0ea5e9;
        }

        .person-card.gen-3 {
          background: linear-gradient(135deg, #f0e7fe 0%, #e9d5ff 100%);
          border-color: #a78bfa;
          border-left: 4px solid #a78bfa;
        }

        .person-card.gen-secondary {
          background: linear-gradient(135deg, #f3e8ff 0%, #ede9fe 100%);
          border-color: #d946ef;
          border-left: 4px solid #d946ef;
        }

        .person-card.participant {
          background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
          border-color: #10b981;
          border-left: 4px solid #10b981;
        }
        
        .person-card-header {
          font-size: 11px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #6b7280;
          margin-bottom: 0.75rem;
          padding-bottom: 0.5rem;
          border-bottom: 1px solid rgba(0, 0, 0, 0.1);
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }

        .person-card-header-icon {
          font-size: 14px;
          min-width: 20px;
        }

        .modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(0, 0, 0, 0.5);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 2000;
        }

        .modal-content-expanded {
          background: white;
          border-radius: 0.5rem;
          max-width: 900px;
          max-height: 90vh;
          overflow-y: auto;
          padding: 2rem;
          width: 95%;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .person-card-minimized {
          background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
          border: 2px solid #0284c7;
          border-radius: 0.375rem;
          padding: 1rem;
          cursor: pointer;
          transition: all 0.2s ease;
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 1rem;
        }

        .person-card-minimized:hover {
          background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
          border-color: #0369a1;
          box-shadow: 0 4px 6px rgba(2, 132, 199, 0.2);
          transform: translateY(-2px);
        }

        .person-card-minimized-info {
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }

        .person-card-minimized-name {
          font-size: 16px;
          font-weight: 600;
          color: #0c4a6e;
        }

        .person-card-minimized-label {
          font-size: 11px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #0369a1;
        }

        .person-card-minimized-meta {
          font-size: 12px;
          color: #475569;
          display: flex;
          gap: 1rem;
        }

        .person-card-minimized-sex {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          width: 28px;
          height: 28px;
          border-radius: 50%;
          font-weight: 700;
          font-size: 12px;
          color: white;
        }

        .person-card-minimized-sex.m {
          background: #3b82f6;
        }

        .person-card-minimized-sex.f {
          background: #ec4899;
        }

        .person-card-minimized-sex.d {
          background: #6b7280;
        }
        
        .btn-sex {
          padding: 0.375rem 1rem;
          font-size: 12px;
          font-weight: 700;
          border: 1px solid #d1d5db;
          background: white;
          color: #6b7280;
        }
        
        .btn-sex.active {
          border-width: 2px;
          box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
        }
        
        .btn-sex.active.btn-m {
          background: #3b82f6;
          border-color: #2563eb;
          color: white;
        }
        
        .btn-sex.active.btn-f {
          background: #ec4899;
          border-color: #db2777;
          color: white;
        }
        
        .btn-sex.active.btn-d {
          background: #6b7280;
          border-color: #4b5563;
          color: white;
        }
        
        .badge-role {
          font-size: 10px;
          font-weight: 700;
          padding: 0.25rem 0.5rem;
          border-radius: 1rem;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }
        
        .section-title {
          font-size: 13px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #374151;
          margin-bottom: 1rem;
          padding-bottom: 0.5rem;
          border-bottom: 2px solid #e5e7eb;
        }
        
        .form-control-sm {
          font-size: 13px;
          padding: 0.375rem 0.625rem;
        }
        
        .modal {
          z-index: 1055;
        }
        
        .person-lineage {
          margin-top: 1.5rem;
          padding-left: 1.5rem;
          border-left: 3px solid #cbd5e1;
          position: relative;
        }

        .person-lineage-paternal {
          border-left-color: #3b82f6;
          background: linear-gradient(90deg, rgba(59, 130, 246, 0.05) 0%, transparent 100%);
          padding: 1rem 1rem 1rem 1.5rem;
          border-radius: 0.375rem;
        }

        .person-lineage-maternal {
          border-left-color: #ec4899;
          background: linear-gradient(90deg, rgba(236, 72, 153, 0.05) 0%, transparent 100%);
          padding: 1rem 1rem 1rem 1.5rem;
          border-radius: 0.375rem;
        }

        .person-lineage-label {
          font-size: 11px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #6b7280;
          margin-bottom: 0.75rem;
          padding-bottom: 0.5rem;
          border-bottom: 1px solid currentColor;
          opacity: 0.7;
        }
        
        .modal-backdrop {
          z-index: 1050;
        }
      `}</style>

      <div className="container-fluid" style={{ maxWidth: '1200px' }}>
        {/* Header */}
        <div className="bg-white border-bottom mb-4 py-3">
          <div className="d-flex justify-content-between align-items-center">
            <div>
              <h1 className="h5 mb-1 fw-bold">Novo Registo</h1>
              <p className="text-muted mb-0" style={{ fontSize: '12px' }}>Adicionar registo paroquial à base de dados</p>
            </div>
            <div className="d-flex gap-3 align-items-center">
              <div style={{ width: '250px' }}>
                <label className="form-label mb-1">Paróquia Contexto</label>
                <SearchableSelect
                  options={parishes.map(p => ({ id: p.id, name: `${p.name} - ${p.municipality} - ${p.district}` }))}
                  value={eventData.parishId}
                  onChange={(val) => handleEventChange('parishId', val)}
                  placeholder="Selecione paróquia..."
                />
              </div>
              <button 
                className="btn btn-primary" 
                onClick={handleSave}
                disabled={isSaving}
              >
                {isSaving ? 'A gravar...' : 'Gravar Registo'}
              </button>
            </div>
          </div>
        </div>

        {/* Dados do Assento */}
        <div className="card mb-4">
          <div className="card-header">Dados do Assento</div>
          <div className="card-body">
            <div className="row g-3">
              <div className="col-md-3">
                <label className="form-label">Tipo de Evento</label>
                <select 
                  className="form-select"
                  value={eventType}
                  onChange={(e) => {
                    setEventType(e.target.value as EventType);
                    setEventData(prev => ({ ...prev, type: e.target.value as EventType }));
                  }}
                >
                  <option value="BAPTISM">Batismo</option>
                  <option value="MARRIAGE">Casamento</option>
                  <option value="DEATH">Óbito</option>
                </select>
              </div>
              
              <div className="col-md-2">
                <label className="form-label">Ano</label>
                <input 
                  type="number" 
                  className="form-control" 
                  placeholder="Ano"
                  min="0"
                  max="2100"
                  value={eventData.year}
                  onChange={(e) => handleEventChange('year', e.target.value)}
                />
              </div>
              
              <div className="col-md-2">
                <label className="form-label">Mês</label>
                <input 
                  type="number" 
                  className="form-control" 
                  placeholder="Mês"
                  min="1"
                  max="12"
                  value={eventData.month}
                  onChange={(e) => handleEventChange('month', e.target.value)}
                />
              </div>
              
              <div className="col-md-2">
                <label className="form-label">Dia</label>
                <input 
                  type="number" 
                  className="form-control" 
                  placeholder="Dia"
                  min="1"
                  max="31"
                  value={eventData.day}
                  onChange={(e) => handleEventChange('day', e.target.value)}
                />
              </div>
              
              <div className="col-md-12">
                <label className="form-label">Fonte Digital (Link)</label>
                <input 
                  type="url" 
                  className="form-control" 
                  placeholder="https://arquivo..."
                  value={eventData.sourceUrl}
                  onChange={(e) => handleEventChange('sourceUrl', e.target.value)}
                />
              </div>
              
              <div className="col-md-12">
                <label className="form-label">Observações</label>
                <textarea 
                  className="form-control" 
                  rows={3}
                  placeholder="Notas adicionais..."
                  value={eventData.notes}
                  onChange={(e) => handleEventChange('notes', e.target.value)}
                />
              </div>
            </div>
          </div>
        </div>

        {/* Árvore Genealógica */}
        <div className="card mb-4">
          <div className="card-header d-flex justify-content-between align-items-center">
            <span>Árvore Genealógica</span>
            {eventType === 'MARRIAGE' && (
              <span className="badge bg-secondary">Noivo + Noiva</span>
            )}
          </div>
          <div className="card-body">
            <PersonCard
              person={primarySubject}
              label={getPrimaryLabel()}
              onChange={(p) => updatePerson('primary', p)}
              titles={titles}
              professions={professions}
              legitimacyStatuses={legitimacyStatuses}
              places={allPlaces}
              parishes={parishes}
              contextParishId={eventData.parishId}
              onAddPlace={openPlaceModal}
              onAddTitle={openTitleModal}
              generation={0}
              expandedPersonIds={expandedPersonIds}
              onToggleExpandedPerson={toggleExpandedPerson}
              lineagePath="1"
            />
            
            {eventType === 'MARRIAGE' && (
              <>
                <hr className="my-4" />
                <PersonCard
                  person={secondarySubject}
                  label="Noiva"
                  onChange={(p) => updatePerson('secondary', p)}
                  titles={titles}
                  professions={professions}
                  legitimacyStatuses={legitimacyStatuses}
                  places={allPlaces}
                  parishes={parishes}
                  contextParishId={eventData.parishId}
                  onAddPlace={openPlaceModal}
                  onAddTitle={openTitleModal}
                  generation={0}
                  isSecondary={true}
                  expandedPersonIds={expandedPersonIds}
                  onToggleExpandedPerson={toggleExpandedPerson}
                  lineagePath="2"
                />
              </>
            )}
          </div>
        </div>

        {/* Outros Intervenientes */}
        <div className="card mb-4">
          <div className="card-header d-flex justify-content-between align-items-center">
            <span>Outros Intervenientes</span>
            <button className="btn btn-outline-secondary btn-sm" onClick={addParticipant}>
              + Adicionar
            </button>
          </div>
          <div className="card-body">
            {participants.length === 0 ? (
              <div className="text-center text-muted py-5">
                <p>Nenhum interveniente extra.</p>
                <p className="small">Adicione padres, testemunhas ou padrinhos.</p>
              </div>
            ) : (
              <div className="row g-3">
                {participants.map((person, idx) => (
                  <div key={person.id} className="col-md-12">
                    <div className="person-card">
                      <div className="d-flex justify-content-between align-items-center mb-3">
                        <div style={{ flex: 1 }}>
                          <SearchableSelect
                            options={participationRoles.map(r => ({ id: r.id, name: r.name }))}
                            value={person.participationRoleId || ''}
                            onChange={(e) => updateParticipant(idx, { ...person, participationRoleId: e })}
                            placeholder="Função..."
                          />
                        </div>
                        <div style={{ flex: 1 }}>
                          <SearchableSelect
                            options={kinships.map(k => ({ id: k.id, name: k.name }))}
                            value={person.kinshipId || ''}
                            onChange={(e) => updateParticipant(idx, { ...person, kinshipId: e })}
                            placeholder="Parentesco..."
                          />
                        </div>
                        <button 
                          className="btn btn-sm btn-outline-danger"
                          onClick={() => removeParticipant(idx)}
                        >
                          ×
                        </button>
                      </div>
                      <PersonCard
                        person={person}
                        label=""
                        onChange={(p) => updateParticipant(idx, p)}
                        titles={titles}
                        professions={professions}
                        legitimacyStatuses={legitimacyStatuses}
                        places={allPlaces}
                        parishes={parishes}
                        contextParishId={eventData.parishId}
                        onAddPlace={openPlaceModal}
                        onAddTitle={openTitleModal}
                        hideParentsButton
                        isParticipant={true}
                      />
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Botão de Gravação Final */}
        <div className="card mb-4">
          <div className="card-body d-flex gap-2 justify-content-end">
            <button 
              className="btn btn-primary" 
              onClick={handleSave}
              disabled={isSaving}
              style={{ minWidth: '150px' }}
            >
              {isSaving ? 'A gravar...' : 'Gravar Registo'}
            </button>
          </div>
        </div>
      </div>
      
      {/* Modal para adicionar lugar */}
      {showPlaceModal && (
        <PlaceModal
          parishes={parishes}
          selectedParishId={eventData.parishId}
          onClose={() => setShowPlaceModal(false)}
          onSave={(placeId) => {
            reloadPlaces();
            if (modalCallback) modalCallback(placeId);
            setShowPlaceModal(false);
          }}
        />
      )}
      
      {/* Modal para adicionar título */}
      {showTitleModal && (
        <TitleModal
          onClose={() => setShowTitleModal(false)}
          onSave={(titleId) => {
            reloadTitles();
            if (modalCallback) modalCallback(titleId);
            setShowTitleModal(false);
          }}
        />
      )}
    </>
  );
}

// Person Card Minimized (collapsed view)
function PersonCardMinimized({ person, label, onClick, generation }: {
  person: PersonData;
  label: string;
  onClick: () => void;
  generation: number;
}) {
  const getIcon = () => {
    switch (label) {
      case 'Pai': return '👨';
      case 'Mãe': return '👩';
      case 'Avó Paterno': return '👴';
      case 'Avó Materna': return '👵';
      case 'Noivo': return '💍';
      case 'Noiva': return '💍';
      default: return '';
    }
  };

  const sexDisplay = () => {
    if (person.sex === 'M') return 'M';
    if (person.sex === 'F') return 'F';
    return '?';
  };

  return (
    <div className="person-card-minimized" onClick={onClick}>
      <div className="person-card-minimized-info">
        <div className="person-card-minimized-label">
          {getIcon()} {label} {generation > 0 && `(Gen. ${generation})`}
        </div>
        <div className="person-card-minimized-name">{person.name || '[Sem nome]'}</div>
        <div className="person-card-minimized-meta">
          {person.nickname && <span>Alcunha: {person.nickname}</span>}
          {person.professionId && <span>Profissão preenchida</span>}
        </div>
      </div>
      <div className={`person-card-minimized-sex ${person.sex.toLowerCase()}`}>
        {sexDisplay()}
      </div>
    </div>
  );
}

// Person Card Full (expanded view)
function PersonCard({ person, label, onChange, titles, professions, legitimacyStatuses, places, parishes, contextParishId, onAddPlace, onAddTitle, hideParentsButton = false, generation = 0, isSecondary = false, isParticipant = false, expandedPersonIds = new Set(), onToggleExpandedPerson = (id: string) => {}, lineagePath = "1" }: {
  person: PersonData;
  label: string;
  onChange: (p: PersonData) => void;
  titles: Title[];
  professions: Profession[];
  legitimacyStatuses: LegitimacyStatus[];
  places: Place[];
  parishes: Parish[];
  contextParishId: string;
  onAddPlace: (callback: (id: string) => void) => void;
  onAddTitle: (callback: (id: string) => void) => void;
  hideParentsButton?: boolean;
  generation?: number;
  isSecondary?: boolean;
  isParticipant?: boolean;
  expandedPersonIds?: Set<string>;
  onToggleExpandedPerson?: (id: string) => void;
  lineagePath?: string;
}) {
  const handleChange = (field: keyof PersonData, value: string) => {
    onChange({ ...person, [field]: value });
  };

  const addParents = () => {
    const newFather = createEmptyPerson('FATHER', `${person.id}_f`);
    const newMother = createEmptyPerson('MOTHER', `${person.id}_m`);
    // Auto-fill sex for parents
    newFather.sex = 'M';
    newMother.sex = 'F';
    onChange({ 
      ...person, 
      father: newFather,
      mother: newMother
    });
  };

  // Determinar classe de estilo baseado no tipo e geração
  let cardClass = 'person-card';
  if (isParticipant) {
    cardClass += ' participant';
  } else if (isSecondary) {
    cardClass += ' gen-secondary';
  } else if (generation === 0) {
    cardClass += ' gen-0';
  } else if (generation === 1) {
    cardClass += ' gen-1';
  } else if (generation === 2) {
    cardClass += ' gen-2';
  } else if (generation >= 3) {
    cardClass += ' gen-3';
  }

  // Ícones para diferentes relações
  const getIcon = () => {
    switch (label) {
      case 'Pai': return '👨';
      case 'Mãe': return '👩';
      case 'Avó Paterno': return '👴';
      case 'Avó Materna': return '👵';
      case 'Noivo': return '💍';
      case 'Noiva': return '💍';
      case 'Batizando': return '👶';
      case 'Defunto': return '✝️';
      default: return '';
    }
  };

  return (
    <div>
      {label && (
        <div className="person-card-header d-flex justify-content-between align-items-center">
          <span className="d-flex align-items-center gap-2">
            <span className="lineage-index" style={{ minWidth: '32px', fontWeight: 'bold', fontSize: '14px', color: '#3b82f6' }}>{lineagePath}</span>
            {getIcon() && <span className="person-card-header-icon">{getIcon()}</span>}
            <span>{label}</span>
            {generation > 0 && <span className="generation-label">Geração {generation}</span>}
          </span>
          {!person.father && !hideParentsButton && (
            <button className="btn btn-sm btn-outline-secondary" onClick={addParents}>
              + Pais
            </button>
          )}
        </div>
      )}
      
      <div className={cardClass}>
        <div className="row g-3">
          <div className="col-md-2">
            <label className="form-label">Título</label>
            <SearchableSelect
              options={titles.map(t => ({ id: t.id, name: t.name }))}
              value={person.titleId}
              onChange={(val) => handleChange('titleId', val)}
              placeholder="..."
              onAddNew={() => onAddTitle((id) => handleChange('titleId', id))}
            />
          </div>
          
          <div className="col-md-7">
            <label className="form-label">Nome Completo</label>
            <input 
              type="text" 
              className="form-control"
              placeholder="Nome completo..."
              value={person.name}
              onChange={(e) => handleChange('name', e.target.value)}
            />
          </div>
          
          <div className="col-md-3">
            <label className="form-label">Sexo</label>
            <div className="btn-group w-100" role="group">
              {(['M', 'F', 'D'] as const).map(s => (
                <button
                  key={s}
                  type="button"
                  className={`btn btn-sex ${person.sex === s ? `active btn-${s.toLowerCase()}` : ''}`}
                  onClick={() => handleChange('sex', s)}
                >
                  {s === 'D' ? '?' : s}
                </button>
              ))}
            </div>
          </div>
          
          <div className="col-md-6">
            <label className="form-label">Filiação</label>
            <SearchableSelect
              options={legitimacyStatuses.map(l => ({ id: l.id, name: l.name }))}
              value={person.legitimacyStatusId}
              onChange={(val) => handleChange('legitimacyStatusId', val)}
              placeholder="Selecionar..."
            />
          </div>
          
          <div className="col-md-6">
            <label className="form-label">Alcunha</label>
            <input 
              type="text" 
              className="form-control"
              placeholder="Alcunha ou apelido..."
              value={person.nickname}
              onChange={(e) => handleChange('nickname', e.target.value)}
            />
          </div>
          
          <div className="col-md-6">
            <label className="form-label">Profissão</label>
            <SearchableSelect
              options={professions.map(p => ({ id: p.id, name: p.name }))}
              value={person.professionId}
              onChange={(val) => handleChange('professionId', val)}
              placeholder="Selecionar..."
            />
          </div>
          
          <div className="col-md-6">
            <label className="form-label">Profissão (Original)</label>
            <input 
              type="text" 
              className="form-control"
              placeholder="Texto original..."
              value={person.professionOriginal}
              onChange={(e) => handleChange('professionOriginal', e.target.value)}
            />
          </div>
          
          <div className="col-md-4">
            <label className="form-label">NAT</label>
            <PlaceWithParishSelector
              parishes={parishes}
              places={places}
              contextParishId={contextParishId}
              value={person.origin}
              onChange={(val) => handleChange('origin', val)}
              placeholder="..."
              onAddNew={() => onAddPlace((id) => handleChange('origin', id))}
            />
          </div>
          
          <div className="col-md-4">
            <label className="form-label">RES</label>
            <PlaceWithParishSelector
              parishes={parishes}
              places={places}
              contextParishId={contextParishId}
              value={person.residence}
              onChange={(val) => handleChange('residence', val)}
              placeholder="..."
              onAddNew={() => onAddPlace((id) => handleChange('residence', id))}
            />
          </div>
          
          <div className="col-md-4">
            <label className="form-label">ÓBT</label>
            <PlaceWithParishSelector
              parishes={parishes}
              places={places}
              contextParishId={contextParishId}
              value={person.deathPlace}
              onChange={(val) => handleChange('deathPlace', val)}
              placeholder="..."
              onAddNew={() => onAddPlace((id) => handleChange('deathPlace', id))}
            />
          </div>
        </div>
      </div>
      
      {/* Parents */}
      {(person.father || person.mother) && (
        <div className="person-hierarchy">
          <div className="person-parent-group">
            {person.father && (
              <div className="person-lineage person-lineage-paternal">
                <div className="person-lineage-label">👨 Linha Paterna</div>
                <PersonCard
                  person={person.father}
                  label={`Pai ${person.name ? `de ${person.name}` : ''}`}
                  onChange={(p) => onChange({ ...person, father: p })}
                  titles={titles}
                  professions={professions}
                  legitimacyStatuses={legitimacyStatuses}
                  places={places}
                  parishes={parishes}
                  contextParishId={contextParishId}
                  onAddPlace={onAddPlace}
                  onAddTitle={onAddTitle}
                  generation={generation + 1}
                  expandedPersonIds={expandedPersonIds}
                  onToggleExpandedPerson={onToggleExpandedPerson}
                  lineagePath={lineagePath + ".1"}
                />
              </div>
            )}
            {person.mother && (
              <div className="person-lineage person-lineage-maternal">
                <div className="person-lineage-label">👩 Linha Materna</div>
                <PersonCard
                  person={person.mother}
                  label={`Mãe ${person.name ? `de ${person.name}` : ''}`}
                  onChange={(p) => onChange({ ...person, mother: p })}
                  titles={titles}
                  professions={professions}
                  legitimacyStatuses={legitimacyStatuses}
                  places={places}
                  parishes={parishes}
                  contextParishId={contextParishId}
                  onAddPlace={onAddPlace}
                  onAddTitle={onAddTitle}
                  generation={generation + 1}
                  expandedPersonIds={expandedPersonIds}
                  onToggleExpandedPerson={onToggleExpandedPerson}
                  lineagePath={lineagePath + ".2"}
                />
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

// Modal para adicionar lugar
function PlaceModal({ parishes, selectedParishId, onClose, onSave }: {
  parishes: Parish[];
  selectedParishId: string;
  onClose: () => void;
  onSave: (id: string) => void;
}) {
  const [parishId, setParishId] = useState(selectedParishId);
  const [name, setName] = useState('');
  const [isCreating, setIsCreating] = useState(false);

  const handleCreate = async () => {
    if (!name.trim() || !parishId) {
      alert('Preencha o nome e selecione a paróquia');
      return;
    }

    setIsCreating(true);
    try {
      const res = await fetch('/api/places', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: name.trim(), parishId })
      });
      
      if (!res.ok) throw new Error('Erro ao criar lugar');
      
      const data = await res.json();
      onSave(data.id);
    } catch (e) {
      alert('Erro ao criar lugar');
    } finally {
      setIsCreating(false);
    }
  };

  return (
    <div className="modal show d-block" style={{ backgroundColor: 'rgba(0,0,0,0.5)' }} onClick={onClose}>
      <div className="modal-dialog modal-dialog-centered" onClick={(e) => e.stopPropagation()}>
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">Adicionar Lugar</h5>
            <button type="button" className="btn-close" onClick={onClose}></button>
          </div>
          <div className="modal-body">
            <div className="mb-3">
              <label className="form-label">Paróquia</label>
              <SearchableSelect
                options={parishes.map(p => ({ id: p.id, name: `${p.name} - ${p.municipality} - ${p.district}` }))}
                value={parishId}
                onChange={(e) => setParishId(e)}
                placeholder="Selecionar paróquia..."
              />
            </div>
            <div className="mb-3">
              <label className="form-label">Nome do Lugar</label>
              <input 
                type="text"
                className="form-control"
                placeholder="Ex: Rua da Igreja"
                value={name}
                onChange={(e) => setName(e.target.value)}
                autoFocus
              />
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" onClick={onClose}>Cancelar</button>
            <button 
              type="button" 
              className="btn btn-primary" 
              onClick={handleCreate}
              disabled={isCreating || !name.trim() || !parishId}
            >
              {isCreating ? 'A criar...' : 'Criar Lugar'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

// Modal para adicionar título
function TitleModal({ onClose, onSave }: {
  onClose: () => void;
  onSave: (id: string) => void;
}) {
  const [name, setName] = useState('');
  const [isCreating, setIsCreating] = useState(false);

  const handleCreate = async () => {
    if (!name.trim()) {
      alert('Preencha o nome do título');
      return;
    }

    setIsCreating(true);
    try {
      const res = await fetch('/api/titles', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: name.trim() })
      });
      
      if (!res.ok) throw new Error('Erro ao criar título');
      
      const data = await res.json();
      onSave(data.id.toString());
    } catch (e) {
      alert('Erro ao criar título');
    } finally {
      setIsCreating(false);
    }
  };

  return (
    <div className="modal show d-block" style={{ backgroundColor: 'rgba(0,0,0,0.5)' }} onClick={onClose}>
      <div className="modal-dialog modal-dialog-centered" onClick={(e) => e.stopPropagation()}>
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">Adicionar Título</h5>
            <button type="button" className="btn-close" onClick={onClose}></button>
          </div>
          <div className="modal-body">
            <div className="mb-3">
              <label className="form-label">Nome do Título</label>
              <input 
                type="text"
                className="form-control"
                placeholder="Ex: Dr., Rev., Sra."
                value={name}
                onChange={(e) => setName(e.target.value)}
                autoFocus
              />
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" onClick={onClose}>Cancelar</button>
            <button 
              type="button" 
              className="btn btn-primary" 
              onClick={handleCreate}
              disabled={isCreating || !name.trim()}
            >
              {isCreating ? 'A criar...' : 'Criar Título'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
