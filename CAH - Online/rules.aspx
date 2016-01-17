﻿<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <div class="card-panel teal-panel">
            <h1 class="h1-text">Le regole del gioco<br />
                <br />
            </h1>
            <p class="paragraph p1">
                Le regole basilari del gioco sono:<br />
                <br />
                <ul>
                    <li class="color-number-list li-list">1.
                        <i class="paragraph p2">Si distribuiscono 10 carte Risposta a ciascun giocatore.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">2.
                        <i class="paragraph p2">Si sceglie chi leggerà la domanda al primo turno (master). Il master sceglie una carta Domanda (carta nera) e la legge ad alta voce.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">3.
                        <i class="paragraph p2">I giocatori scelgono in un periodo limitato di tempo la carta Risposta (carta bianca) da dare al master, cercando di scegliere la più divertente tra quelle che hanno.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">4.
                        <i class="paragraph p2">Il master mischia le carte senza vederle e legge una ad una le risposte ad alta voce.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">5.
                        <i class="paragraph p2">Il master sceglie la carta Risposta che più gli è piaciuta e la dichiara. In quel momento il giocatore che ha giocato la carta si rivela e guadagna un punto vittoria.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">6.
                        <i class="paragraph p2">Tutti i giocatori pescano le carte Risposta per tornare al numero iniziale di 10.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">7.
                        <i class="paragraph p2">Il giocatore che ha ottenuto il punto vittoria sarà il master per il turno successivo.<br />
                            <br />
                        </i>
                    </li>
                    <li class="color-number-list li-list">8.
                        <i class="paragraph p2">Vince il giocatore con più punti vittoria.<br />
                            <br />
                        </i>
                    </li>
                </ul>
                <p class="paragraph p1">
                    <br />
                    Esistono ovviamente molte variabili al gioco. Gli stessi creatori invogliano lo sviluppo di nuove forme di gioco e di assegnazione dei punti.<br />
                    Si può decidere di inserire un master fisso, o di premiare maggiormente il cinismo o il sadismo delle risposte. 
                </p>
        </div>
    </div>
</asp:Content>
