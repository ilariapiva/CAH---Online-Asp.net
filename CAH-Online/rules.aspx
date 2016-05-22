<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <div class="card-panel teal-panel">
            <h1 class="h1-text">Le regole del gioco<br />
                <br />
            </h1>
            <p class="paragraph p1">
                Le regole del gioco sono:<br />
                <br />
                <ul>
                    <li class="color-number-list li-list">1.
                        <i class="paragraph p2">Il numero massimo di giocatori per “stanza” è di 5 persone e il mimino è di 4 persone.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">2.
                        <i class="paragraph p2">Il primo che entra nella "stanza" sarà il Master per il primo turno, successivamente nel secondo turno il Master sarà la seconda persona che è entrata nella "stanza" e così via. <br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">3.
                        <i class="paragraph p2">La Domanda (carta nera) sarà scelta in modo random e tutti i giocatori la vedranno. <br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">4.
                        <i class="paragraph p2">Ai giocatori che non sono Master si distribuiscono 10 carte Risposta (carta bianca). <br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">5.
                        <i class="paragraph p2">I giocatori scelgono, in un periodo limitato di tempo, la carta Risposta da dare al Master, cercando di scegliere la più divertente tra quelle che hanno. <br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">6.
                        <i class="paragraph p2">Il Master,  senza sapere lo username del giocatore che ha scelto una determinata carta (nel caso in cui ci siano più carte risposta perché la carta domanda ne richiedeva ad esempio 2, sotto le carte saranno ripetuti “User X” così il Master sa le coppie delle carte risposta), legge una ad una le risposte. <br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">7.
                        <i class="paragraph p2">Il Master, in un periodo limitato di tempo, sceglie la carta Risposta che più gli è piaciuta e la dichiara vincitrice e al vincitore viene assegnato un punto vittoria. <br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">8.
                        <i class="paragraph p2">Dopo aver deciso il vincitore, sotto le carte vengono visualizzati gli username dei giocatori che hanno giocato le carte. <br />
                            <br />
                        </i>
                    </li>
					<li class="color-number-list li-list">9.
                        <i class="paragraph p2">Alla fine del  turno a tutti i giocatori vengono assegnate delle nuove carte Risposta per tornare al numero iniziale di 10. <br />
                            <br />
                        </i>
                    </li>
					<li class="color-number-list li-list">10.
                        <i class="paragraph p2">Al giocatore che nel turno al primo turno era il Master gli vengono assegnate 10 carte, e le carte del  giocatore che al nuovo turno diventa Master  le rivedrà nel turno successivo.<br />
                            <br />
                        </i>
                    </li>
					<li class="color-number-list li-list">11.
                        <i class="paragraph p2">Vince il giocatore con più punti vittoria.<br />
                            <br />
                        </i>
                    </li>
                </ul>
                <p class="paragraph p1">
                    <br />
                    Esistono ovviamente molte variabili al gioco. Gli stessi creatori invogliano lo sviluppo di nuove forme di gioco e di assegnazione dei punti.<br />
                    Si può decidere di inserire un master fisso, o di premiare maggiormente il cinismo o il sadismo delle risposte. <br />
					Per questo motivo le regole in questo gioco cambino un po’ rispetto alle regole del gioco originale.
                </p>
        </div>
    </div>
</asp:Content>
