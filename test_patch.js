const http = require('http');

// Função para fazer PATCH request
function patchEvent(eventId, year) {
    const payload = {
        event: {
            type: "BAPTISM",
            year: year.toString(),
            month: "2",
            day: "3",
            sourceUrl: "",
            notes: "Teste de PATCH",
            parishId: "1"
        },
        subjects: {
            primary: {
                id: "1",
                role: "SUBJECT",
                name: "João Batista",
                nickname: "",
                professionId: "",
                professionOriginal: "",
                origin: "",
                residence: "",
                deathPlace: "",
                titleId: "",
                sex: "M",
                legitimacyStatusId: ""
            }
        },
        participants: []
    };

    const options = {
        hostname: 'localhost',
        port: 3000,
        path: `/api/records/${eventId}`,
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(JSON.stringify(payload))
        }
    };

    return new Promise((resolve, reject) => {
        const req = http.request(options, (res) => {
            let data = '';
            
            res.on('data', (chunk) => {
                data += chunk;
            });
            
            res.on('end', () => {
                resolve({
                    statusCode: res.statusCode,
                    body: data
                });
            });
        });

        req.on('error', (e) => {
            reject(e);
        });

        req.write(JSON.stringify(payload));
        req.end();
    });
}

async function test() {
    console.log('Testando PATCH /api/records/2 com year=1530...');
    try {
        const result = await patchEvent(2, 1530);
        console.log(`Status: ${result.statusCode}`);
        console.log(`Response: ${result.body}`);
    } catch (e) {
        console.error('Erro:', e.message);
    }
}

test();
