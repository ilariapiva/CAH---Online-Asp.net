<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

 <script runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
            //Leggo dalla tabella profilo lo username, partite vinte, partite perse e partite giocate
            String strsql = @"SELECT username, matchesPlayed, matchesWon, matchesMissed 
                            FROM tblAccount WHERE email = '" + Session["userEmail"] + "' ";

            List<Account> result = FunctionsDB.ReadValuesProfileDB(strsql);
            lblMatchesPlayed.Text = Convert.ToString(result[0].MatchesPlayed);
            lblMatchesWon.Text = Convert.ToString(result[1].MatchesWon);
            lblMatchesMissed.Text = Convert.ToString(result[2].MatchesMissed);
            lblUsername.Text = result[3].Username;
            lblEmail.Text = Session["userEmail"].ToString();
        }
    </script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="flat-form-profile">
            <div class="form-action-profile">
                <h1 class="h1">Profile</h1>
                <p class="p5">
                    Qui puoi vedere i tuoi risultati.
                </p>
                <div class="form-horizontal form-text">
                    <ul>
                        <li class="form-control-static p4">E-mail:
                            <asp:Label class="control-label label-form" ID="lblEmail" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Username:
                            <asp:Label class="control-label label-form" ID="lblUsername" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches played:
                            <asp:Label class="control-label label-form" ID="lblMatchesPlayed" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches won:
                            <asp:Label class="control-label label-form" ID="lblMatchesWon" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                        <li class="form-control-static p4">Matches missed:
                            <asp:Label class="control-label label-form" ID="lblMatchesMissed" runat="server"></asp:Label>
                            &nbsp;
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
