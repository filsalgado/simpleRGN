'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { Plus, User, FileText, Link as LinkIcon, Save, MapPin, Search, X, ChevronDown, Trash2, Users, ArrowRight } from 'lucide-react';

// --- Types ---

type EventType = 'BAPTISM' | 'MARRIAGE' | 'DEATH';

type PersonData = {
  id: string; // Internal temporary ID
  role: string; // The "system" role (e.g. FATHER, MOTHER, OTHER)
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

// --- Main Page Component ---

export default function NewRecordPage() {
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

  // Metadata State
  const [parishes, setParishes] = useState<Parish[]>([]);
  const [titles, setTitles] = useState<Title[]>([]);
  const [professions, setProfessions] = useState<Profession[]>([]);
  const [participationRoles, setParticipationRoles] = useState<ParticipationRole[]>([]);
  const [kinships, setKinships] = useState<Kinship[]>([]);
  const [legitimacyStatuses, setLegitimacyStatuses] = useState<LegitimacyStatus[]>([]);
  const [contextParishPlaces, setContextParishPlaces] = useState<Place[]>([]);
  const [isLoadingMetadata, setIsLoadingMetadata] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  
  // Subjects
  const [primarySubject, setPrimarySubject] = useState<PersonData>(createEmptyPerson('SUBJECT', 'primary'));
  const [secondarySubject, setSecondarySubject] = useState<PersonData>(createEmptyPerson('SUBJECT', 'secondary'));
  
  // Other Participants
  const [participants, setParticipants] = useState<PersonData[]>([]);

  const router = useRouter();

  // --- Effects ---

  useEffect(() => {
    setIsLoadingMetadata(true);
    const fetchData = async () => {
        try {
            const [pRes, tRes, profRes, rRes, ctxRes, legRes] = await Promise.all([
                fetch('/api/parishes'),
                fetch('/api/titles'),
                fetch('/api/professions'),
                fetch('/api/participation-roles'),
                fetch('/api/users/me/context/current'),
                fetch('/api/legitimacy-statuses')
            ]);
            
             // Kinship is not currently fetched but used in types. 
             // If the endpoint exists, fetch it. If not, use empty.
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

  // --- Handlers ---

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
    fetch('/api/titles').then(res => res.json()).then(data => setTitles(data));
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

      setIsSaving(true);
      
      const payload = {
          event: eventData,
          subjects: {
            primary: primarySubject,
            secondary: secondarySubject
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

  const getSecondaryLabel = () => 'Noiva';

  return (
    <div className="min-h-screen bg-slate-50 text-slate-800 pb-40">
      {/* Sticky Header */}
      <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-slate-200 shadow-sm px-6 py-4">
        <div className="max-w-[1920px] mx-auto flex justify-between items-center">
            <div className="flex items-center gap-6">
                <div>
                    <h1 className="text-xl font-bold text-slate-900 tracking-tight">Novo Registo</h1>
                    <p className="text-xs text-slate-500 font-medium tracking-wide uppercase">Adicionar à Base de Dados</p>
                </div>
                
                <div className="h-10 w-px bg-slate-200 mx-2"></div>
                
                <div className="flex flex-col">
                     <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-0.5">Paróquia Contexto</span>
                     <div className="flex items-center gap-2 bg-slate-100 rounded-md px-2 py-1 border border-slate-200">
                        <MapPin className="w-3 h-3 text-blue-500" />
                        <div className="w-64">
                            <SearchableSelect 
                                options={parishes.map(p => ({
                                    id: p.id,
                                    name: `${p.name} (${p.municipality})`
                                }))}
                                value={eventData.parishId}
                                onChange={(val) => handleEventChange('parishId', val)}
                                placeholder="Selecione a Paróquia..."
                                className="bg-transparent"
                                inputClassName="bg-transparent text-sm font-semibold text-slate-700 w-full focus:outline-none placeholder-slate-400"
                            />
                        </div>
                     </div>
                </div>
            </div>

            <button 
                onClick={handleSave} 
                disabled={isSaving}
                className="group relative flex items-center gap-3 bg-slate-900 text-white px-6 py-2.5 rounded-lg hover:bg-slate-800 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed shadow-lg shadow-slate-900/10"
            >
                {isSaving ? (
                    <div className="h-4 w-4 animate-spin rounded-full border-2 border-white/20 border-t-white" />
                ) : (
                    <Save size={18} className="text-slate-300 group-hover:text-white transition-colors" />
                )}
                <span className="font-semibold tracking-wide text-sm">{isSaving ? 'A GRAVAR...' : 'GRAVAR REGISTO'}</span>
            </button>
        </div>
      </header>

      <div className="max-w-[1920px] mx-auto p-8 space-y-8">
        
        {/* SECTION 1: EVENT DATA */}
        <section className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-slate-100 bg-slate-50/50 flex items-center gap-2">
                <div className="bg-blue-100 p-1.5 rounded-md text-blue-600">
                    <FileText size={16} />
                </div>
                <h2 className="font-semibold text-slate-700">Dados do Assento</h2>
            </div>
            
            <div className="p-6 grid gap-6 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-12">
                {/* Event Type */}
                <div className="col-span-1 md:col-span-2 xl:col-span-2 space-y-1.5">
                    <label className="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Tipo de Evento</label>
                    <div className="relative">
                        <select 
                            value={eventType}
                            onChange={(e) => {
                                setEventType(e.target.value as EventType);
                                setEventData(prev => ({ ...prev, type: e.target.value as EventType }));
                            }}
                            className="w-full appearance-none bg-white border border-slate-300 text-slate-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 shadow-sm font-medium"
                        >
                            <option value="BAPTISM">Batismo</option>
                            <option value="MARRIAGE">Casamento</option>
                            <option value="DEATH">Óbito</option>
                        </select>
                        <ChevronDown className="absolute right-3 top-3 h-4 w-4 text-slate-400 pointer-events-none" />
                    </div>
                </div>

                {/* Date */}
                <div className="col-span-full md:col-span-2 xl:col-span-3 space-y-1.5">
                    <label className="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Data (Ano / Mês / Dia)</label>
                    <div className="flex gap-2">
                        <input 
                            type="number" placeholder="Ano"
                            value={eventData.year} onChange={e => handleEventChange('year', e.target.value)}
                            className="w-full bg-white border border-slate-300 text-slate-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 shadow-sm placeholder-slate-400"
                        />
                        <input 
                            type="number" placeholder="Mês"
                            value={eventData.month} onChange={e => handleEventChange('month', e.target.value)}
                            className="w-full bg-white border border-slate-300 text-slate-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 shadow-sm placeholder-slate-400"
                        />
                        <input 
                            type="number" placeholder="Dia"
                            value={eventData.day} onChange={e => handleEventChange('day', e.target.value)}
                            className="w-full bg-white border border-slate-300 text-slate-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 shadow-sm placeholder-slate-400"
                        />
                    </div>
                </div>

                {/* Source */}
                <div className="col-span-full md:col-span-4 xl:col-span-4 space-y-1.5">
                    <label className="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Fonte Digital (Link)</label>
                    <div className="relative">
                        <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                            <LinkIcon className="w-4 h-4 text-slate-400" />
                        </div>
                        <input 
                            type="url" 
                            placeholder="https://arquivo..."
                            value={eventData.sourceUrl} onChange={e => handleEventChange('sourceUrl', e.target.value)}
                            className="bg-white border border-slate-300 text-slate-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 p-2.5 shadow-sm"
                        />
                    </div>
                </div>
                
                {/* Notes */}
                <div className="col-span-full xl:col-span-3 space-y-1.5">
                    <label className="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Observações</label>
                    <input 
                        type="text"
                        placeholder="Notas adicionais..."
                        value={eventData.notes} onChange={e => handleEventChange('notes', e.target.value)}
                        className="bg-white border border-slate-300 text-slate-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 shadow-sm"
                    />
                </div>
            </div>
        </section>

        {/* SECTION 2: GENEALOGY TREE */}
        {/* Horizontal scrolling tree with zoom control */}
        <section className="bg-white rounded-2xl shadow-sm border border-slate-200 flex flex-col">
            <div className="px-6 py-3 border-b border-slate-100 bg-gradient-to-r from-purple-50/50 to-blue-50/30 flex items-center justify-between">
                <div className="flex items-center gap-2">
                    <div className="bg-purple-100 p-1.5 rounded-lg text-purple-600">
                        <User size={15} />
                    </div>
                    <h2 className="font-semibold text-slate-700 text-sm">Árvore Genealógica</h2>
                </div>
                <div className="flex items-center gap-2">
                    <span className="text-[10px] text-slate-500 font-medium">Use scroll horizontal →</span>
                    <div className="flex gap-1 bg-white rounded-lg p-1 border border-slate-200">
                        <button 
                            onClick={() => {
                                const container = document.getElementById('tree-container');
                                if (container) container.style.zoom = '0.8';
                            }}
                            className="px-2 py-0.5 text-[10px] font-bold text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded transition-colors"
                        >
                            80%
                        </button>
                        <button 
                            onClick={() => {
                                const container = document.getElementById('tree-container');
                                if (container) container.style.zoom = '1';
                            }}
                            className="px-2 py-0.5 text-[10px] font-bold text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded transition-colors"
                        >
                            100%
                        </button>
                    </div>
                </div>
            </div>
            
            {/* Horizontal Scroll Container with zoom capability */}
            <div id="tree-container" className="w-full overflow-x-auto overflow-y-hidden p-6 bg-gradient-to-br from-slate-50/30 to-blue-50/20" style={{ zoom: '1' }}>
                 <div className="flex flex-col gap-10 min-w-max pb-2">
                    {/* Event Type specific headers/logic */}
                    
                    <div className="relative">
                         {eventType === 'MARRIAGE' && (
                             <div className="absolute -top-5 left-0 text-[10px] font-extrabold text-purple-400 uppercase tracking-wider pl-1 flex items-center gap-1">
                                <div className="w-1 h-1 rounded-full bg-purple-400"></div>
                                Lado do Noivo
                             </div>
                         )}
                         <PersonNode 
                            person={primarySubject} 
                            label={getPrimaryLabel()} 
                            onChange={(p) => updatePerson('primary', p)}
                            contextParishPlaces={contextParishPlaces}
                            parishes={parishes}
                            titles={titles}
                            professions={professions}
                            legitimacyStatuses={legitimacyStatuses}
                            onTitlesUpdate={reloadTitles}
                        />
                    </div>

                    {eventType === 'MARRIAGE' && (
                         <div className="relative pt-6 border-t border-slate-200">
                             <div className="absolute top-1 left-0 text-[10px] font-extrabold text-pink-400 uppercase tracking-wider pl-1 flex items-center gap-1">
                                <div className="w-1 h-1 rounded-full bg-pink-400"></div>
                                Lado da Noiva
                             </div>
                             <PersonNode 
                                person={secondarySubject} 
                                label={getSecondaryLabel()} 
                                onChange={(p) => updatePerson('secondary', p)}
                                contextParishPlaces={contextParishPlaces}
                                parishes={parishes}
                                titles={titles}
                                professions={professions}
                                legitimacyStatuses={legitimacyStatuses}
                                onTitlesUpdate={reloadTitles}
                            />
                        </div>
                    )}
                 </div>
            </div>
        </section>

        {/* SECTION 3: OTHER PARTICIPANTS */}
        {/* Grid layout unrelated to tree width */}
        <section className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
             <div className="px-6 py-4 border-b border-slate-100 bg-slate-50/50 flex items-center justify-between">
                <div className="flex items-center gap-2">
                    <div className="bg-green-100 p-1.5 rounded-md text-green-600">
                        <Users size={16} />
                    </div>
                    <h2 className="font-semibold text-slate-700">Outros Intervenientes</h2>
                </div>
                <button 
                    onClick={addParticipant}
                    className="flex items-center gap-2 text-xs font-bold text-green-700 bg-green-50 px-3 py-1.5 rounded-md hover:bg-green-100 border border-green-200 transition-colors uppercase tracking-wide"
                >
                    <Plus size={14} /> Adicionar
                </button>
            </div>
            
            <div className="p-6">
                <div className="grid gap-6 grid-cols-1 md:grid-cols-2 xl:grid-cols-3">
                    {participants.map((person, idx) => (
                        <div key={person.id} className="relative group bg-slate-50 rounded-xl border border-slate-200 hover:border-blue-300 hover:shadow-md transition-all duration-200">
                             {/* Floating Header Actions */}
                             <div className="absolute top-0 inset-x-0 h-12 border-b border-slate-100 bg-white/50 backdrop-blur rounded-t-xl px-3 flex gap-2 items-center z-10">
                                <div className="flex-1 min-w-0">
                                    <SearchableSelect 
                                        options={participationRoles}
                                        value={person.participationRoleId || ''}
                                        onChange={(id) => updateParticipant(idx, { ...person, participationRoleId: id })}
                                        placeholder="FUNÇÃO (PRIOR, ETC)..."
                                        className="w-full"
                                        inputClassName="w-full bg-transparent text-xs font-bold text-slate-700 placeholder-slate-400 border-none focus:ring-0 px-0 uppercase tracking-tight"
                                    />
                                </div>
                                <div className="w-px h-4 bg-slate-200"></div>
                                <div className="flex-1 min-w-0">
                                     <SearchableSelect 
                                        options={kinships}
                                        value={person.kinshipId || ''}
                                        onChange={(id) => updateParticipant(idx, { ...person, kinshipId: id })}
                                        placeholder="PARENTESCO..."
                                        className="w-full"
                                        inputClassName="w-full bg-transparent text-xs font-medium text-slate-500 placeholder-slate-400 border-none focus:ring-0 px-0 text-right"
                                     />
                                </div>
                                <button onClick={() => removeParticipant(idx)} className="ml-1 p-1.5 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-md transition-colors">
                                    <Trash2 size={14} />
                                </button>
                             </div>

                             <div className="p-4 pt-14">
                                <PersonNode 
                                    person={person} 
                                    label="" 
                                    hideHeader={true}
                                    isCompact={true}
                                    onChange={(p) => updateParticipant(idx, p)}
                                    contextParishPlaces={contextParishPlaces}
                                    parishes={parishes}
                                    titles={titles}
                                    professions={professions}
                                    legitimacyStatuses={legitimacyStatuses}
                                    onTitlesUpdate={reloadTitles}
                                />
                             </div>
                        </div>
                    ))}

                    {participants.length === 0 && (
                        <div className="col-span-full py-12 flex flex-col items-center justify-center text-slate-400 border-2 border-dashed border-slate-200 bg-slate-50/50 rounded-xl">
                            <Users strokeWidth={1} className="w-12 h-12 mb-3 opacity-20" />
                            <p className="text-sm font-medium">Nenhum interveniente extra.</p>
                            <p className="text-xs text-slate-400">Adicione padres, testemunhas ou padrinhos.</p>
                             <button onClick={addParticipant} className="mt-4 text-blue-600 hover:text-blue-700 text-sm font-bold flex items-center gap-1">
                                <Plus size={14} /> Adicionar
                             </button>
                        </div>
                    )}
                </div>
            </div>
        </section>

      </div>
    </div>
  );
}

// --- Component: Searchable Select (Refined) ---

function SearchableSelect({ 
    options, value, onChange, placeholder = "Selecione...", onAddNew, className = "", inputClassName = "", isLoading = false
}: { 
    options: { id: string | number, name: string }[], value: string | number, onChange: (val: string) => void,
    placeholder?: string, onAddNew?: () => void, className?: string, inputClassName?: string, isLoading?: boolean
}) {
    const [isOpen, setIsOpen] = useState(false);
    const [search, setSearch] = useState('');
    
    // Derived state
    const safeOptions = Array.isArray(options) ? options : [];
    const selectedObj = safeOptions.find(o => o.id.toString() === value.toString());
    const displayValue = isOpen ? search : (selectedObj ? selectedObj.name : '');
    const filteredOptions = safeOptions.filter(o => o.name && o.name.toLowerCase().includes(search.toLowerCase()));

    return (
        <div className={`relative ${className}`}>
            <input 
                className={inputClassName || "w-full bg-white border border-slate-300 rounded-md px-3 py-1.5 text-sm text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all shadow-sm"}
                placeholder={isLoading ? "..." : placeholder}
                value={displayValue}
                onChange={(e) => { setSearch(e.target.value); setIsOpen(true); }}
                onFocus={() => { setIsOpen(true); setSearch(''); }}
                onBlur={() => setTimeout(() => setIsOpen(false), 200)}
                disabled={isLoading}
            />
            {isOpen && (
                <div className="absolute z-50 mt-1 w-full min-w-[200px] rounded-lg border border-slate-200 bg-white shadow-xl max-h-60 overflow-auto text-sm py-1 animate-in fade-in zoom-in-95 duration-100">
                    {filteredOptions.length > 0 ? (
                        filteredOptions.map(opt => (
                            <div key={opt.id} className="px-3 py-2 hover:bg-blue-50 cursor-pointer text-slate-700 truncate"
                                onMouseDown={() => { onChange(opt.id.toString()); setIsOpen(false); setSearch(''); }}>
                                {opt.name}
                            </div>
                        ))
                    ) : ( <div className="px-3 py-2 text-slate-400 italic text-xs">Sem resultados</div> )}
                     {onAddNew && (
                        <div className="border-t border-slate-100 px-3 py-2 text-blue-600 font-bold text-xs cursor-pointer hover:bg-slate-50 uppercase tracking-wide"
                            onMouseDown={() => { onAddNew(); setIsOpen(false); }}>
                            + Criar Novo
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}

// --- Component: Person Node (The Card) ---

function PersonNode({ 
    person, label, onChange, contextParishPlaces, parishes, titles, professions, legitimacyStatuses, onTitlesUpdate,
    hideHeader = false, isCompact = false
}: { 
    person: PersonData, label: string, onChange: (p: PersonData) => void,
    contextParishPlaces: Place[], parishes: Parish[], titles: Title[], professions: Profession[], legitimacyStatuses: LegitimacyStatus[],
    onTitlesUpdate: () => void, hideHeader?: boolean, isCompact?: boolean
}) {
  const handleFieldChange = (field: keyof PersonData, val: string) => onChange({ ...person, [field]: val });
  
  const addParents = () => {
    onChange({ ...person, father: createEmptyPerson('FATHER', `${person.id}_f`), mother: createEmptyPerson('MOTHER', `${person.id}_m`) });
  };

  // Styles
  const cardBase = isCompact 
    ? "relative flex-shrink-0 flex flex-col gap-2 rounded-lg border bg-white p-2 shadow-sm w-full transition-all hover:shadow-md"
    : "relative flex-shrink-0 flex flex-col gap-2.5 rounded-xl border bg-white p-3 shadow-sm w-[280px] transition-all hover:shadow-md hover:border-blue-300";
  const cardBorder = !hideHeader ? 'border-slate-200' : 'border-transparent bg-transparent shadow-none p-0 w-full';

  return (
    <div className="flex items-start gap-8 animate-in fade-in zoom-in duration-300">
      
      {/* The Main Card */}
      <div className={`${cardBase} ${cardBorder}`}>
        {!hideHeader && (
            <div className="flex justify-between items-center pb-1.5 border-b border-slate-100">
                <span className="text-[10px] font-extrabold uppercase tracking-wider text-blue-600 bg-blue-50/70 px-1.5 py-0.5 rounded">{label}</span>
                {!person.father && (
                    <button onClick={addParents} className="text-[10px] font-bold text-slate-400 hover:text-blue-600 flex items-center gap-0.5 px-1.5 py-0.5 rounded hover:bg-blue-50 transition-colors">
                         <Plus size={11} strokeWidth={2.5} /> Pais
                    </button>
                )}
            </div>
        )}
        
        <div className={isCompact ? "space-y-1.5" : "space-y-2"}>
           {/* Top Row: Title + Name */}
           <div className="flex gap-1.5">
                 <div className="w-[60px] flex-shrink-0">
                    <TitleSelector value={person.titleId} onChange={(val) => handleFieldChange('titleId', val)} titles={titles} onAdd={onTitlesUpdate} />
                 </div>
                 <div className="flex-grow min-w-0">
                    <input 
                        type="text" placeholder="Nome Completo" 
                        value={person.name} onChange={e => handleFieldChange('name', e.target.value)}
                        className="w-full bg-white border border-slate-200 rounded-md px-2 py-1.5 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-1 focus:ring-blue-400/50 focus:border-blue-400 placeholder-slate-400 transition-all" 
                    />
                 </div>
           </div>

           {/* Row: Sex + Legitimacy */}
            <div className="flex gap-1.5">
                <div className="flex bg-slate-50 rounded-md p-0.5 items-center justify-between border border-slate-200 w-20">
                    {(['M','F','D'] as const).map(s => (
                        <button key={s} onClick={() => handleFieldChange('sex', s)}
                            className={`flex-1 h-5 text-[9px] font-bold rounded flex items-center justify-center transition-all ${
                                person.sex === s 
                                ? (s === 'M' ? 'bg-blue-500 text-white shadow-sm' : s === 'F' ? 'bg-pink-500 text-white shadow-sm' : 'bg-slate-500 text-white shadow-sm')
                                : 'text-slate-400 hover:text-slate-600 hover:bg-white'
                            }`}>{s === 'D' ? '?' : s}</button>
                    ))}
                </div>
                <div className="flex-1 min-w-0">
                     <SearchableSelect options={legitimacyStatuses} value={person.legitimacyStatusId || ''} onChange={(val) => handleFieldChange('legitimacyStatusId', val)} placeholder="Filiação..." inputClassName="w-full bg-white border border-slate-200 rounded-md px-2 py-1 text-[11px] text-slate-700 outline-none focus:border-blue-400 focus:ring-1 focus:ring-blue-400/30" />
                </div>
            </div>

            {/* Nickname */}
            {!isCompact && (
                <div>
                    <input 
                        type="text" placeholder="Alcunha" 
                        value={person.nickname} onChange={e => handleFieldChange('nickname', e.target.value)}
                        className="w-full bg-slate-50 border border-slate-200 rounded-md px-2 py-1 text-[11px] text-slate-600 focus:outline-none focus:border-blue-400 focus:bg-white placeholder-slate-400 transition-all" 
                    />
                </div>
            )}

            {/* Profession Block */}
            <div className="bg-gradient-to-br from-slate-50 to-slate-50/50 rounded-lg p-1.5 border border-slate-200/80 grid grid-cols-2 gap-1.5">
                <div>
                     <label className="text-[8px] uppercase font-bold text-slate-400 block mb-0.5 tracking-wide">Profissão</label>
                     <SearchableSelect options={professions} value={person.professionId} onChange={(val) => handleFieldChange('professionId', val)} placeholder="..." 
                        inputClassName="w-full bg-white border border-slate-200 rounded px-1.5 py-1 text-[10px] outline-none focus:border-blue-400"
                     />
                </div>
                <div>
                     <label className="text-[8px] uppercase font-bold text-slate-400 block mb-0.5 tracking-wide">Original</label>
                     <input type="text" value={person.professionOriginal} onChange={e => handleFieldChange('professionOriginal', e.target.value)}
                        className="w-full bg-white border border-slate-200 rounded px-1.5 py-1 text-[10px] outline-none focus:border-blue-400 text-slate-700"
                        placeholder="..."
                     />
                </div>
            </div>

            {!isCompact && (
                <div className="space-y-1 pt-0.5">
                    {[{ label: 'NAT', field: 'origin' }, { label: 'RES', field: 'residence' }, { label: 'ÓBT', field: 'deathPlace' }].map((item) => (
                        <div key={item.field} className="flex items-center gap-1.5">
                            <span className="w-8 text-[8px] font-extrabold text-slate-400 text-right tracking-tight">{item.label}</span>
                            <div className="flex-1 min-w-0">
                                <PlaceSelector 
                                    value={person[item.field as keyof PersonData] as string} 
                                    onChange={(val) => handleFieldChange(item.field as keyof PersonData, val)}
                                    contextPlaces={contextParishPlaces} parishes={parishes}
                                />
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
      </div>

      {/* Recursive Children (Parents) */}
      {(person.father || person.mother) && (
        <div className="flex flex-col gap-4 relative">
             {/* The connector line from child to parents group */}
             <div className="absolute top-1/2 -left-6 w-6 border-t border-slate-300"></div>
             
             {/* Vertical Bar connecting the two parents */}
             <div className="absolute top-[20%] bottom-[20%] -left-6 border-l border-slate-300"></div>

             {person.father && (
                 <div className="relative">
                     {/* Horizontal connector to Father */}
                    <div className="absolute top-1/2 -left-6 w-6 border-t border-slate-300"></div>
                    <PersonNode 
                        person={person.father} label="Pai" onChange={(p) => onChange({ ...person, father: p })} 
                        contextParishPlaces={contextParishPlaces} parishes={parishes} titles={titles} professions={professions} legitimacyStatuses={legitimacyStatuses} onTitlesUpdate={onTitlesUpdate}
                    />
                 </div>
             )}
             
             {person.mother && (
                 <div className="relative">
                     {/* Horizontal connector to Mother */}
                    <div className="absolute top-1/2 -left-6 w-6 border-t border-slate-300"></div>
                    <PersonNode 
                        person={person.mother} label="Mãe" onChange={(p) => onChange({ ...person, mother: p })}
                        contextParishPlaces={contextParishPlaces} parishes={parishes} titles={titles} professions={professions} legitimacyStatuses={legitimacyStatuses} onTitlesUpdate={onTitlesUpdate}
                    />
                 </div>
             )}
        </div>
      )}
    </div>
  );
}

// --- Helpers: Place & Title Selectors ---

function PlaceSelector({ value, onChange, contextPlaces, parishes, placeholder = "..." }: { value: string, onChange: (val: string) => void, contextPlaces: Place[], parishes: Parish[], placeholder?: string }) {
    const [isModalOpen, setIsModalOpen] = useState(false);
    return (
        <>
            <select value={value} onChange={e => e.target.value === 'SEARCH_OTHER' ? setIsModalOpen(true) : onChange(e.target.value)}
                className="w-full bg-white border border-slate-200 rounded px-1.5 py-0.5 text-[10px] text-slate-600 focus:border-blue-400 focus:ring-1 focus:ring-blue-400/30 outline-none truncate h-6">
                <option value="">{placeholder}</option>
                <optgroup label="Paróquia Atual">
                    {contextPlaces.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                </optgroup>
                <option value="SEARCH_OTHER" className="text-blue-600 font-bold">+ Outro...</option>
            </select>
            <PlaceSearchModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} onSelect={(p) => { onChange(p.id); }} parishes={parishes} initialParishId={contextPlaces[0]?.parishId} />
        </>
    );
}

function TitleSelector({ value, onChange, titles, onAdd }: { value: string, onChange: (val: string) => void, titles: Title[], onAdd: () => void }) {
    const [isModalOpen, setIsModalOpen] = useState(false);
    const t = titles.find(x => x.id.toString() === value);
    return (
        <>
            <div onClick={() => setIsModalOpen(true)} className="w-full h-[30px] bg-slate-50 border border-slate-200 rounded px-1.5 flex items-center cursor-pointer hover:bg-white hover:border-blue-400 transition-all">
                <span className={`text-[10px] font-bold truncate ${t ? 'text-blue-600' : 'text-slate-400'}`}>{t ? t.name : 'Tít'}</span>
            </div>
            <TitleSearchModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} onSelect={(newT) => { onAdd(); onChange(newT.id.toString()); }} titles={titles} />
        </>
    )
}

// --- Modals (Simplified for brevity but styled) ---

function PlaceSearchModal({ isOpen, onClose, onSelect, parishes, initialParishId }: { isOpen: boolean, onClose: () => void, onSelect: (place: Place) => void, parishes: Parish[], initialParishId?: string }) {
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedParishId, setSelectedParishId] = useState(initialParishId || '');
    const [results, setResults] = useState<Place[]>([]);
    const [isCreating, setIsCreating] = useState(false);

    useEffect(() => {
        const timer = setTimeout(() => {
            if (searchQuery.length >= 2) {
                const params = new URLSearchParams({ query: searchQuery });
                if (selectedParishId) params.append('parishId', selectedParishId);
                fetch(`/api/places?${params}`).then(r => r.json()).then(d => setResults(Array.isArray(d) ? d : []));
            } else setResults([]);
        }, 300);
        return () => clearTimeout(timer);
    }, [searchQuery, selectedParishId]);

    const handleCreate = async () => {
        setIsCreating(true);
        try {
            const res = await fetch('/api/places', { method: 'POST', body: JSON.stringify({ name: searchQuery, parishId: selectedParishId }) });
            const data = await res.json();
            if (data.id) { onSelect(data); onClose(); }
        } catch(e) { alert('Erro'); } finally { setIsCreating(false); }
    };

    if (!isOpen) return null;
    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 animate-in fade-in duration-200">
            <div className="w-full max-w-lg rounded-2xl bg-white shadow-2xl overflow-hidden border border-slate-200">
                <div className="bg-slate-50 border-b border-slate-200 p-4 flex justify-between items-center">
                    <h3 className="font-bold text-slate-700">Lugar</h3>
                    <button onClick={onClose}><X size={20} className="text-slate-400 hover:text-red-500" /></button>
                </div>
                <div className="p-4 space-y-4">
                    <select className="w-full p-2 border border-slate-300 rounded text-sm bg-white" value={selectedParishId} onChange={e => setSelectedParishId(e.target.value)}>
                        <option value="">Todas as Paróquias</option>
                        {parishes.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                    </select>
                    <input autoFocus className="w-full p-2 border border-slate-300 rounded text-sm bg-white font-medium" placeholder="Pesquisar..." value={searchQuery} onChange={e => setSearchQuery(e.target.value)} />
                
                    <div className="max-h-60 overflow-y-auto pt-2">
                        {results.length > 0 ? (
                            results.map(p => (
                                <div key={p.id} onClick={() => { onSelect(p); onClose(); }} className="p-2 hover:bg-blue-50 cursor-pointer rounded text-sm text-slate-700 flex justify-between">
                                    <span className="font-semibold">{p.name}</span>
                                    <span className="text-xs text-slate-400">{p.parish?.name}</span>
                                </div>
                            ))
                        ) : searchQuery.length > 2 && selectedParishId ? (
                            <button onClick={handleCreate} disabled={isCreating} className="w-full py-2 bg-blue-600 text-white rounded font-bold text-sm shadow hover:bg-blue-700">Criar "{searchQuery}"</button>
                        ) : null}
                    </div>
                </div>
            </div>
        </div>
    );
}

function TitleSearchModal({ isOpen, onClose, onSelect, titles = [] }: { isOpen: boolean, onClose: () => void, onSelect: (t: Title) => void, titles: Title[] }) {
    const [name, setName] = useState('');
    const [filter, setFilter] = useState('');
    const [isCreating, setIsCreating] = useState(false);

    // Derived filtered list
    const filteredTitles = titles.filter(t => t.name.toLowerCase().includes(filter.toLowerCase()));

    const handleCreate = async () => {
        setIsCreating(true);
        try {
            const res = await fetch('/api/titles', { method: 'POST', body: JSON.stringify({ name }) });
            const data = await res.json();
            if (data.id) { onSelect(data); onClose(); }
        } catch(e) { alert('Erro'); } finally { setIsCreating(false); }
    };

    if (!isOpen) return null;
    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 animate-in fade-in duration-200">
             <div className="w-full max-w-sm rounded-2xl bg-white shadow-2xl overflow-hidden border border-slate-200 p-6 space-y-4">
                 <div className="flex justify-between items-center">
                    <h3 className="font-bold text-slate-700">Adicionar Título</h3>
                    <button onClick={onClose}><X size={20} className="text-slate-400 hover:text-red-500" /></button>
                 </div>
                 
                 {/* Search/Filter Input */}
                 <div className="relative">
                    <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
                    <input 
                        className="w-full pl-9 pr-3 py-2 border border-slate-300 rounded text-sm bg-white focus:ring-2 focus:ring-blue-500/20 outline-none" 
                        placeholder="Filtrar existentes ou novo..." 
                        value={name} 
                        onChange={(e) => {
                            setName(e.target.value);
                            setFilter(e.target.value);
                        }} 
                        autoFocus
                    />
                 </div>

                 {/* Results List */}
                 <div className="max-h-40 overflow-y-auto border border-slate-100 rounded-lg p-1 bg-slate-50/50">
                    {filteredTitles.length > 0 ? (
                        filteredTitles.map(title => (
                            <button
                                key={title.id}
                                onClick={() => { onSelect(title); onClose(); }}
                                className="w-full text-left px-3 py-2 text-xs font-medium text-slate-700 hover:bg-blue-100 hover:text-blue-700 rounded transition-colors"
                            >
                                {title.name}
                            </button>
                        ))
                    ) : (
                        <p className="text-center text-xs text-slate-400 py-4 italic">Nenhum título encontrado.</p>
                    )}
                 </div>

                 {/* Actions */}
                 {name && !filteredTitles.some(t => t.name.toLowerCase() === name.toLowerCase()) && (
                     <button 
                        onClick={handleCreate} 
                        disabled={isCreating} 
                        className="w-full py-2 bg-slate-900 text-white rounded font-bold text-sm shadow hover:bg-slate-800 flex justify-center items-center gap-2"
                    >
                        {isCreating ? '...' : <> <Plus size={14}/> Criar Novo "{name}" </>}
                    </button>
                 )}
             </div>
        </div>
    )
}
