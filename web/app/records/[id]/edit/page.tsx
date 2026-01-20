'use client';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';

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

export default function EditRecordPage({ params }: { params: Promise<{ id: string }> }) {
  const router = useRouter();
  const [eventId, setEventId] = useState<string | null>(null);
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
  const [error, setError] = useState('');
  
  // Modal states
  const [showPlaceModal, setShowPlaceModal] = useState(false);
  const [showTitleModal, setShowTitleModal] = useState(false);
  const [modalCallback, setModalCallback] = useState<((id: string) => void) | null>(null);
  
  const [primarySubject, setPrimarySubject] = useState<PersonData>(createEmptyPerson('SUBJECT', 'primary'));
  const [secondarySubject, setSecondarySubject] = useState<PersonData>(createEmptyPerson('SUBJECT', 'secondary'));
  const [participants, setParticipants] = useState<PersonData[]>([]);
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

  // Load event data
  useEffect(() => {
    const loadEvent = async () => {
      try {
        const resolvedParams = await params;
        setEventId(resolvedParams.id);

        const res = await fetch(`/api/records/${resolvedParams.id}`);
        if (!res.ok) throw new Error('Evento não encontrado');
        const data = await res.json();

        setEventType(data.type);
        setEventData({
          type: data.type,
          year: data.year?.toString() || '',
          month: data.month?.toString() || '',
          day: data.day?.toString() || '',
          sourceUrl: data.sourceUrl || '',
          notes: data.notes || '',
          parishId: data.parishId?.toString() || ''
        });

        // Convert participations to PersonData format
        const subjectParticipations = data.participations.filter((p: any) => 
          ['SUBJECT', 'GROOM', 'BRIDE'].includes(p.role)
        );

        // Sort subjects to ensure GROOM is first, BRIDE is second (for marriage events)
        subjectParticipations.sort((a: any, b: any) => {
          const roleOrder: { [key: string]: number } = { GROOM: 0, BRIDE: 1, SUBJECT: 2 };
          return (roleOrder[a.role] ?? 3) - (roleOrder[b.role] ?? 3);
        });

        const ancestorRoles = ['FATHER', 'MOTHER', 'GRANDFATHER_PATERNAL', 'GRANDMOTHER_PATERNAL', 'GRANDFATHER_MATERNAL', 'GRANDMOTHER_MATERNAL'];

        if (subjectParticipations.length > 0) {
          const primary = subjectParticipations[0];
          
          // Build ascendants tree from Participations (using lineageIndex)
          const buildAncestorTreeFromParticipations = (lineagePath: string): { father?: PersonData, mother?: PersonData } => {
            const result: { father?: PersonData, mother?: PersonData } = {};
            
            // Look for father (lineagePath + '.1')
            const fatherLineage = lineagePath + '.1';
            const fatherParticipation = data.participations.find((p: any) => 
              p.lineageIndex === fatherLineage && ancestorRoles.includes(p.role)
            );
            if (fatherParticipation) {
              result.father = {
                id: fatherParticipation.individualId.toString(),
                role: 'FATHER',
                name: fatherParticipation.individual.name,
                sex: fatherParticipation.individual.sex,
                titleId: fatherParticipation.titleId?.toString() || '',
                nickname: fatherParticipation.nickname || '',
                professionId: fatherParticipation.professionId?.toString() || '',
                professionOriginal: fatherParticipation.professionOriginal || '',
                legitimacyStatusId: fatherParticipation.individual.legitimacyStatusId?.toString() || '',
                origin: fatherParticipation.originId?.toString() || '',
                residence: fatherParticipation.residenceId?.toString() || '',
                deathPlace: fatherParticipation.deathPlaceId?.toString() || '',
                ...buildAncestorTreeFromParticipations(fatherLineage)
              };
            }
            
            // Look for mother (lineagePath + '.2')
            const motherLineage = lineagePath + '.2';
            const motherParticipation = data.participations.find((p: any) => 
              p.lineageIndex === motherLineage && ancestorRoles.includes(p.role)
            );
            if (motherParticipation) {
              result.mother = {
                id: motherParticipation.individualId.toString(),
                role: 'MOTHER',
                name: motherParticipation.individual.name,
                sex: motherParticipation.individual.sex,
                titleId: motherParticipation.titleId?.toString() || '',
                nickname: motherParticipation.nickname || '',
                professionId: motherParticipation.professionId?.toString() || '',
                professionOriginal: motherParticipation.professionOriginal || '',
                legitimacyStatusId: motherParticipation.individual.legitimacyStatusId?.toString() || '',
                origin: motherParticipation.originId?.toString() || '',
                residence: motherParticipation.residenceId?.toString() || '',
                deathPlace: motherParticipation.deathPlaceId?.toString() || '',
                ...buildAncestorTreeFromParticipations(motherLineage)
              };
            }
            
            return result;
          };
          
          // Build ascendants tree - first try from Participations (using lineageIndex), fallback to familyOfOrigin
          const buildAncestorTree = (individual: any, lineagePath: string): { father?: PersonData, mother?: PersonData } => {
            // First try to get ancestors from Participations using lineageIndex
            const ancestorsFromParticipations = buildAncestorTreeFromParticipations(lineagePath);
            if (ancestorsFromParticipations.father || ancestorsFromParticipations.mother) {
              return ancestorsFromParticipations;
            }
            
            // Fallback to familyOfOrigin if no participation-based ancestors found
            const result: { father?: PersonData, mother?: PersonData } = {};
            
            if (individual.familyOfOrigin?.father) {
              const father = individual.familyOfOrigin.father;
              // Find the participation for this father to get full details
              const fatherParticipation = data.participations.find((p: any) => p.individualId === father.id);
              result.father = {
                id: father.id.toString(),
                role: 'FATHER',
                name: father.name,
                sex: father.sex,
                titleId: fatherParticipation?.titleId?.toString() || '',
                nickname: fatherParticipation?.nickname || '',
                professionId: fatherParticipation?.professionId?.toString() || '',
                professionOriginal: fatherParticipation?.professionOriginal || '',
                legitimacyStatusId: father.legitimacyStatusId?.toString() || '',
                origin: fatherParticipation?.originId?.toString() || '',
                residence: fatherParticipation?.residenceId?.toString() || '',
                deathPlace: fatherParticipation?.deathPlaceId?.toString() || '',
                ...buildAncestorTree(father, lineagePath + '.1')
              };
            }
            
            if (individual.familyOfOrigin?.mother) {
              const mother = individual.familyOfOrigin.mother;
              // Find the participation for this mother to get full details
              const motherParticipation = data.participations.find((p: any) => p.individualId === mother.id);
              result.mother = {
                id: mother.id.toString(),
                role: 'MOTHER',
                name: mother.name,
                sex: mother.sex,
                titleId: motherParticipation?.titleId?.toString() || '',
                nickname: motherParticipation?.nickname || '',
                professionId: motherParticipation?.professionId?.toString() || '',
                professionOriginal: motherParticipation?.professionOriginal || '',
                legitimacyStatusId: mother.legitimacyStatusId?.toString() || '',
                origin: motherParticipation?.originId?.toString() || '',
                residence: motherParticipation?.residenceId?.toString() || '',
                deathPlace: motherParticipation?.deathPlaceId?.toString() || '',
                ...buildAncestorTree(mother, lineagePath + '.2')
              };
            }
            
            return result;
          };

          setPrimarySubject({
            id: primary.individualId.toString(),
            role: primary.role,
            name: primary.individual.name,
            sex: primary.individual.sex,
            titleId: primary.titleId?.toString() || '',
            nickname: primary.nickname || '',
            professionId: primary.professionId?.toString() || '',
            professionOriginal: primary.professionOriginal || '',
            legitimacyStatusId: primary.individual.legitimacyStatusId?.toString() || '',
            origin: primary.originId?.toString() || '',
            residence: primary.residenceId?.toString() || '',
            deathPlace: primary.deathPlaceId?.toString() || '',
            kinshipId: primary.kinshipId?.toString() || '',
            participationRoleId: primary.participationRoleId?.toString() || '',
            ...buildAncestorTree(primary.individual, '1')
          });

          if (subjectParticipations.length > 1) {
            const secondary = subjectParticipations[1];
            setSecondarySubject({
              id: secondary.individualId.toString(),
              role: secondary.role,
              name: secondary.individual.name,
              sex: secondary.individual.sex,
              titleId: secondary.titleId?.toString() || '',
              nickname: secondary.nickname || '',
              professionId: secondary.professionId?.toString() || '',
              professionOriginal: secondary.professionOriginal || '',
              legitimacyStatusId: secondary.individual.legitimacyStatusId?.toString() || '',
              origin: secondary.originId?.toString() || '',
              residence: secondary.residenceId?.toString() || '',
              deathPlace: secondary.deathPlaceId?.toString() || '',
              kinshipId: secondary.kinshipId?.toString() || '',
              participationRoleId: secondary.participationRoleId?.toString() || '',
              ...buildAncestorTree(secondary.individual, '2')
            });
          }
        }

        // Load other participants - exclude genealogical ancestors
        const otherParticipants = data.participations.filter((p: any) => {
          // Exclude subjects
          if (['SUBJECT', 'GROOM', 'BRIDE'].includes(p.role)) return false;
          // Exclude genealogical ancestors
          if (ancestorRoles.includes(p.role)) return false;
          return true;
        });
        setParticipants(otherParticipants.map((p: any) => ({
          id: p.individualId.toString(),
          role: p.role,
          name: p.individual.name,
          sex: p.individual.sex,
          titleId: p.titleId?.toString() || '',
          nickname: p.nickname || '',
          professionId: p.professionId?.toString() || '',
          professionOriginal: p.professionOriginal || '',
          legitimacyStatusId: p.individual.legitimacyStatusId?.toString() || '',
          origin: p.originId?.toString() || '',
          residence: p.residenceId?.toString() || '',
          deathPlace: p.deathPlaceId?.toString() || '',
          kinshipId: p.kinshipId?.toString() || '',
          participationRoleId: p.participationRoleId?.toString() || '',
        })));

      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar evento');
      }
    };

    loadEvent();
  }, [params]);

  // Load metadata
  useEffect(() => {
    setIsLoadingMetadata(true);
    const fetchData = async () => {
        try {
            const [pRes, tRes, profRes, rRes, legRes, kinRes, placesRes] = await Promise.all([
                fetch('/api/parishes'),
                fetch('/api/titles'),
                fetch('/api/professions'),
                fetch('/api/participation-roles'),
                fetch('/api/legitimacy-statuses'),
                fetch('/api/kinships').catch(() => null),
                fetch('/api/places')
            ]);
            
            const pData = await pRes.json();
            if (Array.isArray(pData)) setParishes(pData);

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
      const participantToRemove = participants[index];
      
      // Check if this person is a parent of any other person in the genealogical tree
      const hasDescendants = (personId: string): boolean => {
          // Check primary subject and their ancestors
          const checkPerson = (person: PersonData | undefined): boolean => {
              if (!person) return false;
              if (person.father?.id === personId || person.mother?.id === personId) return true;
              if (checkPerson(person.father)) return true;
              if (checkPerson(person.mother)) return true;
              return false;
          };
          
          if (checkPerson(primarySubject)) return true;
          if (eventType === 'MARRIAGE' && checkPerson(secondarySubject)) return true;
          
          // Check other participants
          for (const p of participants) {
              if (p.id === personId) continue; // Skip self
              if (checkPerson(p)) return true;
          }
          
          return false;
      };
      
      if (hasDescendants(participantToRemove.id)) {
          alert(`Não é possível eliminar ${participantToRemove.name} porque existem ascendentes registados que dependem desta pessoa.`);
          return;
      }
      
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
      if (!eventId || !eventData.parishId) {
          setError('Por favor selecione a Paróquia.');
          return;
      }
      if (!primarySubject.name) {
          setError('O interveniente principal deve ter um nome.');
          return;
      }

      // Date validation
      if (eventData.year && eventData.month && eventData.day) {
          const year = parseInt(eventData.year);
          const month = parseInt(eventData.month);
          const day = parseInt(eventData.day);
          
          if (year < 0 || year > 2100) {
              setError('Ano deve estar entre 0 e 2100.');
              return;
          }
          if (month < 1 || month > 12) {
              setError('Mês deve estar entre 1 e 12.');
              return;
          }
          if (day < 1 || day > 31) {
              setError('Dia deve estar entre 1 e 31.');
              return;
          }
          
          const date = new Date(year, month - 1, day);
          if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) {
              setError(`A data ${day}/${month}/${year} não é válida.`);
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
      
      // Ensure year, month, day are either valid integers or null (not empty strings or "NaN")
      const cleanedEventData = {
          ...eventData,
          year: eventData.year && !isNaN(parseInt(eventData.year)) ? eventData.year : null,
          month: eventData.month && !isNaN(parseInt(eventData.month)) ? eventData.month : null,
          day: eventData.day && !isNaN(parseInt(eventData.day)) ? eventData.day : null
      };

      // Extract ancestors from primary and secondary subjects to send them as participants with ancestor roles
      // NOTE: The backend processes ancestors recursively through the subjects.primary and subjects.secondary tree structure.
      // Do NOT manually add ancestors to ancestorParticipants - the backend handles them via recursion in saveOrUpdatePerson.
      const ancestorParticipants: any[] = [];

      // Combine ancestors with other participants
      const allParticipants = [...ancestorParticipants, ...participants];

      const payload = {
          event: cleanedEventData,
          subjects: {
            primary: addLineageIndex(primarySubject, '1'),
            secondary: eventType === 'MARRIAGE' && secondarySubject ? addLineageIndex(secondarySubject, '2') : null
          },
          participants: allParticipants
      };

      try {
          const res = await fetch(`/api/records/${eventId}`, {
              method: 'PATCH',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(payload)
          });
          
          if (!res.ok) {
              const err = await res.json();
              throw new Error(err.error || 'Erro desconhecido');
          }
          
          router.push(`/records/${eventId}`);
      } catch (e) {
          setError(e instanceof Error ? e.message : 'Erro ao guardar');
      } finally {
          setIsSaving(false);
      }
  };

  const getPrimaryLabel = () => {
    let baseLabel = '';
    switch (eventType) {
      case 'BAPTISM': baseLabel = 'Batizando'; break;
      case 'DEATH': baseLabel = 'Defunto'; break;
      case 'MARRIAGE': baseLabel = 'Noivo'; break;
    }
    return primarySubject.id ? `[${primarySubject.id}] ${baseLabel}` : baseLabel;
  };

  if (isLoadingMetadata) {
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
        
        .person-card-header {
          font-size: 11px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #6b7280;
          margin-bottom: 0.75rem;
          padding-bottom: 0.5rem;
          border-bottom: 1px solid #f3f4f6;
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
      `}</style>

      <div className="container-fluid" style={{ maxWidth: '1200px' }}>
        {/* Header */}
        <div className="bg-white border-bottom mb-4 py-3">
          <div className="d-flex justify-content-between align-items-center">
            <div>
              <h1 className="h5 mb-1 fw-bold">Editar Registo</h1>
              <p className="text-muted mb-0" style={{ fontSize: '12px' }}>Modificar dados do registo paroquial</p>
            </div>
            <div className="d-flex gap-3 align-items-center">
              <button 
                className="btn btn-primary" 
                onClick={handleSave}
                disabled={isSaving}
              >
                {isSaving ? 'A guardar...' : 'Guardar Alterações'}
              </button>
              <Link href={`/records/${eventId}`} className="btn btn-secondary">
                Cancelar
              </Link>
            </div>
          </div>
        </div>

        {error && (
          <div className="alert alert-danger alert-dismissible fade show" role="alert">
            {error}
            <button type="button" className="btn-close" onClick={() => setError('')}></button>
          </div>
        )}

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
              
              <div className="col-md-3">
                <label className="form-label">Paróquia</label>
                <SearchableSelect
                  options={parishes.map(p => ({ id: p.id, name: `${p.name} - ${p.municipality} - ${p.district}` }))}
                  value={eventData.parishId}
                  onChange={(val) => handleEventChange('parishId', val)}
                  placeholder="Selecionar paróquia..."
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
            <span>Intervenientes Principais</span>
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
                  label={secondarySubject.id ? `[${secondarySubject.id}] Noiva` : 'Noiva'}
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
                        <div className="d-flex gap-2 flex-grow-1">
                          <select 
                            className="form-select form-select-sm"
                            value={person.participationRoleId || ''}
                            onChange={(e) => updateParticipant(idx, { ...person, participationRoleId: e.target.value })}
                          >
                            <option value="">Função...</option>
                            {participationRoles.map(r => (
                              <option key={r.id} value={r.id}>{r.name}</option>
                            ))}
                          </select>
                          <select 
                            className="form-select form-select-sm"
                            value={person.kinshipId || ''}
                            onChange={(e) => updateParticipant(idx, { ...person, kinshipId: e.target.value })}
                          >
                            <option value="">Parentesco...</option>
                            {kinships.map(k => (
                              <option key={k.id} value={k.id}>{k.name}</option>
                            ))}
                          </select>
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
                        label={person.id ? `[${person.id}]` : ''}
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
function PersonCard({ person, label, onChange, titles, professions, legitimacyStatuses, places, parishes, contextParishId, onAddPlace, onAddTitle, hideParentsButton = false, generation = 0, expandedPersonIds = new Set(), onToggleExpandedPerson = (id: string) => {}, lineagePath = "1" }: {
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

  return (
    <div>
      {label && (
        <div className="person-card-header d-flex justify-content-between align-items-center">
          <span className="d-flex align-items-center gap-2">
            <span style={{ minWidth: '32px', fontWeight: 'bold', fontSize: '14px', color: '#3b82f6' }}>{lineagePath}</span>
            <span>{label}</span>
          </span>
          {!person.father && !hideParentsButton && (
            <button className="btn btn-sm btn-outline-secondary" onClick={addParents}>
              + Pais
            </button>
          )}
        </div>
      )}
      
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
      
      {/* Parents */}
      {(person.father || person.mother) && (
        <div className="person-parent-group">
          {person.father ? (
            <div className="person-lineage person-lineage-paternal">
              <div className="person-lineage-label">👨 Linha Paterna</div>
              <PersonCard
                person={person.father}
                label={`${person.father.id ? `[${person.father.id}] ` : ''}Pai ${person.name ? `de ${person.name}` : ''}`}
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
          ) : person.mother ? (
            <div className="person-lineage person-lineage-paternal">
              <div className="person-lineage-label">👨 Linha Paterna</div>
              <PersonCard
                person={createEmptyPerson('FATHER', `${person.id}_f_empty`)}
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
          ) : null}
          {person.mother ? (
            <div className="person-lineage person-lineage-maternal">
              <div className="person-lineage-label">👩 Linha Materna</div>
              <PersonCard
                person={person.mother}
                label={`${person.mother.id ? `[${person.mother.id}] ` : ''}Mãe ${person.name ? `de ${person.name}` : ''}`}
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
          ) : person.father ? (
            <div className="person-lineage person-lineage-maternal">
              <div className="person-lineage-label">👩 Linha Materna</div>
              <PersonCard
                person={createEmptyPerson('MOTHER', `${person.id}_m_empty`)}
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
          ) : null}
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
