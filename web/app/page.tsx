'use client';

export default function Home() {
  return (
    <>
      <style>{`
        .hover-shadow-card {
          transition: all 0.3s ease;
        }
        .hover-shadow-card:hover {
          transform: translateY(-4px);
          box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
        }
      `}</style>
      
      <main className="container py-5">
        <div className="text-center mb-5">
          <h1 className="display-4 fw-bold text-primary mb-3">SimpleRGN</h1>
          <p className="lead text-muted">Sistema de Gestão de Registos Paroquiais e Genealogia</p>
        </div>

        <div className="row g-4 justify-content-center">
          <div className="col-md-6 col-lg-4">
            <a href="/records/new" className="text-decoration-none">
              <div className="card h-100 border-primary shadow-sm hover-shadow-card">
                <div className="card-body text-center p-4">
                  <div className="mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" className="bi bi-plus-circle text-primary" viewBox="0 0 16 16">
                      <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                      <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                    </svg>
                  </div>
                  <h2 className="h5 fw-bold text-dark mb-2">Novo Registo</h2>
                  <p className="text-muted small mb-0">Adicionar Batismo, Casamento ou Óbito</p>
                </div>
              </div>
            </a>
          </div>

          <div className="col-md-6 col-lg-4">
            <a href="/records" className="text-decoration-none">
              <div className="card h-100 border-secondary shadow-sm hover-shadow-card">
                <div className="card-body text-center p-4">
                  <div className="mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" className="bi bi-list-ul text-secondary" viewBox="0 0 16 16">
                      <path fillRule="evenodd" d="M5 11.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm-3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm0 4a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm0 4a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
                    </svg>
                  </div>
                  <h2 className="h5 fw-bold text-dark mb-2">Listar Registos</h2>
                  <p className="text-muted small mb-0">Consultar registos existentes</p>
                </div>
              </div>
            </a>
          </div>
        </div>
      </main>
    </>
  )
}
