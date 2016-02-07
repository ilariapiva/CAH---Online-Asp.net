<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="CAHOnline" %>

<script runat="server">
    
    protected void Page_Load(object sender, EventArgs e)
    {
        String BlackCard = "SELECT TOP 1 * FROM tblBlackCard ORDER BY NEWID()";
        
        Cards blackCard = FunctionsDB.RadomCardBlack(BlackCard);

        lblBlack.Text = blackCard.Text;
        
        String WhiteCards = "SELECT TOP 11 * FROM tblWhiteCard ORDER BY NEWID()";

        List<Cards> cards = FunctionsDB.RadomCardWhite(WhiteCards);
        
        lblWhite1.Text = cards[0].Text;
        lblWhite2.Text = cards[1].Text;
        lblWhite3.Text = cards[2].Text;
        lblWhite4.Text = cards[3].Text;
        lblWhite5.Text = cards[4].Text;
        lblWhite6.Text = cards[5].Text;
        lblWhite7.Text = cards[6].Text;
        lblWhite8.Text = cards[7].Text;
        lblWhite9.Text = cards[8].Text;
        lblWhite10.Text = cards[9].Text;
        lblWhite11.Text = cards[10].Text;
        
    }
</script>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="css/game.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container game-container">
        <div class="row">
            <div class="col-md-3">
                <div class="card-black-container">
                    <div class="black-card">
                         <asp:Label ID="lblBlack" runat="server"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="row">
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite1" runat="server"></asp:Label>
                            </div>
                            <!--<div class="username-card">
                                <p>Matteo</p>
                            </div>-->
                        </div>
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite2" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite3" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite4" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite5" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite6" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite7" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite8" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite9" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                    <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite10" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                     <div class="col-card-fixed">
                        <div class="card-container">
                            <div class="white-card">
                                <asp:Label ID="lblWhite11" runat="server"></asp:Label>
                            </div>
                            <div class="username-card"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>