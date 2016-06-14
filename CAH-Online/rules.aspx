<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (FunctionsDB.ExistCookies())
        {
            Room room = new Room();
            if (room.ExistUserInRoom(Master.resultUser))
            {
                int indexRoom = room.ReturnKeyRoomUser(Master.resultUser);

                if (room.CheckDeleteCardsUser(Master.resultUser))
                {
                    room.DeleteCardsUser(Master.resultUser);
                }
                if (room.CheckDeleteUser(indexRoom, Master.resultUser))
                {
                    room.DeleteUser(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckUserInGame(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteUserInGame(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckDeleteCardsWhite(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckDeleteCardsBlack(indexRoom))
                {
                    FunctionsDB.DeleteCardsBlack(indexRoom);
                }
            } 
        }
    }
</script>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link rel="stylesheet" type="text/css" href="css/Style.css" />--%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <%--<div class="card-panel-text">
            <h1 class="h1-text-rules">Le regole del gioco<br />
                <br />
            </h1>
            <p class="paragraph p1">
                Le regole del gioco sono:<br />
                <br />
            </p>
            <ul class="ul-style">
                <li class="color-number-list li-list">1.
                    <i class="paragraph p2">Il numero massimo di giocatori per “stanza” è di 5 persone.<br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">2.
                    <i class="paragraph p2">Il primo che entra nella "stanza" sarà il Master per il primo turno, successivamente nel secondo turno il Master sarà la seconda persona che è entrata nella "stanza", e così via.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">3.
                    <i class="paragraph p2">La Domanda (carta nera) sarà scelta in modo random e tutti i giocatori la vedranno.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">4.
                    <i class="paragraph p2">Ai giocatori che non sono Master si distribuiscono 10 carte Risposta (carta bianca).
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">5.
                    <i class="paragraph p2">I giocatori scelgono, in un periodo limitato di tempo, la carta Risposta da dare al Master, cercando di scegliere la più divertente tra quelle che hanno.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">6.
                    <i class="paragraph p2">Il Master, senza sapere lo username del giocatore che ha scelto una determinata carta (nel caso in cui ci siano più carte risposta, perché la carta domanda ne richiedeva ad esempio 2,
                        <br />&nbsp;&nbsp;&nbsp;sotto le carte saranno ripetuti “User X” così il Master sa le coppie delle carte risposta), legge una ad una le risposte.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">7.
                    <i class="paragraph p2">Il Master, in un periodo limitato di tempo sceglie la carta Risposta che più gli è piaciuta e la dichiara vincitrice, e al vincitore viene assegnato un punto vittoria.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">8.
                    <i class="paragraph p2">Dopo aver deciso il vincitore, sotto le carte vengono visualizzati gli username dei giocatori che hanno giocato le carte.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">9.
                    <i class="paragraph p2">Alla fine del turno a tutti i giocatori vengono assegnate delle nuove carte Risposta per tornare al numero iniziale di 10.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">10.
                    <i class="paragraph p2">Al giocatore, che al primo turno era il Master, gli vengono assegnate 10 carte e il nuovo Master non vedrà più le proprie carte Risposta fino al turno successivo.
                        <br />
                        <br />
                    </i>
                </li>
                <li class="color-number-list li-list">11.
                    <i class="paragraph p2">Una partita dura 20 turni e alla fine vince il giocatore con più punti vittoria.
                        <br />
                        <br />
                    </i>
                </li>
            </ul>
            <p class="paragraph p1">
                <br />
                Esistono ovviamente molte variabili al gioco. Gli stessi creatori invogliano lo sviluppo di nuove forme di gioco e di assegnazione dei punti.<br />
                Si può decidere di inserire un master fisso, o di premiare maggiormente il cinismo o il sadismo delle risposte.
                <br />
                Per questo motivo le regole in questo gioco cambiano un po’ rispetto alle regole del gioco originale.
            </p>
        </div>--%>
        <div class="card-panel-text">
            <h1 class="h1-text-rules">The rules of the game<br />
                <br />
            </h1>
            <p class="paragraph p1">
                The rules are:<br />
                <br />
            </p>
            <ul class="ul-style">
                <li class="color-number-list li-list">1.
                    <asp:Label ID="lbl1" runat="server" Text="The maximum number of players per 'room' is 5 people." CssClass="paragraph" ForeColor="White"></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">2.
                    <asp:Label ID="lbl2" runat="server" Text="The first entering the 'room' will be the master for the first round, then in the second round the Master will be the second 
                        person who has entered the 'room', and so on." CssClass="paragraph" ForeColor="White"></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">3.
                    <asp:Label ID="lbl3" runat="server" CssClass="paragraph" ForeColor="White" Text="The Question (black card) will be chosen randomly and all the players will see it."></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">4.
                     <asp:Label ID="lbl4" runat="server" CssClass="paragraph" ForeColor="White" Text="Players who are not Master will be distribute 10 cards Answer (white paper)."></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">5.
                     <asp:Label ID="lbl5" runat="server" CssClass="paragraph" ForeColor="White" Text="The players choose, in a limited period of time, the Response card to give to the Master, "></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">6.
                     <asp:Label ID="lbl6" runat="server" CssClass="paragraph" ForeColor="White" Text="The Master , without knowing the username of the player who has chosen a given card ( in case there are more response cards, "></asp:Label>
                    <br />
                    <asp:Label ID="lbl7" runat="server" CssClass="paragraph" ForeColor="White" Text='&nbsp;&nbsp;&nbsp;&nbsp;under the cards will be repeated "User X" so the Master knows the response pairs of cards), reads one by one answers.'></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">7.
                     <asp:Label ID="lbl8" runat="server" CssClass="paragraph" ForeColor="White" Text="The Master, in a limited period of time choose response paper that he most liked and declares the winner, and the winner is awarded a victory point."></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">8.
                     <asp:Label ID="lbl9" runat="server" CssClass="paragraph" ForeColor="White" Text="After deciding the winner, under the card displays the username of the players who played the cards."></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">9.
                     <asp:Label ID="lbl10" runat="server" CssClass="paragraph" ForeColor="White" Text="At the end of the round all players are assigned new cards Response to return to the initial number of 10."></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">10.
                     <asp:Label ID="lbl11" runat="server" CssClass="paragraph" ForeColor="White" Text="The player, who in the first round was the Master, are assigned to him 10 cards and the new Master will no longer see their cards Response down to the next round."></asp:Label>
                    <br />
                    <br />
                </li>
                <li class="color-number-list li-list">11.
                     <asp:Label ID="lbl12" runat="server" CssClass="paragraph" Text="A game lasts 20 rounds and in the end the player with the more points win." ForeColor="White"></asp:Label>
                    <br />
                    <br />
                </li>
            </ul>
            <p class="paragraph p1">
                <br />
                There are obviously many variables at play. The creators invite the development of new forms of gaming and allocation of points.<br />
                You may want to enter a fixed master, or more rewarding cynicism or sadism answers.
                <br />
                That is why the rules in this game change a little compared to the original game rules.
            </p>
        </div>
    </div>
</asp:Content>
